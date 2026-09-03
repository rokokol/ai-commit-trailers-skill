#!/usr/bin/env bash
# The skill's own rule, enforced on the skill's own repository: no AI chat or
# coding-session URL, session identifier or transcript link in anything this
# repo publishes — tracked files and commit messages alike.
#
# Both halves matter. A session link in a file is visible; one in a commit
# message is the harder leak, because it survives every later edit of the file
# and nobody re-reads history.
#
# Every pattern is written so it cannot match its own source line: a literal
# prefix is always followed by a bracket expression the pattern text itself does
# not satisfy — which is also why SKILL.md may spell the shapes out in prose.
set -euo pipefail

cd "$(dirname "$0")/.."

fail=0
report() {
  printf 'session-links: %s\n' "$1" >&2
  fail=1
}

patterns=(
  'claude\.ai/(code|chat)/[a-z_]*[0-9a-zA-Z]{16,}'
  '(chatgpt\.com|chat\.openai\.com)/(share|c)/[0-9a-fA-F-]{20,}'
  '(Claude|AI|Chat|Session)-Session:[[:space:]]*[a-z]+://'
  '(cursor\.com|codeium\.com|gemini\.google\.com)/share/[0-9a-zA-Z_-]{16,}'
)

mapfile -t tracked < <(git ls-files)
[ ${#tracked[@]} -gt 0 ] || {
  echo "session-links: nothing tracked yet" >&2
  exit 0
}

for p in "${patterns[@]}"; do
  if git grep -nIE "$p" -- "${tracked[@]}" >&2; then
    report "a session reference is committed in a tracked file"
  fi
  if git log --format='%H %B' | grep -nE "$p" >&2; then
    report "a session reference is committed in a message"
  fi
done

exit "$fail"
