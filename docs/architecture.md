# Architecture

PKMS is split across several local directories on the user's machine. Only one of them — this repository — is intended to be public. The rest stay local and private.

## Local layout

```
~/PKMS/
├── software/    <- this repository (public-safe)
├── vault/       <- private knowledge content
├── inbox/       <- raw captures from connectors
├── secrets/     <- credentials and tokens
└── artifacts/   <- heavy or generated local files
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

## Data flow

```
connector ──► inbox/  ──► agent triage ──► vault/
                  │                            │
                  └──► artifacts/ (caches, derived data)
```

Secrets are injected into connectors and agents at runtime; they never flow into inbox, vault, or artifacts.

## Why this split

- **Blast radius.** A mistake in `software/` cannot leak private content because private content is not here.
- **Publishability.** This repo can be made public without an audit of every file.
- **Reproducibility.** `artifacts/` is disposable; `inbox/` and `vault/` are the durable user-owned state.
- **Local-first.** No remote service is required to read or back up the data.
