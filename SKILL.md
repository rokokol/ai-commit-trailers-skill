---
name: ai-commit-trailers
description: "AI disclosure and submission safety for commits, pushes, issues, pull requests, PR reviews, comments, and discussions: Assisted-by / Generated-by trailers, upstream requirements, no AI session links, and mandatory user review before publishing. Use before any commit or action that publishes content as the user, when writing or reviewing a CONTRIBUTING/AI policy, before contributing to a third-party repo, when AI contribution rules are unclear, or when asked about Co-authored-by / Signed-off-by / Generated-by."
license: MIT
---

# AI disclosure in repository contributions

For commits, the trailer answers "what made this", as opposed to `Co-authored-by`, which answers "who to ask about it". The safety rules below also apply to pushes, issues, pull requests, reviews, comments, discussions, and any other action performed under the user's identity. Keep the rule itself in whatever file your agent always reads; this one holds the reasoning behind it, the upstream texts it rests on, and the template.

## Before sending anything as the user

Never push, open or update an issue or pull request, submit a review, post a comment or discussion, or perform another externally visible action under the user's identity without a final, explicit confirmation immediately before the action.

1. Show the user exactly what will be published, including the destination and all relevant metadata. For a push, include the ref and commits; for an issue, pull request, review, comment, or discussion, include the exact title and body as applicable.
2. Explicitly ask the user to review it personally. Do not describe tool output, tests, or an agent's review as a substitute for their own inspection.
3. Ask whether to proceed, and wait for an unambiguous approval. A request made earlier in the task is not the final approval required by this rule.

Do not batch approval for multiple submissions. If the content or destination changes after approval, show the revised payload and ask again.

Local commits are the narrow exception: apply the disclosure rules and inspect the staged diff and proposed message, but do not ask for a separate confirmation before running `git commit` when the user has requested a commit. History-rewriting actions such as `git commit --amend` or rebase require an explicit request for that action; when the user has already made that explicit request, do not ask for duplicate confirmation.

## No AI session links

Never add an AI chat or coding-session URL, session identifier, transcript link, share link, or similar session reference to a commit message, issue, pull request, review, comment, discussion, or other submission. This includes `Claude-Session:` lines and URLs such as `https://claude.ai/code/session_...`, as well as equivalent links from other tools.

When disclosure is required, name only the tool and model in the form required by the repository. Do not use a session link as provenance or proof. If a draft already contains a session reference, remove it and call out that removal when presenting the draft for the user's review.

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

nixpkgs, the Linux kernel, Mesa and LLVM each state their own requirement — which trailer, mandatory or recommended, what `Co-authored-by`/`Signed-off-by` exemptions exist. Full comparison table plus sources — `references/upstream-requirements.md`. **Load it before every contribution to a third-party repo**, or whenever a project's own policy is unclear and you need the nixpkgs-is-strictest fallback logic.

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

Re-check the relevant repository policy before every commit, issue, pull request, review, comment, discussion, or other interaction. The repository's contribution and disclosure requirements override the trailer convention above, but never the ban on session links or the requirement for the user's personal review and final approval. Check for `CONTRIBUTING.md`, `.github/CONTRIBUTING.md`, `docs/`, issue and pull request templates, and the `CODE_OF_CONDUCT`. Where a project has no policy, the nixpkgs form is the safe default for commits: it satisfies everyone who does have one.
