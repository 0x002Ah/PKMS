# Audio attachment stub

In a real voice capture this file is `recording.m4a` (or `.wav`, `.ogg`, etc.).
The repository's pre-commit guard refuses binary audio files, so the example
ships this Markdown placeholder in its place.

A real connector writes the actual recording here and lists it in
`meta.json` under `attachments`, for example:

```json
"attachments": ["attachments/recording.m4a"]
```
