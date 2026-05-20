# Roadmap

Staged milestones for PKMS. Each milestone is intentionally small and inspectable. We do not start a milestone until the previous one is in a working state.

## M0 — Repository scaffold

- Repo layout (`src/`, `scripts/`, `system/`, `examples/`, `tests/`, `docs/`).
- `.gitignore` that excludes secrets, raw captures, artifacts, and large binaries.
- `README.md`, `AGENTS.md`, `CLAUDE.md` defining repo scope and agent rules.
- `docs/architecture.md` describing the local PKMS split.
- No runtime code yet.

**Done when:** an agent can read the repo cold and know what may and may not be added.

## M1 — Local capture/inbox convention

- Define the on-disk format for raw captures in the local `inbox/` directory (outside this repo).
- Pick file naming, metadata (source, timestamp, content type), and directory layout.
- Document the contract in `docs/` so future connectors can target it without coordination.
- Provide an `examples/` walkthrough using fake captures only.

**Done when:** a new connector can be written against the spec without reading any other connector's code.

## M2 — Telegram capture connector

- Implement a connector that receives messages from a personal Telegram bot and writes them to `inbox/` in the M1 format.
- Credentials live in local `secrets/`, never in this repo.
- Connector is a small, restartable local process.
- Tests use recorded fixtures, not live API calls.

**Done when:** sending a message to the bot reliably produces a well-formed inbox entry.

## M3 — Agent-assisted triage

- Agent reads new items from `inbox/`, proposes classification and routing, and asks the user for confirmation.
- Triaged items are moved to a holding area or rejected; nothing is silently deleted.
- Triage decisions are logged locally in a form the user can review.

**Done when:** the user can clear an inbox of mixed items in one short triage session, with the agent doing the heavy lifting.

## M4 — Obsidian / vault integration

- Triaged items are written into the user's vault in a format Obsidian understands (Markdown + frontmatter, wikilinks, attachments).
- Vault path is configured locally; this repo holds no vault content.
- Round-trip: an item captured via M2, triaged via M3, lands as a usable note in the vault.

**Done when:** the full pipeline — capture → inbox → triage → vault — works end-to-end on the user's machine.

## Beyond M4

Out of scope for now. Likely candidates once the core loop is solid: voice capture, web clipper, search/retrieval over the vault, periodic review agents. None of these are committed.
