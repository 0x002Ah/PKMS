# Roadmap

Staged milestones for PKMS. Each milestone is intentionally small and inspectable. We do not start a milestone until the previous one is in a working state.

## M0 — Repository scaffold

- Repo layout (`src/`, `scripts/`, `system/`, `examples/`, `tests/`, `docs/`).
- `.gitignore` that excludes secrets, raw captures, artifacts, and large binaries.
- `README.md`, `AGENTS.md`, `CLAUDE.md` defining repo scope and agent rules.
- `docs/architecture.md` describing the local PKMS split.
- No runtime code yet.

**Done when:** an agent can read the repo cold and know what may and may not be added.

## M1 — Capture contract

- Capture surfaces: personal Telegram bot, bulk imports, manual drops.
- All captures land in the local `inbox/` directory in the format defined by `docs/inbox-format.md`.
- **Raw preservation is the contract.** Items in `inbox/` are not rewritten or deleted by the capture path.

**Done when:** the chosen capture surfaces produce well-formed inbox entries and any raw item can be recovered byte-for-byte after the fact.

## M2 — Triage contract

- Agent reads from `inbox/` and produces **derived markdown** in the vault: a note, list update, entity record, or project update.
- The raw inbox item is left intact; nothing is silently deleted, and rejections are logged.
- The promotion rule — what becomes durable markdown knowledge and what stays raw — is documented alongside the triage logic.

**Done when:** a triage session reliably produces vault-quality markdown from inbox items without losing the raw source, and the promotion rule is written down.

## M3 — Retrieval over markdown

- First implementation: plain-text retrieval using `grep` / `ripgrep` over the vault, plus Obsidian's built-in search.
- Add a smarter layer only if practical pain shows up — a simple local indexer, or GBrain as an agent-agnostic knowledge layer.
- Smart retrieval is **additive**: per `docs/architecture.md`, the markdown substrate remains the source of truth.

**Done when:** the user can find any vault note within seconds via the plain-text path, and the trigger for adding a smarter layer is written down.

## M4 — Agent memory experiments

- Evaluate runtime memory providers (e.g. Honcho, Mem0, Hindsight) as a layer **on top of** the accumulated markdown substrate.
- Per `docs/architecture.md`, any such provider is a derived artifact — rebuildable from `inbox/` + `vault/` + `software/`.
- Compare providers on retrieval quality, continuity across sessions, and inspectability.

**Done when:** at least one memory provider is integrated against the existing markdown corpus and a written comparison documents its fit and trade-offs.

## Beyond M4

Memory providers may compete for the Archivist / runtime-memory role, but canonical identity and memory ethics require a **durable substrate plus a documented promotion protocol**. No runtime memory layer may become the only place where knowledge exists. None of these later directions are committed yet.
