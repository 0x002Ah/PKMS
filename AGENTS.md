# AGENTS.md

Operational rules for any AI agent working in this repository.

## Repository scope

This repo is the **software layer** of PKMS only: connectors, scripts, docs, examples, tests, and agent/system instructions. It is intended to be publishable as open source.

The following live **outside** this repo on the local machine and must never be copied in:

- `vault/` — private knowledge content
- `inbox/` — raw captures
- `secrets/` — credentials, tokens, API keys
- `artifacts/` — heavy or generated local files
- runtime logs and caches

See `docs/architecture.md` for the full split.

## Hard rules

1. Keep every change suitable for an eventual public release.
2. Never commit private content, raw captures, secrets, credentials, tokens, local artifacts, logs, or large binaries. If unsure, do not commit.
3. Respect the local pre-commit guard at `scripts/precommit_guard.sh` (installed via `scripts/install_hooks.sh`). It blocks private subtrees, secret-like filenames, disallowed file types, and files larger than 1 MiB. Do not bypass it with `--no-verify` unless the user explicitly asks.
4. Do not build integrations that require real credentials yet. Use placeholders and document the contract instead.
5. Prefer simple, inspectable, local-first design over cloud services or hidden state.
6. Before any `git commit`, run `git status` and explain to the user exactly what will be committed.
7. Edit existing files in preference to creating new ones. Do not add docs the user did not ask for.

## Working conventions

- One concern per change. Avoid drive-by refactors.
- Code should be readable without comments; reserve comments for non-obvious *why*.
- Keep `docs/` short and operational. Long-form context belongs in commit messages or PR descriptions.
- When in doubt about scope or privacy, ask the user before acting.

## Current milestone

See `docs/roadmap.md`. The repo is at **M0 — scaffold**. Do not implement connectors (e.g. Telegram) until their milestone is reached.
