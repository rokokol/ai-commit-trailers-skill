---
name: ai-commit-trailers
description: "How AI involvement is disclosed in commits — the Assisted-by and Generated-by trailers, which state a given commit falls into, what each upstream project requires, and a CONTRIBUTING template that states the policy. Use when writing or reviewing a CONTRIBUTING/AI policy, before the first commit to a third-party repo, when a repo's rules on AI contributions are unclear, when unsure which trailer a commit deserves — curated in prose, questions that changed the outcome, dictated work — or when asked about Co-authored-by / Signed-off-by / Generated-by."
license: MIT
---

# AI disclosure in commits

The trailer that answers "what made this", as opposed to `Co-authored-by`, which answers "who to ask about it". Keep the rule itself in whatever file your agent always reads; this one holds the reasoning behind it, the upstream texts it rests on, and the template.

## The rule

```
Generated-by: Claude Code:claude-opus-5           # the task was carried out without the user's hand in it
Assisted-by: Claude Code:claude-opus-5 (mostly)   # most of the final diff is mine, but they steered it
Assisted-by: Claude Code:claude-opus-5 (partly)   # a substantial part is mine
<no trailer>                                      # the user's own work, mechanical, or dictated
```

One trailer per commit. Torn between two states — take the lower one; where the case is genuinely unclear, drop the suffix and write a bare `Assisted-by`. That much is true of any commit worth arguing about, which a guessed degree is not.

`Generated-by` is Mesa's, for "almost all the code was generated". `(mostly)` / `(partly)` are ours: no upstream grades `Assisted-by` itself. The head of every line is what nixpkgs demands, so the suffix costs nothing where the policy is strictest.

## Which state

The test is **whose answer a reviewer would get to "why is it done this way"** — not who typed the lines. Code is a stack of decisions: what structure, where the boundary falls, what happens on the empty input. Whoever made those made the change; typing them out is the cheap half.

So the diff is a rough proxy, and only for the ordinary case. Under close curation it reads as entirely mine while half the thinking was the user's, and grading by volume would call that `(mostly)` when it is nearer to no trailer at all.

| The user… | State |
|---|---|
| set the task, read the result, took it unchanged | `Generated-by` |
| steered in prose — a direction, a rejected approach, "not like that, rather…" | `Assisted-by (mostly)` |
| wrote or rewrote a substantial part themselves | `Assisted-by (partly)` |
| dictated it, or curated so closely that nothing was left for me to decide | no trailer |
| ran a formatter, swept a rename with grep | no trailer |

**Curation in prose is steering, not dictation** — until it stops leaving me decisions. Direction, structure, approach and edge handling all specified means I transcribed rather than designed, and that is dictation at a higher altitude: no trailer, same as line-by-line.

**A question moves the state only if the diff moved because of it.** "What does this line do" changes nothing. "Sure that survives an empty input?" sends me checking and fixing — that is a correction phrased as a question, and it steers. Grammar is not the signal; whether the commit came out different is.

**Reviewing and accepting is not editing.** A change read and taken unchanged stays `Generated-by` — otherwise the tag would never apply to anything worth committing.

The two rows that get no trailer are the ones the exemptions rest on. nixpkgs excuses deterministic tooling and rote boilerplate in as many words; the dictation row follows the same logic rather than their letter, since a decision the user made is not assistance to disclose. Both exist so the trailer stays a signal — a log where every commit carries one says nothing about any of them.

## Never

- **`Co-authored-by`** — a co-author is a person to go to with a question, and I am not there next session. It also fails as disclosure: nixpkgs rejects it outright, Mesa reserves the tag for humans. Under `user.email` it would also put a fake identity in the contributor graph
- **`Signed-off-by` on my behalf** — the DCO is a legal certification only a human can make. Both the kernel and nixpkgs say so

## What upstreams actually require

nixpkgs, the Linux kernel, Mesa and LLVM each state their own requirement — which trailer, mandatory or recommended, what `Co-authored-by`/`Signed-off-by` exemptions exist. Full comparison table plus sources — `references/upstream-requirements.md`. **Load it before the first commit to a third-party repo**, or whenever a project's own policy is unclear and you need the nixpkgs-is-strictest fallback logic.

## Reading the log

```bash
git log --format='%h %s%n%(trailers:key=Assisted-by,key=Generated-by)'   # what carries a trailer
git log --grep='Generated-by' --oneline                                  # ran without the user's hand
git log --grep='(mostly)' --oneline                                      # I wrote the bulk, they steered
git log --invert-grep --grep='Assisted-by' --grep='Generated-by' --oneline   # the user's own work
```

## CONTRIBUTING template

A short, ready-to-adapt `## AI assistance` section for a solo repo's `CONTRIBUTING.md` — states the trailer rule, the `Co-authored-by` refusal and the review expectation in a form a contributor actually finishes reading. Full template — `references/contributing-template.md`. **Load it when writing or reviewing a repo's `CONTRIBUTING.md` or AI policy.**

## Contributing to someone else's repo

Read their `CONTRIBUTING` before the first commit — it overrides everything above. Check for `CONTRIBUTING.md`, `.github/CONTRIBUTING.md`, `docs/`, and the `CODE_OF_CONDUCT`. Where a project has no policy, the nixpkgs form is the safe default: it satisfies everyone who does have one.
