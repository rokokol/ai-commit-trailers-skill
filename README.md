<div align="center">

# AI disclosure skill

**Say what made the commit, and never publish under someone's name without asking (｡•̀ᴗ-)✧**

![Claude Code](https://img.shields.io/badge/Claude_Code-D97757?style=flat&logo=anthropic&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![no dependencies](https://img.shields.io/badge/dependencies-none-3DA639?style=flat)
[![license](https://img.shields.io/badge/MIT-3DA639?style=flat)](LICENSE)
[![ci](https://github.com/rokokol/ai-commit-trailers-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/rokokol/ai-commit-trailers-skill/actions/workflows/ci.yml)

</div>

Teaches an agent to disclose its own share of a commit, read a repository's policy before contributing, omit links to AI sessions, and require the user's personal review and explicit approval before publishing under their identity

This is one person's convention, not a neutral survey: it says what I ask an agent to write in my repositories, and why. The upstream requirements it rests on are quoted verbatim with links, so the parts that are load-bearing are checkable and the parts that are mine are visible as mine

No script, no dependencies: `SKILL.md` plus two `references/` files an agent loads only when the task calls for them — the upstream comparison table and the CONTRIBUTING template

## Contents

- [Why](#why)
- [The convention](#the-convention)
- [Install](#install)
- [What it does](#what-it-does)
- [Tests](#tests)
- [Taking it further](#taking-it-further)
- [What it is not](#what-it-is-not)

## Why

`Co-authored-by: Claude` is the reflex, and it is wrong twice over. It claims a co-author who cannot answer a question about the code six months later, and every project that has written a policy refuses it as disclosure — nixpkgs says so outright, Mesa reserves the tag for humans. It misfires mechanically too: GitHub resolves the address to whatever account holds it, so the trailer can hang a stranger's avatar on your commit

What those projects converged on is `Assisted-by:`, with Mesa adding `Generated-by:` for the unattended case

## The convention

```
Generated-by: Claude Code:claude-opus-5           # carried out without my hand in it
Assisted-by: Claude Code:claude-opus-5 (mostly)   # most of the final diff is the agent's, I steered it
Assisted-by: Claude Code:claude-opus-5 (partly)   # a substantial part is
<no trailer>                                      # mine, mechanical, or dictated
```

The head of every line is exactly what nixpkgs demands — tool name, model name and version — so the suffix costs nothing where the policy is strictest. `(mostly)` / `(partly)` are mine; no upstream grades `Assisted-by` itself, so that resolution has to be invented or done without

What decides the state is **whose answer a reviewer would get to "why is it done this way"** — not who typed the lines, and not how large the diff is. Code is a stack of decisions; whoever made them made the change. So curating in prose is steering, until it gets specific enough that nothing is left for the agent to decide — then it is dictation, and dictation discloses nothing. A question counts only if the outcome moved because of it, and reviewing is not editing

## Install

```bash
npx skills add -g rokokol/ai-commit-trailers-skill    # for you, everywhere
npx skills add rokokol/ai-commit-trailers-skill       # for the project you are standing in
```

Without `-g` it installs into the directory you are standing in — handy for a repository whose policy differs, wrong if you meant it for yourself. Either way the files land in `.agents/skills/` and are symlinked into every agent found on the machine

Claude Code also takes it as a plugin:

```
/plugin marketplace add rokokol/ai-commit-trailers-skill
/plugin install ai-commit-trailers@rokokol-skills
```

or by hand — clone into whichever skills directory your agent reads:

```bash
git clone https://github.com/rokokol/ai-commit-trailers-skill \
  ~/.claude/skills/ai-commit-trailers
```

> [!NOTE]
> A skill has no version to pin — it is read at whatever revision you have checked out, so `git pull` is the whole upgrade path

## What it does

- **Requires approval before publication.** Before a push, issue, pull request, review, comment, discussion, or similar externally visible action, the agent shows the exact payload, asks the user to inspect it personally, and waits for explicit final approval. Local commits are exempt; amendments and other history rewrites require an explicit request
- **Never publishes AI session links.** Disclosure names the tool and model without `Claude-Session:` lines, coding-session URLs, transcript links, share links, or equivalent session references from other tools
- **Quotes what each project requires** — nixpkgs, the Linux kernel, Mesa, LLVM — with the exact wording and a link. Where a project names a tag, theirs wins over the convention above: nixpkgs counts nothing but `Assisted-by`, so a fully generated commit still goes there as `Assisted-by`
- **Names the two absolutes.** Never `Co-authored-by` for a tool; never `Signed-off-by` on its behalf — only a human can certify the DCO
- **Says what needs no trailer.** Formatter runs, grep-swept renames, dictated changes. nixpkgs exempts deterministic tooling and rote completion explicitly; the point is that the trailer stays a signal, and a log where every commit carries one says nothing about any of them
- **Ships a CONTRIBUTING section** to paste into a repository, and the `git log` incantations for reading disclosure back out of history

## Tests

```sh
nix develop -c ./tests/check.sh
```

The interesting one enforces this skill's own rule on this skill's own repository: no session URL, no `Claude-Session:` line, in any tracked file **or any commit message** — the second half being the leak that lasts, since history is not re-read the way a file is. Beside it the gate lints the scripts and the workflow, holds `SKILL.md` to its frontmatter and to pointing at every reference it defers to, and resolves every relative link and heading anchor

Each check is then made to fail on purpose: a known-bad workflow actionlint has to reject, a fixture with a dangling link and a dead anchor, and four session-link shapes planted one at a time in a throwaway repository — once in a file and once in a message. The fixture generates every id from a split prefix, so nothing it plants is committed here in a form the gate would have to refuse

## Taking it further

If you disagree with the grading, the parts worth keeping are the upstream table and the exemptions — both are facts about other people's policies. Swap the four states for Mesa's plain pair, or drop degree entirely and disclose the bare fact; either still satisfies every policy quoted. Fix whichever you pick in your own `CONTRIBUTING`, because a convention that lives only in your head gets applied differently by month three

## What it is not

Not a legal opinion, and not a licensing or copyright analysis — attribution practice only. Not an enforcement mechanism either: nothing inspects a diff to decide how much of it was generated. That judgement stays with whoever writes the commit, which is the point every one of these policies makes
