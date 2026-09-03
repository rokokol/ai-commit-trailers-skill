#!/usr/bin/env bash
# One line per shape tests/no-session-links.sh claims to catch, so check.sh can
# plant each in a throwaway repository and require the gate to go red on it.
#
# The ids are GENERATED and every literal prefix is split by a format string, so
# this fixture is not itself the thing the gate exists to refuse.
set -euo pipefail

rep() { # rep CHAR COUNT
  printf "%${2}s" '' | tr ' ' "$1"
}

printf 'https://claude.ai/%s/session_%s\n' code "$(rep a 24)"
printf 'https://chatgpt.com/%s/%s\n' share "$(rep f 32)"
printf 'Claude%sSession: https://example.invalid/%s\n' - "$(rep a 24)"
printf 'https://cursor.com/%s/%s\n' share "$(rep a 20)"
