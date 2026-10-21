# Working on this repository

One agent skill, `skills/smart-inbox/`, in the Agent Skills format. The repo is
also a Claude Code marketplace: the plugin `smart-inbox` is the repo root and
exposes the folder in `skills/`.

## Rules

- English only: skills, docs and commit messages.
- Commits are a single line, `type(module): message`, with no body or footer.
- Every API must be correct for the `laravel/ai` and Laravel versions the skill
  targets. When unsure, check the docs before writing it.
- Keep `SKILL.md` focused on rules and workflow; code-heavy patterns live in
  `references/`.
- The skill must work on its own. [`laravel-skills`](https://github.com/mgamalhz/laravel-skills)
  is optional: reference its skills by name where they help, but keep the
  essential checks in this skill.
- After any change: `claude plugin validate .` must pass.

## Deployment

The landing page in `site/` is released by pushing to `main` and pulling on the
server. Follow [DEPLOYMENT.md](DEPLOYMENT.md).
