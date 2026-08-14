# AI disclosure skill

Teaches an agent to disclose its own share of a commit, and to read a repository's policy before its first commit there rather than after.

This is one person's convention, not a neutral survey: it says what I ask an agent to write in my repositories, and why. The upstream requirements it rests on are quoted verbatim with links, so the parts that are load-bearing are checkable and the parts that are mine are visible as mine

No script, no dependencies: one `SKILL.md`

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

Two boundaries decide most cases. Judge by the **final diff**, not by who typed first: a block the agent proposed and I rewrote is mine. And **reviewing is not editing**: a change I read and took unchanged stays `Generated-by`

## Install

```bash
npx skills add rokokol/ai-disclosure-skill
```

or as a Claude Code plugin:

```
/plugin marketplace add rokokol/ai-disclosure-skill
/plugin install ai-disclosure@rokokol-skills
```

or by hand — clone into any skills directory:

```bash
git clone https://github.com/rokokol/ai-disclosure-skill \
  ~/.claude/skills/ai-disclosure
```

## What it does

- **Quotes what each project requires** — nixpkgs, the Linux kernel, Mesa, LLVM — with the exact wording and a link. Where a project names a tag, theirs wins over the convention above: nixpkgs counts nothing but `Assisted-by`, so a fully generated commit still goes there as `Assisted-by`
- **Names the two absolutes.** Never `Co-authored-by` for a tool; never `Signed-off-by` on its behalf — only a human can certify the DCO
- **Says what needs no trailer.** Formatter runs, grep-swept renames, dictated changes. nixpkgs exempts deterministic tooling and rote completion explicitly; the point is that the trailer stays a signal, and a log where every commit carries one says nothing about any of them
- **Ships a CONTRIBUTING section** to paste into a repository, and the `git log` incantations for reading disclosure back out of history

## Taking it further

If you disagree with the grading, the parts worth keeping are the upstream table and the exemptions — both are facts about other people's policies. Swap the four states for Mesa's plain pair, or drop degree entirely and disclose the bare fact; either still satisfies every policy quoted. Fix whichever you pick in your own `CONTRIBUTING`, because a convention that lives only in your head gets applied differently by month three

## What it is not

Not a legal opinion, and not a licensing or copyright analysis — attribution practice only. Not an enforcement mechanism either: nothing inspects a diff to decide how much of it was generated. That judgement stays with whoever writes the commit, which is the point every one of these policies makes

## License

MIT
