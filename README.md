# Laravel AI brain

An agent skill that adds a "brain" to an existing Laravel application: the
system notices what deserves attention, explains why, and suggests the next
step, instead of only showing numbers. It works with Claude Code, Cursor, Codex
and any agent that reads the [Agent Skills](https://agentskills.io) format.

> `0.x`: first version, being tested on real projects.

## What it builds

| Shape | Example |
|---|---|
| **Triage** | Every new message, ticket, dispute or review gets a category, a priority, a one-line reason and a suggested reply. |
| **Insights** | A morning briefing: regular customers who stopped ordering, a coupon that brings customers who never return, a branch turning people away. |
| **Ask** | The owner asks "why was last month weaker?" and gets an answer built from the app's own numbers. |

## How it is different

Most "AI on your data" tools let the model write SQL or chat freely over the
database. This skill does the opposite:

- **The code computes every number.** The model reads facts, judges, ranks and writes.
- **The model never touches the database** and has no tools that write, send or spend.
- **Tenant isolation, prompt injection, cost and failure** are handled by design,
  not left to the prompt.
- **It says "not enough data yet"** instead of guessing.
- **It proposes before it builds:** the agent reads the app, lists the decisions
  the business makes, and suggests where AI helps and where a plain rule is enough.

Built on the official [`laravel/ai`](https://laravel.com/docs/ai-sdk) SDK, so it
works with any provider the SDK supports.

## Install

**Claude Code**

```bash
/plugin marketplace add mgamalhz/laravel-ai-brain
/plugin install laravel-ai-brain@laravel-ai-brain
```

**Any agent** (via [skills.sh](https://skills.sh))

```bash
npx skills add mgamalhz/laravel-ai-brain
```

## Requires

[`laravel-skills`](https://github.com/mgamalhz/laravel-skills) for the security,
performance, architecture and done-checklist reviews this skill runs before
calling a feature done:

```bash
/plugin marketplace add mgamalhz/laravel-skills
/plugin install laravel-engineering@mgamalhz
```

## Use it

Ask your agent, in a Laravel project:

> Add a brain to this app.

or be specific:

> Triage incoming messages for profile owners.

## License

MIT
