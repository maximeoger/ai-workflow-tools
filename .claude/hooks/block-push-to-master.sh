#!/usr/bin/env bash
# PreToolUse hook (Bash): refuse tout `git push` vers master/main.
# Exit 2 = appel bloqué, stderr renvoyé à Claude.

input=$(cat)
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
else
  cmd=$input
fi

# Rien à faire si la commande ne contient pas de git push
printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]_-])git([[:space:]]+-[^[:space:]]+)*[[:space:]]+push' || exit 0

protected='master|main'
block() {
  echo "Push vers master/main interdit dans ce repo. Crée une branche (git checkout -b <type>/<sujet>), push-la avec 'git push -u origin <branche>', puis ouvre une pull request vers master." >&2
  exit 2
}

# Refspec explicite : `git push origin master`, `HEAD:master`, `+master`, `refs/heads/main`...
if printf '%s' "$cmd" | grep -Eq "git([[:space:]]+-[^[:space:]]+)*[[:space:]]+push([[:space:]]+[^;&|]*)?([[:space:]]|:|\+|refs/heads/)($protected)([[:space:]]|$|;|&|\|)"; then
  block
fi

# `git push` sans refspec (ou juste un remote) depuis master/main
dir=$(printf '%s' "$input" | { command -v jq >/dev/null 2>&1 && jq -r '.cwd // empty'; } 2>/dev/null)
branch=$(git -C "${dir:-.}" rev-parse --abbrev-ref HEAD 2>/dev/null)
if printf '%s' "$branch" | grep -Eqx "$protected"; then
  if printf '%s' "$cmd" | grep -Eq "git([[:space:]]+-[^[:space:]]+)*[[:space:]]+push([[:space:]]+-[^[:space:]]+)*([[:space:]]+[[:alnum:]_.-]+)?([[:space:]]+-[^[:space:]]+)*[[:space:]]*($|;|&|\|)"; then
    block
  fi
fi

exit 0
