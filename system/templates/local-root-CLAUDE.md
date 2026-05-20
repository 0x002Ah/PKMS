# Local PKMS Environment Instructions

This file is a **template**.
Copy it to `~/PKMS/CLAUDE.md` (or whichever path you chose for your local
PKMS root).
It tells any agent how to behave when working in the local environment that
surrounds this repository.

Adapt machine-specific notes if your layout diverges, but keep the privacy
boundaries and operating modes intact.
They are what makes the local layout safe.

## Repositories and boundaries

- `software/` — the public PKMS software repository (this codebase, cloned
  locally).
- `vault/` — private curated personal knowledge.
  Likely a separate private repository on the same machine.
  Never copy its content into `software/`.
- `inbox/` — local raw captures in the `inbox/v1` format.
  Never committed to `software/`.
- `secrets/` — credentials, tokens, API keys.
  **Agents must never read, print, copy, summarize, or commit anything from
  here.**
- `artifacts/` — disposable PKMS runtime byproducts (caches, derived data).
- `config/` — local, non-secret configuration.
  Machine-specific.
- `logs/` — durable operational records (decision logs, run summaries).

See `software/docs/architecture.md` for the full rationale behind the split.

## Operating modes

### Software mode

For tasks about code, docs, tests, scripts, agent rules, or the public PKMS
repository:

- Work inside `software/`.
- Use `software/` as the Git root.
- Follow `software/CLAUDE.md` and `software/AGENTS.md`.
- Do not copy `vault/`, `inbox/`, `secrets/`, `artifacts/`, `config/`, or
  `logs/` content into `software/`.
- Respect the software repo pre-commit guard.
- Do not bypass hooks with `--no-verify` unless explicitly instructed.

### Local environment mode

For tasks about local folder layout, inbox, vault scaffolding, artifacts, or
local-machine organization:

- Work from the PKMS root (`~/PKMS` by default).
- Do not initialize Git in the PKMS root.
- Do not move private local data into `software/`.
- Do not read, print, summarize, or modify `secrets/`.
- Ask before deleting or reorganizing existing private content.
- Prefer small, reversible filesystem changes.

## General rules

- Keep changes simple and inspectable.
- Do not ingest real personal data until explicitly asked.
- Do not implement integrations requiring real credentials until explicitly
  asked.
- If a task could affect both `software/` and private local areas, explain the
  boundary before acting.
