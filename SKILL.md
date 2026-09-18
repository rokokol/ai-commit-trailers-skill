---
name: ai-commit-trailers
description: "Which AI-disclosure trailer a commit carries — Generated-by, Assisted-by (mostly or partly), or none — what decides between them, and why never Co-authored-by or Signed-off-by for an agent. Use when writing, amending or rebasing a commit. Triggers: commit, commit message, trailer, Assisted-by, Generated-by, Co-authored-by, Signed-off-by, DCO, AI disclosure, закоммить, коммит, сообщение коммита, трейлер, подпись коммита"
license: MIT
---

# AI disclosure in commits

The trailer answers "what made this", as opposed to `Co-authored-by`, which answers "who to ask about it"

## The rule

```
Generated-by: Claude Code:<model>           # the task was carried out without the user's hand in it
Assisted-by: Claude Code:<model> (mostly)   # most of the final diff is mine, but they steered it
Assisted-by: Claude Code:<model> (partly)   # a substantial part is mine
<no trailer>                                # the user's own work, mechanical, or dictated
```

The value is `<tool>:<model>` — the agent that made the change and the model actually running behind it; any harness names itself there. One trailer per commit: torn between two states, take the lower one, and where the case is genuinely unclear write a bare `Assisted-by`, which stays true of anything worth arguing about

The trailer is content of the message, written into it deliberately, not a byline a tool appends: it belongs in the message's last block, beside any other trailer, with no blank line inside that block, because `git interpret-trailers` and `git log --format=%(trailers)` read that block and nothing above it

## Which state

The test is whose answer a reviewer would get to "why is it done this way" — not who typed the lines

| The user… | State |
|---|---|
| set the task, read the result, took it unchanged | `Generated-by` |
| steered in prose — a direction, a rejected approach, "not like that, rather…" | `Assisted-by (mostly)` |
| wrote or rewrote a substantial part themselves | `Assisted-by (partly)` |
| dictated it, or curated so closely that nothing was left for me to decide | no trailer |
| ran a formatter, swept a rename with grep | no trailer |

- **Curation in prose is steering**, until it leaves the agent nothing to decide; then it is dictation
- **A question moves the state only if the diff moved because of it**
- **Reviewing and accepting is not editing**

An amend grades the commit as it now stands, the new work counted with the old. A rebase that only moves a commit leaves its trailer alone; one that changes the diff regrades it

## Never

- **`Co-authored-by`** — a co-author is a person to ask, and the agent is not there next session; nixpkgs rejects it as disclosure and Mesa reserves it for humans
- **`Signed-off-by` on the agent's behalf** — the DCO is a certification only a human can make

## Someone else's repository

The project's own policy wins over the convention above, and no single form satisfies every project: nixpkgs, the Linux kernel, Mesa and LLVM each mandate a different one. Read the repository's current contribution policy before the commit and write the form it names
