#!/usr/bin/env bash
# The whole gate. Nothing here reaches the network, so it is safe to run on pull
# requests — and every check is followed by proof that it can go red, because a
# check that has never failed is a decoration.
#
# Needs: actionlint, shellcheck, shfmt — from PATH; CI provides them via nix develop
set -euo pipefail

HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$HERE"

fail() {
  echo "check: $1" >&2
  exit 1
}

# One source of truth for what gets linted: this list, read by nothing else
scripts=(tests/check.sh tests/no-session-links.sh tests/fixtures/planted-session-links.sh check-skill.sh check-pins.sh vendor-sync.sh)

echo "== the scripts parse and lint"
for s in "${scripts[@]}"; do bash -n "$s"; done
shellcheck "${scripts[@]}"
shfmt -d -i 2 -ci "${scripts[@]}"

echo "== the workflows pass actionlint"
actionlint .github/workflows/*.yml

echo "== the workflow lint is able to fail"
bad=$(mktemp -d)
mkdir -p "$bad/.github/workflows"
cp tests/fixtures/must-fail.yml "$bad/.github/workflows/"
if (cd "$bad" && actionlint .github/workflows/*.yml >/dev/null 2>&1); then
  rm -rf "$bad"
  fail "actionlint passed tests/fixtures/must-fail.yml — it cannot catch anything"
fi
rm -rf "$bad"

echo "== the vendored checkers are byte-equal to their source"
# check-skill.sh and check-pins.sh come from the ci skill: every copy must still be the
# blob .github/vendor.lock records, so one edited here instead of at its source fails by name
./vendor-sync.sh check

echo "== the workflows take no tool from a registry"
# The ci skill's pin guard, which proves on every run that it catches each unpinned shape
./check-pins.sh

echo "== SKILL.md loads, every reference is reachable, and every link and anchor resolves"
# The one gate every skill repository shares. It finds the references itself and follows
# SKILL.md's links to each, so there is no list here for a new reference to fall out of,
# and it proves each check able to fail on a planted copy on every run
./check-skill.sh -n ai-commit-trailers .

echo "== no session reference in a tracked file or a commit message"
./tests/no-session-links.sh

echo "== the session-link gate catches every shape it claims"
# In a throwaway repository, because the gate's subject is what git tracks and
# what git remembers, and only a real repository answers either
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
git -C "$work" init -q
git -C "$work" config user.email ci@example.invalid
git -C "$work" config user.name ci
mkdir -p "$work/tests"
cp tests/no-session-links.sh "$work/tests/"
git -C "$work" add -A
git -C "$work" commit -qm "the gate, and nothing else"
# Clean first: it is now scanning its own source and its own message, so a
# pattern matching its own text would surface right here
(cd "$work" && ./tests/no-session-links.sh >/dev/null 2>&1) ||
  fail "the session-link gate reddens on its own source — a pattern is matching its own text"
i=0
while IFS= read -r line; do
  i=$((i + 1))
  # once in a file, once in a message: the two halves are separate greps
  printf '%s\n' "$line" >"$work/planted.txt"
  git -C "$work" add -A
  if (cd "$work" && ./tests/no-session-links.sh >/dev/null 2>&1); then
    fail "a planted session link went unnoticed in a file: ${line:0:24}…"
  fi
  rm -f "$work/planted.txt"
  git -C "$work" add -A
  git -C "$work" commit -q --allow-empty -m "$line"
  if (cd "$work" && ./tests/no-session-links.sh >/dev/null 2>&1); then
    fail "a planted session link went unnoticed in a message: ${line:0:24}…"
  fi
  git -C "$work" reset -q --hard HEAD~1
done < <(./tests/fixtures/planted-session-links.sh)
[ "$i" -gt 0 ] || fail "planted-session-links.sh produced nothing to plant"
echo "   $i shapes planted in a file and in a message, $((i * 2)) caught"

echo
echo "check: everything holds"
