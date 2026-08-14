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

| Project | Requirement |
|---|---|
| **nixpkgs** | `Assisted-by:` **mandatory** for LLM tooling, "including at least the tool name and the primary model name and version". `Co-authored-by:` explicitly "does not satisfy this policy". Violations are treated under the CoC clause on LLM spam |
| **Linux kernel** | `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL...]`. AI **must not** add `Signed-off-by` — only humans certify the DCO. In `Documentation/process/coding-assistants.rst` since 7.0 |
| **Mesa** | Two tags by degree: `Assisted-by: TOOL (MODEL)` when AI made decisions or wrote parts, `Generated-by:` when almost all of it is generated. "Do not use the `Co-authored-by` tag as this one is reserved for human co-authors" |
| **LLVM** | Disclosure mandatory for "substantial amounts of tool-generated content", `Assisted-by:` recommended as the form. Covers RFCs, issues and review comments, not just code |

nixpkgs is the strictest of the four, so a commit shaped to satisfy it satisfies the rest. Its exemptions: deterministic editor/IDE/formatter tooling reviewed by the author, and rote LLM auto-completion of boilerplate "the author would have written anyway".

**Where a project names one tag, use theirs, not ours.** nixpkgs mandates `Assisted-by` and counts nothing else, so a commit going there carries `Assisted-by (mostly)` even where it would be `Generated-by` in our own repositories. Mesa is the reverse: send them `Generated-by` when that is what it is.

Sources: [nixpkgs CONTRIBUTING](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md) · [kernel](https://docs.kernel.org/process/coding-assistants.html) · [Mesa](https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/docs/submittingpatches.rst) · [LLVM](https://llvm.org/docs/AIToolPolicy.html) · [the original proposal](https://xeiaso.net/notes/2025/assisted-by-footer/)

## Reading the log

```bash
git log --format='%h %s%n%(trailers:key=Assisted-by,key=Generated-by)'   # what carries a trailer
git log --grep='Generated-by' --oneline                                  # ran without the user's hand
git log --grep='(mostly)' --oneline                                      # I wrote the bulk, they steered
git log --invert-grep --grep='Assisted-by' --grep='Generated-by' --oneline   # the user's own work
```

## CONTRIBUTING template

For a solo repo of the user's. Keep it short — a policy nobody finishes reading is not a policy. Adjust the project name and drop the second paragraph if the repo takes no outside patches yet.

```markdown
# Contributing

## AI assistance

Parts of this repository are written with AI assistance, and that is disclosed per commit. A commit whose diff is substantially machine-written carries a trailer naming the tool and the model:

    Generated-by: Claude Code:claude-opus-5
    Assisted-by: Claude Code:claude-opus-5 (mostly)

`Generated-by:` means the task was carried out without a hand in it — set, reviewed, accepted as it came. `Assisted-by:` means it was steered: `(mostly)` when most of the final diff came from the tool, `(partly)` when a substantial part did. Commits without a trailer are hand-written, dictated line by line, or mechanical — a formatter run or a rename swept with grep.

The same is expected of contributions. Disclose the tool and model you used, in a trailer or in the pull request description. Do not use `Co-authored-by:` for a tool — it is reserved for human co-authors, and it is not accepted as disclosure by [nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md), [Mesa](https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/docs/submittingpatches.rst) or the [kernel](https://docs.kernel.org/process/coding-assistants.html). Never sign off on a tool's behalf.

Whoever opens the pull request is responsible for it. Review what the tool wrote, understand it, and be ready to answer questions about it without forwarding them back to the tool.
```

## Contributing to someone else's repo

Read their `CONTRIBUTING` before the first commit — it overrides everything above. Check for `CONTRIBUTING.md`, `.github/CONTRIBUTING.md`, `docs/`, and the `CODE_OF_CONDUCT`. Where a project has no policy, the nixpkgs form is the safe default: it satisfies everyone who does have one.
