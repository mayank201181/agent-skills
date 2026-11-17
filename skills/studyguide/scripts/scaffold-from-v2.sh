#!/usr/bin/env bash
# Scaffold a clean v2 Study Guide & Question Bank skeleton from a hardened reference repo
# Works BOTH locally on laptop AND in any Cloud VM (Google Jules, Claude Web, Codespaces)
# without copying .git history, node_modules, .mp4 videos, or old subject content.
# Usage: scaffold-from-v2.sh <target-dir> [source-v2-dir-or-git-url]
set -euo pipefail

TARGET="${1:?Usage: scaffold-from-v2.sh <target-dir> [source-v2-dir-or-git-url]}"
DEFAULT_LOCAL="/Users/mayankrawat/Downloads/year8-workspace/Year8geography"
DEFAULT_REMOTE="https://github.com/mayank201181/Year8geography.git"
SRC="${2:-}"
TMP_CLONE=""

cleanup() {
  if [ -n "$TMP_CLONE" ] && [ -d "$TMP_CLONE" ]; then
    rm -rf "$TMP_CLONE"
  fi
}
trap cleanup EXIT

if [ -z "$SRC" ]; then
  if [ -d "$DEFAULT_LOCAL/app" ] && [ -d "$DEFAULT_LOCAL/components" ]; then
    SRC="$DEFAULT_LOCAL"
  else
    TMP_CLONE="$(mktemp -d)"
    echo "Local workspace not present — shallow-cloning hardened v2 skeleton from $DEFAULT_REMOTE ..."
    git clone --depth 1 --filter=blob:none "$DEFAULT_REMOTE" "$TMP_CLONE/repo"
    SRC="$TMP_CLONE/repo"
  fi
elif [[ "$SRC" == http://* || "$SRC" == https://* || "$SRC" == git@* ]]; then
  TMP_CLONE="$(mktemp -d)"
  echo "Shallow-cloning hardened v2 skeleton from $SRC ..."
  git clone --depth 1 --filter=blob:none "$SRC" "$TMP_CLONE/repo"
  SRC="$TMP_CLONE/repo"
fi

if [ ! -d "$SRC/app" ] || [ ! -d "$SRC/components" ]; then
  echo "Error: Source v2 repo not found at $SRC" >&2
  exit 1
fi

mkdir -p "$TARGET"
rsync -a \
  --exclude='.git' \
  --exclude='node_modules' \
  --exclude='.next' \
  --exclude='.audit-tmp' \
  --exclude='public/videos/*.mp4' \
  --exclude='public/videos/posters/*' \
  --exclude='public/coaching' \
  --exclude='public/masterclass' \
  --exclude='public/season1' \
  --exclude='lib/topics/*/' \
  --exclude='lib/drills/*.ts' \
  --exclude='lib/extras/*.ts' \
  --exclude='lib/exam/exam-*.ts' \
  --exclude='components/widgets/*.tsx' \
  --exclude='lib/generated/*' \
  --exclude='scripts/sitcom/episodes/*.py' \
  --exclude='scripts/sitcom/qa/*' \
  --exclude='scripts/sitcom/out' \
  --exclude='scripts/sitcom/tts_cache' \
  --exclude='docs/*.bak' \
  "$SRC/" "$TARGET/"

# Keep helper files needed by drills/widgets
for keep in _example.ts helpers.ts index.ts rng.ts types.ts; do
  [ -f "$SRC/lib/drills/$keep" ] && cp "$SRC/lib/drills/$keep" "$TARGET/lib/drills/$keep"
done

echo "Clean v2 studyguide skeleton scaffolded at: $TARGET"
