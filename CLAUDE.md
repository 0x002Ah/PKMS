# CLAUDE.md

Claude Code instructions for this repository. Read `AGENTS.md` first — those rules apply to you too.

## Before you act

- This repo is **public-safe software only**. Private vault, inbox, secrets, artifacts, config, and logs live elsewhere on the local machine. Never copy them in.
- The repo is at milestone **M0 — scaffold** (see `docs/roadmap.md`). Do not pre-build later milestones (e.g. the Telegram connector) without being asked.

## How to work here

- Match the existing style. Prefer editing existing files over creating new ones.
- Keep diffs small and reviewable. One concern per change.
- Do not add files the user did not request — especially extra docs, READMEs, or planning notes.
- No emojis unless the user explicitly asks for them.

## Commits

- Always run `git status` and summarize the staged changes before committing.
- Never `git add -A` or `git add .` blindly — stage specific paths so we cannot accidentally include private files from sibling directories.
- Never commit anything matching `.gitignore` patterns (secrets, credentials, raw captures, large binaries).
- Respect the pre-commit guard installed via `scripts/install_hooks.sh`. Do not bypass it with `--no-verify`.

## When unsure

Ask the user. Privacy boundaries and milestone scope are the two areas where guessing is expensive.
