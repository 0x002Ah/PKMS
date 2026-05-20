# Inbox capture format — `inbox/v1`

The contract every PKMS connector targets when writing into the local `inbox/`
directory. New connectors, triage tooling, and any future memory/index layer
all read against this spec. Do not deviate without bumping `spec_version`.

## Capture package

One capture is one directory under `inbox/`:

```
inbox/<YYYYMMDDTHHMMSSZ>-<source>-<short_id>/
├── body.md          required — human-readable content of the capture
├── meta.json        required — machine metadata
└── attachments/     optional — original binaries, only when needed
```

- `<YYYYMMDDTHHMMSSZ>` — UTC timestamp in ISO 8601 basic format (no separators).
- `<source>` — lowercase short identifier of the producing connector.
- `<short_id>` — first 12 hex characters of `sha256("<source>:<source_ref>")`. Deterministic from the upstream item, so a retry produces an identical directory name and natural deduplication.

Capture directories sit flat at the top of `inbox/`. No date-tree or
source-tree at this milestone — `inbox/` is a transient queue; items move out
during triage rather than accumulating.

## `body.md`

Human-readable content of the capture. Always present, even when the canonical
content is binary (in which case `body.md` is a brief stub describing or
transcribing it).

Plain Markdown. **No YAML frontmatter** — all metadata lives in `meta.json` so
there is exactly one source of truth.

## `meta.json`

Strict JSON, UTF-8, one object.

### Required fields

| Field          | Type   | Notes |
|----------------|--------|-------|
| `spec_version` | string | Always `"inbox/v1"` for this revision. |
| `source`       | string | Lowercase identifier of the producing connector (e.g. `"telegram"`, `"voice"`, `"manual"`). |
| `source_ref`   | string | Opaque, connector-defined reference to the upstream item. `<source>` + `<source_ref>` uniquely identifies the capture across the PKMS. |
| `captured_at`  | string | ISO 8601 UTC timestamp of when the connector observed the item, e.g. `"2026-05-20T14:30:12Z"`. |
| `content_type` | string | MIME type describing the canonical content of the capture (see below). |

### Optional fields

| Field             | Type     | Notes |
|-------------------|----------|-------|
| `tags`            | string[] | User-provided tags captured at the source (e.g. hashtags in a message). |
| `attachments`     | string[] | Relative paths of files inside `attachments/`. Present iff `attachments/` exists. |
| `body_format`     | string   | Shape of `body.md` when it is a derived view. Convention: `"raw"` (default if absent), `"transcript"`, `"clipping"`, `"summary"`. Free-form. |
| `source_metadata` | object   | Connector-specific extra fields. Opaque to common tooling; the home for chat ids, recording metadata, URLs, etc. |

### `content_type` conventions

`content_type` describes the canonical content of the capture, not `body.md`'s
file format.

- `text/plain` / `text/markdown` — text-native captures (chat messages, manual notes).
- `text/uri-list` — link clippings; the URL is the canonical content, `body.md` is a human view.
- `audio/m4a`, `audio/wav`, `audio/ogg` — voice captures; the raw recording lives under `attachments/`.
- `image/jpeg`, `image/png` — image captures.
- `application/pdf` — PDF captures.

When the canonical content is binary, the binary lives under `attachments/` and
`body.md` is a short stub.

## Atomicity

Connectors write the capture package to a temporary directory (e.g.
`inbox/.tmp-<short_id>/`) and `rename` it into place once `body.md`,
`meta.json`, and any `attachments/` are fully written. Triage tools must not
observe partially-written captures.

## Out of scope at M1

Deliberately not part of this spec. Adding any of these requires a
`spec_version` bump:

- **Triage state.** Triage moves files out of `inbox/`; it does not mutate them in place.
- **Memory/index layer fields.** Embeddings, vector ids, derived scores. Any memory layer keys on `<source>:<source_ref>` plus `captured_at` and stores its own derivatives externally.
- **Connector-specific top-level fields.** Keep them inside `source_metadata`.

## Examples

Fake captures realizing this spec live under
[`examples/inbox/`](../examples/inbox/): manual text note, Telegram message,
voice note with attachment stub, and link clipping.
