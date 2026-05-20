# Setting up a local PKMS environment

This walkthrough reproduces the local PKMS layout on a fresh machine.
The layout is a small set of sibling directories rooted at a path of your
choice (this guide uses `~/PKMS`).
Only one of those directories — `software/` — is a Git repository.

For the rationale behind the split, see [`architecture.md`](architecture.md).

## Prerequisites

- Git installed.
- Shell access (`bash` or `zsh`).
- A couple of minutes.

## Steps

### 1. Create the local PKMS root

Pick a path and create the sibling directories:

```sh
mkdir -p ~/PKMS/{software,vault,inbox,secrets,artifacts,config,logs}
```

Do **not** run `git init` in `~/PKMS`.
The local root is a workspace, not a repository.
Versioning belongs inside the individual subdirectories.

### 2. Clone this repository into `software/`

```sh
REPO_URL="git@github.com:your-user/PKMS.git"
git clone "$REPO_URL" ~/PKMS/software
```

Replace the example URL with your own fork or the original repository URL.

### 3. Install the pre-commit guard

The guard refuses commits that would leak private content, secrets, or large
binaries from sibling directories into the public software repo.
It is the primary safety net for working in this layout.

```sh
cd ~/PKMS/software
./scripts/install_hooks.sh
```

### 4. Add the local-root agent instructions

Copy the template at
[`software/system/templates/local-root-CLAUDE.md`](../system/templates/local-root-CLAUDE.md)
to `~/PKMS/CLAUDE.md`.
Any agent working from the PKMS root reads this file to learn the operating
modes and privacy boundaries.

```sh
cp ~/PKMS/software/system/templates/local-root-CLAUDE.md ~/PKMS/CLAUDE.md
```

### 5. Keep `vault/` private and separate

`vault/` holds your curated personal knowledge.
It is intended to be its own private repository on the same machine.
Never make it a submodule, remote, or dependency of this repo.
Set it up at your own pace; nothing in `software/` needs it to function.

### 6. Treat `secrets/` as off-limits to agents

`secrets/` holds credentials, tokens, and API keys.
Agents must never read, print, copy, summarize, or commit anything from this
directory.
The template copied in step 4 enforces this rule; do not relax it.

## Sibling directories at a glance

| Directory    | Purpose                                  | Visibility                        |
|--------------|------------------------------------------|-----------------------------------|
| `software/`  | Public PKMS code, docs, examples         | Public (this repo)                |
| `vault/`     | Curated personal knowledge               | Private                           |
| `inbox/`     | Raw captures (`inbox/v1` format)         | Private                           |
| `secrets/`   | Credentials, tokens, API keys            | Private; agents must not read it  |
| `artifacts/` | Disposable runtime byproducts            | Private                           |
| `config/`    | Local, non-secret configuration          | Private                           |
| `logs/`      | Durable operational records              | Private                           |

## What's next

The repo is at milestone **M1 — inbox capture contract**.
The on-disk capture format is documented in
[`inbox-format.md`](inbox-format.md) with fake examples under
`software/examples/inbox/`.
There is no runtime code yet; connectors arrive with M2 (see
[`roadmap.md`](roadmap.md)).
