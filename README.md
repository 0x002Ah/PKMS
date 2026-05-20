# PKMS

Agent-driven, local-first personal knowledge management system.

PKMS captures inputs (notes, messages, links, files) into a local inbox, then uses agents to triage, enrich, and route them into a personal knowledge vault that the user owns and controls.

## What this repository is

The **software layer** of PKMS: connectors, scripts, agent and system instructions, documentation, examples, and tests. It is designed to be publishable as open source.

## What this repository is NOT

Private content and runtime data live elsewhere on the local machine and must never be added to this repo:

- **vault** — private knowledge content
- **inbox** — raw captures from connectors
- **secrets** — credentials, tokens, API keys
- **artifacts** — disposable runtime byproducts (caches, derived data)
- **config** — local, non-secret configuration
- **logs** — durable operational records

See [`docs/architecture.md`](docs/architecture.md) for the full split and [`docs/roadmap.md`](docs/roadmap.md) for staged milestones.

## Principles

- **Local-first.** The user's data lives on the user's machine. Cloud services are optional adapters, never the source of truth.
- **Inspectable.** Plain files, plain text, small scripts. Prefer code that a human can read and audit in one sitting.
- **Agent-driven, not agent-owned.** Agents propose and execute; the user keeps the final say and the data.
- **Public-safe by default.** Anything in this repo must be safe to share. Private content is segregated by directory, not by convention.
- **Minimal moving parts.** No service is added until a milestone requires it.

## Repository layout

```
docs/      design notes and architecture
src/       source code for connectors and utilities
scripts/   one-off and operational scripts
system/    agent and system prompts / instructions
examples/  example inputs, configs, and walkthroughs
tests/     tests
```

## Local setup

After cloning, install the local pre-commit guard so accidental commits of
secrets, private PKMS content, or large binaries are refused before they leave
your machine:

```sh
./scripts/install_hooks.sh
```

This writes `.git/hooks/pre-commit`, which delegates to
[`scripts/precommit_guard.sh`](scripts/precommit_guard.sh). The guard inspects
only staged files, performs filename/path/size checks (no content scanning, no
dependencies), and can be bypassed in an emergency with `git commit --no-verify`.

## For agents working in this repo

Read [`AGENTS.md`](AGENTS.md) (and [`CLAUDE.md`](CLAUDE.md) if you are Claude Code) before making changes.

## Status

Milestone **M0 — repository scaffold**. See [`docs/roadmap.md`](docs/roadmap.md).
