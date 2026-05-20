#!/usr/bin/env bash
# Install the PKMS local pre-commit hook.
#
# Writes .git/hooks/pre-commit so that it invokes scripts/precommit_guard.sh
# on every `git commit` in this clone. Safe to re-run; an existing hook is
# backed up rather than overwritten silently.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOK_DIR="$REPO_ROOT/.git/hooks"
HOOK_FILE="$HOOK_DIR/pre-commit"
GUARD="$REPO_ROOT/scripts/precommit_guard.sh"

if [[ ! -d "$REPO_ROOT/.git" ]]; then
    echo "Error: $REPO_ROOT is not a git working tree (no .git directory)." >&2
    exit 1
fi

if [[ ! -f "$GUARD" ]]; then
    echo "Error: guard script not found at $GUARD" >&2
    exit 1
fi

chmod +x "$GUARD"
mkdir -p "$HOOK_DIR"

if [[ -e "$HOOK_FILE" ]]; then
    backup="$HOOK_FILE.backup.$(date +%Y%m%d%H%M%S)"
    mv "$HOOK_FILE" "$backup"
    echo "Existing pre-commit hook backed up to:"
    echo "  $backup"
fi

cat > "$HOOK_FILE" <<'EOF'
#!/usr/bin/env bash
# Installed by scripts/install_hooks.sh
# Delegates to the repo-tracked guard so updates flow with the codebase.
exec "$(git rev-parse --show-toplevel)/scripts/precommit_guard.sh"
EOF

chmod +x "$HOOK_FILE"

echo "Installed pre-commit hook:"
echo "  $HOOK_FILE"
echo "  -> $GUARD"
