---
name: new-workspace
description: Bootstrap a fully ready Herdr workspace with git worktree, yarn install, and .env files copied from the main repo. Use when user says "new workspace", "open workspace", "bootstrap worktree", "nouveau workspace", or wants to start working on a new ticket in an isolated environment.
---

# New Workspace

One-shot bootstrap: Herdr workspace + git worktree + dependencies + env files.

## Required input

- **Ticket slug** (e.g. `ZEL3-1234-short-description`) — used for branch name and worktree folder
- **Base ref** (default: `origin/develop`) — what to branch from

## Steps

### 1. Fetch latest refs

```bash
git fetch origin
```

### 2. Create worktree via Herdr

```bash
herdr worktree create \
  --cwd "$(git rev-parse --show-toplevel)" \
  --branch "feature/<ticket-slug>" \
  --base "<base-ref>" \
  --path ".worktrees/<ticket-slug>" \
  --label "<ticket-slug>" \
  --focus \
  --trust-repository
```

If Herdr is not running or the command fails, fall back to raw git, then register
the worktree as a Herdr workspace:

```bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
git worktree add -b "feature/<ticket-slug>" "$REPO_ROOT/.worktrees/<ticket-slug>" "<base-ref>"
```

Then, if Herdr is running, register the worktree so it appears in the workspace list:

```bash
herdr workspace create \
  --cwd "$REPO_ROOT/.worktrees/<ticket-slug>" \
  --label "<ticket-slug>" \
  --no-focus
```

### 3. Bootstrap the worktree

Run the bootstrap script from inside the worktree:

```bash
bash "<main-repo>/.claude/skills/new-workspace/scripts/bootstrap.sh" "<worktree-path>" "<main-repo>"
```

The script handles:
- `yarn install`
- `npx husky install`
- Copying all `.env*` files (excluding `.env.example` and `.env.dist`) from the main repo

### 4. Confirm

Report to user:
- Worktree path
- Branch name
- Whether yarn install succeeded
- How many .env files were copied

## Notes

- Worktrees always go in `.worktrees/` at repo root (already in `.gitignore`)
- For hotfixes (P0/P1), use `--base origin/master` and branch prefix `fix/`
- The bootstrap script is idempotent — safe to re-run
