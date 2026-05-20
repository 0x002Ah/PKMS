#!/usr/bin/env bash
# PKMS pre-commit safety guard.
#
# Inspects staged files (added/copied/modified) and refuses the commit if any
# look like secrets, private PKMS data, large binaries, or other content that
# does not belong in the public software repository.
#
# Intentionally simple: only filename, path, and size checks. No content
# scanning, no external dependencies. Bypass with `git commit --no-verify`
# (please don't, unless you are sure).

set -euo pipefail
shopt -s nocasematch

# Files larger than this (bytes) are rejected. 1 MiB.
MAX_SIZE=$((1024 * 1024))

PROBLEMS=""

add_problem() {
    PROBLEMS+="  - $1"$'\n'
}

is_blocked_path() {
    local f=$1
    case "$f" in
        # Private PKMS subtrees that must never live inside this repo.
        vault/*|inbox/*|secrets/*|artifacts/*|config/*|attachments/*|raw/*|private/*) return 0 ;;
        tokens/*|credentials/*|exports/*|downloads/*|logs/*|tmp/*|temp/*)             return 0 ;;
        # dotenv files anywhere in the tree.
        .env|.env.*|*/.env|*/.env.*) return 0 ;;
        # macOS finder noise.
        .DS_Store|*/.DS_Store) return 0 ;;
    esac
    return 1
}

is_blocked_extension() {
    local f=$1
    case "$f" in
        # Keys, certs, signing material.
        *.pem|*.key|*.p12|*.pfx|*.crt|*.cer|*.mobileprovision) return 0 ;;
        # Archives and disk images.
        *.zip|*.tar|*.tar.gz|*.tgz|*.7z|*.rar|*.gz|*.bz2|*.xz|*.dmg|*.iso) return 0 ;;
        # Audio / video.
        *.mp4|*.mov|*.mkv|*.webm|*.avi|*.mp3|*.wav|*.flac|*.m4a|*.ogg) return 0 ;;
        # PDFs (often private captures or exports).
        *.pdf) return 0 ;;
        # Filenames that announce themselves.
        *.secret.*|*.token.*|*.credentials.*|*.creds.*) return 0 ;;
    esac
    return 1
}

while IFS= read -r -d '' f; do
    if is_blocked_path "$f"; then
        add_problem "$f  --  path is in a private or local-only subtree"
        continue
    fi
    if is_blocked_extension "$f"; then
        add_problem "$f  --  file type not allowed in this public repo"
        continue
    fi
    if [[ -f "$f" ]]; then
        size=$(wc -c < "$f" | tr -d ' ')
        if (( size > MAX_SIZE )); then
            add_problem "$f  --  $size bytes exceeds limit of $MAX_SIZE bytes (1 MiB)"
        fi
    fi
done < <(git diff --cached --name-only --diff-filter=ACM -z)

if [[ -n "$PROBLEMS" ]]; then
    {
        echo ""
        echo "pre-commit guard: refusing to commit. Offending staged files:"
        echo ""
        printf '%s' "$PROBLEMS"
        echo ""
        echo "If this is a false positive, fix the path/name/size or"
        echo "bypass intentionally with: git commit --no-verify"
        echo ""
    } >&2
    exit 1
fi

exit 0
