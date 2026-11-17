# Agent Instructions (`AGENTS.md` / `GEMINI.md`)

This repository hosts reusable AI agent skills for `mayank201181`, usable across **Google Gemini (`gemini.google.com`)**, **Google Jules (`jules.google`)**, **Google Antigravity**, and **Claude Code / Claude Web (`claude.ai/code`)**.

## Available Skills

### `studyguide` — [skills/studyguide/SKILL.md](./skills/studyguide/SKILL.md)
Whenever asked to build, expand, or audit a school study-guide and question-bank dashboard (for any year group, exam board, or subject):
1. Read **[skills/studyguide/SKILL.md](./skills/studyguide/SKILL.md)** and **[skills/studyguide/references/grader-and-audit-checklist.md](./skills/studyguide/references/grader-and-audit-checklist.md)** in full before writing any code or content.
2. Scaffold from the hardened v2 skeleton via `./skills/studyguide/scripts/scaffold-from-v2.sh <target-dir>` (automatically shallow-clones `https://github.com/mayank201181/Year8geography.git` or `Year8chinese.git` when running in a Cloud VM without local files).
3. Enforce zero-login open access with synchronous iPad `localStorage` persistence, the persistent all-screen bottom dock (`Home · Topics · Watch · Sitcom · Daily 5 · Review · Progress`), and the mandatory **4-layer blind-solver & adversarial auto-grader cross-check** (`100.0%` cold blind agreement, `0` positional MCQ traps, `0` stem-copy exploits).
4. Commit as `mayank201181 <mayank2011@gmail.com>` so Vercel builds trigger cleanly.
