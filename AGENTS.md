# Working on this repository

One agent skill, `skills/laravel-ai-brain/`, in the Agent Skills format. The
repo is also a Claude Code marketplace: the plugin `laravel-ai-brain` is the
repo root and exposes the folder in `skills/`.

## Rules

- English only: skills, docs and commit messages.
- Commits are a single line, `type(module): message`, with no body or footer.
- Every API must be correct for the `laravel/ai` and Laravel versions the skill
  targets. When unsure, check the docs before writing it.
- Keep `SKILL.md` focused on rules and workflow; code-heavy patterns live in
  `references/`.
- Security, performance, structure and verification belong to
  [`laravel-skills`](https://github.com/mgamalhz/laravel-skills). Reference those
  skills by name instead of repeating their content here.
- After any change: `claude plugin validate .` must pass.
