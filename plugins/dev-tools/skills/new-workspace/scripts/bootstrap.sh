#!/usr/bin/env bash
# Bootstrap a getheroes-dashboard worktree: install deps + copy env files.
# Usage: bootstrap.sh <worktree-path> <main-repo-path>
set -euo pipefail

WORKTREE="${1:?Usage: bootstrap.sh <worktree-path> <main-repo-path>}"
MAIN_REPO="${2:?Usage: bootstrap.sh <worktree-path> <main-repo-path>}"

if [ ! -d "$WORKTREE" ]; then
  echo "ERROR: Worktree directory does not exist: $WORKTREE"
  exit 1
fi

if [ ! -d "$MAIN_REPO" ]; then
  echo "ERROR: Main repo directory does not exist: $MAIN_REPO"
  exit 1
fi

# --- 1. Install dependencies ---
echo "==> Installing dependencies in worktree..."
cd "$WORKTREE"
yarn install
echo "==> yarn install done."

# --- 2. Initialize husky ---
echo "==> Initializing husky..."
npx husky install || echo "WARN: husky install failed (non-blocking)"

# --- 3. Copy .env files from main repo ---
echo "==> Copying .env files from main repo..."
COPIED=0

copy_env_files() {
  local rel_dir="$1"
  local src_dir="$MAIN_REPO/$rel_dir"
  local dst_dir="$WORKTREE/$rel_dir"

  if [ ! -d "$src_dir" ]; then
    return
  fi

  # Find .env* files (not .env.example, not .env.dist)
  for env_file in "$src_dir"/.env*; do
    [ -f "$env_file" ] || continue

    basename="$(basename "$env_file")"

    # Skip .example and .dist — those are tracked in git already
    case "$basename" in
      *.example|*.dist) continue ;;
    esac

    mkdir -p "$dst_dir"
    cp "$env_file" "$dst_dir/$basename"
    echo "   Copied $rel_dir/$basename"
    COPIED=$((COPIED + 1))
  done
}

# Root .env
copy_env_files "."

# All packages
for pkg_dir in "$MAIN_REPO"/packages/*/; do
  [ -d "$pkg_dir" ] || continue
  pkg_name="$(basename "$pkg_dir")"
  copy_env_files "packages/$pkg_name"
done

# All libraries (nested structure)
for lib_dir in "$MAIN_REPO"/libraries/frontend/*/; do
  [ -d "$lib_dir" ] || continue
  lib_name="$(basename "$lib_dir")"
  copy_env_files "libraries/frontend/$lib_name"
done

echo "==> $COPIED .env file(s) copied."
echo "==> Bootstrap complete."
