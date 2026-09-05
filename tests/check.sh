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
scripts=(tests/check.sh tests/check-links.sh tests/no-session-links.sh tests/fixtures/planted-session-links.sh)
# Two lists, because two different rules apply. Everything here is link-checked; only the
# references have to be reachable from SKILL.md, since a reference nothing points at is
# never loaded. Keeping them in one array and slicing it by index coupled the two rules to
# the order of the entries, and adding a file to the front silently moved a rule onto it.
docs=(README.md SKILL.md CHANGELOG.md)
refs=(references/upstream-requirements.md references/contributing-template.md)

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

echo "== SKILL.md carries the frontmatter an agent loads it by"
head -1 SKILL.md | grep -qx -- '---' || fail "SKILL.md does not open with a frontmatter block"
front=$(sed -n '2,/^---$/p' SKILL.md)
for key in name description license; do
  printf '%s\n' "$front" | grep -q "^$key:" || fail "SKILL.md frontmatter has no $key"
done
printf '%s\n' "$front" | grep -q '^name: ai-commit-trailers$' ||
  fail "the skill's name is not what the plugin manifest and the readme call it"

echo "== SKILL.md still points at the references it defers to"
for ref in "${refs[@]}"; do
  grep -qF "$(basename "$ref")" SKILL.md ||
    fail "$ref exists but SKILL.md never sends anyone to it"
done
# And the list is not allowed to fall behind what is actually there
for ref in references/*; do
  [ -e "$ref" ] || continue
  [[ " ${refs[*]} " == *" $ref "* ]] || fail "$ref is not in the refs list, so nothing checks it"
done

echo "== every relative link in the docs resolves"
./tests/check-links.sh "${docs[@]}" "${refs[@]}"

echo "== the link checker is able to fail"
if ./tests/check-links.sh tests/fixtures/broken-links.md >/dev/null 2>&1; then
  fail "tests/fixtures/broken-links.md passed the link checker — it cannot catch anything"
fi

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
