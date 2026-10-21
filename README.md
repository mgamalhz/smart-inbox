# Smart Inbox

Turn any inbox in your Laravel app into a smart one. Contact messages, reviews,
support requests, disputes: each new item gets a **category**, a **priority**, a
**one-line reason** and a **draft reply**, so the important ones never get lost
between spam and small questions.

It is an [agent skill](https://agentskills.io): your coding agent (Claude Code,
Cursor, Codex...) reads it and builds the feature inside your own app, with your
data, your design and your stack.

> `0.x`: tested on real projects, still improving.

Demo and details: [smart-inbox.mgamalhz.com](https://smart-inbox.mgamalhz.com)

## Install

```bash
npx skills add mgamalhz/smart-inbox
```

or in Claude Code:

```bash
/plugin marketplace add mgamalhz/smart-inbox
/plugin install smart-inbox@smart-inbox
```

## Use

In a Laravel project, ask your agent:

> Add a smart inbox to this app.

It finds the inboxes in your app, agrees the labels with you, builds it, and
tests it on realistic fake data before anything real is sent.

## What it builds

- Labels that fit your business (brand deal, booking, complaint, spam...).
- A priority and a one-line reason for every item.
- A draft reply or next step, never sent automatically.
- A switch, off by default: with it off, your inbox looks exactly as before.
- Tabs with counts, "Wrong label?" feedback, tests, a fixture set and an eval command.

## What it never does

- Reply, delete or change anything on its own.
- Decide disputes, refunds or anything involving money.
- Let the AI write SQL or touch your database.
- Send names, emails or phone numbers to the AI provider.

Built on the official [`laravel/ai`](https://laravel.com/docs/ai-sdk) SDK, so it
works with Anthropic, OpenAI, Gemini and the other providers it supports.

Works even better with [`laravel-skills`](https://github.com/mgamalhz/laravel-skills)
for security, performance and done-checklist reviews.

## License

MIT
