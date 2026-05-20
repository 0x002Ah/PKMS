# Architecture

PKMS is split across several local directories on the user's machine. Only one of them — this repository — is intended to be public. The rest stay local and private.

## Local layout

```
~/PKMS/
├── software/    <- this repository (public-safe)
├── vault/       <- private knowledge content
├── inbox/       <- raw captures from connectors
├── secrets/     <- credentials and tokens
├── artifacts/   <- heavy or generated local files
├── config/      <- local non-secret configuration
└── logs/        <- durable operational records
```

The exact root path is the user's choice; the split is what matters.

## Responsibilities

### software/ (this repo)
- Connectors, scripts, agent and system instructions.
- Documentation, examples, tests.
- No user content. No secrets. No runtime data.
- Designed for open-source release.

### vault/
- The user's curated personal knowledge base (e.g. an Obsidian vault).
- Written to deliberately, after triage. Source of truth for refined notes.
- Typically kept as its own private git repository on the user's machine. It is never a submodule, remote, or dependency of this repo.
- Private. Never referenced by absolute path from this repo.

### inbox/
- Raw, untriaged captures produced by connectors (Telegram, voice, clippings, etc.).
- Append-only from the connector's perspective; agents read and move items into the vault during triage.
- Private and noisy by design.

### secrets/
- API keys, tokens, OAuth credentials, signing keys.
- Read by connectors and scripts at runtime via env vars or explicit paths.
- Never read or written by code that does not need them.

### artifacts/
- Disposable PKMS runtime byproducts only: model caches, embeddings, generated exports, derived transcripts, temporary attachments, and similar operational outputs.
- Reproducible from inbox + vault + software, so it is safe to delete and rebuild.
- Not a store for durable work products, canonical outputs, signed documents, decisions, source materials, or evidence-bearing artifacts. Those belong in a separate, explicitly governed location.

### config/
- Local, non-secret configuration consumed by connectors, agents, and any future memory/index layer.
- Plain text (TOML / YAML / JSON / `.env.example`): paths, feature flags, layer wiring, named profiles.
- Machine-specific and hand-edited. Never holds credentials — those stay in `secrets/`.

### logs/
- Durable operational records: agent and connector decisions, triage outcomes, run summaries, error reports.
- Append-only and user-reviewable. Distinct from `artifacts/` because these records are not disposable.
- Holds no raw captured content (that stays in `inbox/`) and no curated knowledge (that goes to `vault/`).

## Data flow

```
connector ──► inbox/  ──► agent triage ──► vault/
                  │                            │
                  └──► artifacts/ (caches, derived data)
```

Secrets are injected into connectors and agents at runtime; they never flow into inbox, vault, or artifacts.

## Knowledge substrate

The canonical PKMS knowledge substrate is **markdown in git**. Notes are plain text files in version-controlled directories; durable meaning lives in those files and in their history.

Any runtime memory system — vector database, graph database, agent memory provider, embedding index, in-memory cache, or API-backed memory service — is a **derived artifact** unless explicitly promoted by protocol. Derived runtime stores do not all have to live in the same place: small generated outputs may live under `artifacts/`, while larger service state, indexes, vector stores, or database volumes should live in local runtime / index directories **outside this public repo**. In every case they remain reproducible from `inbox/` + `vault/` + `software/`, disposable, and non-canonical unless explicitly promoted by protocol.

Durable user-owned meaning must remain **readable, inspectable, version-controlled, and portable** without a specific vendor or service. Anything that fails any of those four tests does not qualify as durable substrate.

Smart memory layers — retrieval, user modeling, belief tracking, agent continuity, and similar — may be added later. They serve the substrate, not replace it: they must not become the only place where knowledge exists, and they must be rebuildable from the markdown-in-git substrate plus the protocols that govern their promotion.

## Why this split

- **Blast radius.** A mistake in `software/` cannot leak private content because private content is not here.
- **Publishability.** This repo can be made public without an audit of every file.
- **Reproducibility.** `artifacts/` is disposable; `inbox/` and `vault/` are the durable user-owned state.
- **Local-first.** No remote service is required to read or back up the data.
