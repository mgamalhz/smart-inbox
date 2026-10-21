# Insights: periodic, across many facts

Use for a briefing or a set of cards: "three customers are fading", "this
coupon brings people who never come back", "this branch turns customers away".
The code finds and measures the situations; the model decides what matters most
today, explains it and suggests a step.

## Signals

A signal is one question the code answers about the business, returning facts.
Write one class per signal.

```php
namespace App\Ai\Signals;

interface Signal
{
    /** Stable id, used to tie the model's output back to these facts. */
    public function key(): string;

    /** Facts for one tenant. Return [] when there is nothing to report. */
    public function facts(Tenant $tenant): array;
}
```

```php
class FadingRegularCustomers implements Signal
{
    private const MIN_PAST_ORDERS = 4;

    public function key(): string
    {
        return 'fading-regular-customers';
    }

    public function facts(Tenant $tenant): array
    {
        $before = fn ($q) => $q->whereBetween('created_at', [now()->subDays(180), now()->subDays(60)]);
        $recent = fn ($q) => $q->where('created_at', '>=', now()->subDays(60));

        // whereHas with a count works on MySQL and PostgreSQL; HAVING on a withCount alias does not.
        $rows = Customer::query()
            ->whereBelongsTo($tenant)
            ->whereHas('orders', $before, '>=', self::MIN_PAST_ORDERS)
            ->whereDoesntHave('orders', $recent)
            ->withCount(['orders as orders_before' => $before])
            ->orderByDesc('orders_before')
            ->limit(20)
            ->get(['id', 'name']);

        return $rows->isEmpty() ? [] : [
            'customers' => $rows->map(fn ($c) => ['id' => $c->id, 'name' => $c->name, 'orders_before' => $c->orders_before])->all(),
            'total' => $rows->count(),
            'rule' => 'at least '.self::MIN_PAST_ORDERS.' orders between 180 and 60 days ago, none since',
        ];
    }
}
```

Rules for signals:

- Scoped to the tenant like every other query, bounded with `limit()`, and
  indexed (run `laravel-performance` on them).
- They return only what the model needs, with the sample size and the rule
  that produced them.
- When data is too thin, return `['insufficient' => true, 'have' => ..., 'need' => ...]`
  instead of a weak conclusion.

## Generation

- A scheduled command dispatches one queued job per active tenant (skip tenants
  with no recent activity, so cost follows usage).
- The job collects every signal's facts, hashes them, and stops if the hash
  equals the last stored briefing's hash: nothing changed, no call.
- An agent with structured output receives the facts keyed by signal and returns:
  `headline` (one sentence), and `insights[]` with `signal_key`, `priority`
  (enum), `title`, `explanation`, `action`.
- Drop any insight whose `signal_key` was not in the input.
- Store the briefing with the facts hash, model, prompt version and usage.
  Numbers shown on cards come from the stored facts, not from the model's text.

## UI

- Cards ordered by the model's priority, each with its explanation and a
  concrete action, and a link to the screen where the user can act.
- "Generated this morning at 07:00" so the user knows how fresh it is.
- An empty state that says nothing needs attention, rather than a blank area.
- Optional: the same briefing as a short morning message (email, push or
  WhatsApp through the app's existing channel), sent by a job, never by the model.
