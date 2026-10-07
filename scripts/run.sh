#!/usr/bin/env bash
# run.sh dbmap — launcher for the dbmap package (schema maps via tbls).
# Usage mirrors the old combined launcher: scripts/run.sh dbmap [...args]
# Python selection: first interpreter >= 3.8 on PATH (dbmap is stdlib-only;
# no tree_sitter preference, no dependency installs).
set -euo pipefail

MODULE="$1"
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if [ "$MODULE" != "dbmap" ]; then
  echo "error: this repo ships only dbmap (got '$MODULE')." >&2
  echo "  repomap lives at https://github.com/ariadoss/repomap (deprecated)." >&2
  exit 1
fi
[ -f "$REPO_DIR/$MODULE/__main__.py" ] || {
  echo "error: $MODULE package not found at $REPO_DIR/$MODULE" >&2
  exit 1
}

MIN_MAJOR=3
MIN_MINOR=8

PYTHON=""
for candidate in python3 python3.13 python3.12 python3.11 python3.10 python3.9 python3.8 python; do
  if command -v "$candidate" >/dev/null 2>&1 \
     && "$candidate" -c "import sys; sys.exit(0 if sys.version_info >= (${MIN_MAJOR}, ${MIN_MINOR}) else 1)" 2>/dev/null; then
    PYTHON="$candidate"
    break
  fi
done

if [ -z "$PYTHON" ]; then
  echo "No Python >= ${MIN_MAJOR}.${MIN_MINOR} found on PATH." >&2
  exit 1
fi

exec "$PYTHON" -m "$MODULE" "$@"
