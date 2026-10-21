# Ask: questions on demand

Use when the owner wants to ask "why was last month weaker?" or "which branch
needs attention?" Build triage or insights first; ask is the most expensive and
least predictable shape, and it is only as good as its tools.

## Tools, not SQL

The agent gets read-only tools that call the same code the dashboard uses:

```php
class RevenueByMonth implements Tool
{
    public function __construct(private Tenant $tenant) {}

    public function description(): string
    {
        return 'Revenue and order count per month for the last 12 complete months.';
    }

    public function handle(Request $request): string
    {
        return json_encode(app(RevenueReport::class)->monthly($this->tenant, months: 12));
    }

    public function schema(JsonSchema $schema): array
    {
        return [];
    }
}
```

- The tenant comes from the constructor, never from the model's arguments.
- Every tool is bounded (fixed periods, `limit()`), and returns computed numbers.
- No tool writes, sends or spends. If an action is ever needed, it goes through
  the app's normal UI, or an `Approvable` tool whose approval a person gives.

## The agent

- Instructions: answer only about this business, use only numbers returned by
  tools, say plainly when the tools cannot answer or the data is too thin, and
  keep answers short with one recommendation when it helps.
- The question goes inside `<question>` tags and is treated as data.
- Cap tool rounds with `#[MaxSteps(...)]` and set `#[Timeout(...)]`.

## Guardrails

- Rate limit per user and per tenant per day (`RateLimiter::for(...)`), and
  return a friendly message when the limit is reached.
- With `RemembersConversations`, `continue()` does not check who owns the
  conversation. Authorize it yourself before continuing.
- Log the question, the tools called and the usage, per tenant, for cost and
  for finding questions the tools cannot answer yet.
