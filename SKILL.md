---
name: ai-commit-trailers
description: "Which AI-disclosure trailer a commit carries — Generated-by, Assisted-by (mostly or partly), or none — why never Co-authored-by or Signed-off-by for an agent, what nixpkgs, the kernel, Mesa and LLVM require, and a CONTRIBUTING section on AI assistance. Use when writing, amending or rebasing a commit, or writing or reviewing a repository's AI policy. Triggers: commit, commit message, trailer, Assisted-by, Generated-by, Co-authored-by, Signed-off-by, DCO, AI disclosure, закоммить, коммит, сообщение коммита, трейлер, раскрытие ИИ, подпись коммита"
license: MIT
---

# AI disclosure in commits

The trailer answers "what made this", as opposed to `Co-authored-by`, which answers "who to ask about it". Publishing anything under the user's name, a push included, goes through the [contributing](https://github.com/rokokol/contributing-skill) skill's gate, not this one

## The rule

```
Generated-by: Claude Code:claude-opus-5           # the task was carried out without the user's hand in it
Assisted-by: Claude Code:claude-opus-5 (mostly)   # most of the final diff is mine, but they steered it
Assisted-by: Claude Code:claude-opus-5 (partly)   # a substantial part is mine
<no trailer>                                      # the user's own work, mechanical, or dictated
```

The value is `<tool>:<model>`, the agent that made the change and the model behind it; any harness names itself there. One trailer per commit: torn between two states, take the lower one, and where the case is genuinely unclear write a bare `Assisted-by`. `Generated-by` is Mesa's, `(mostly)` and `(partly)` are ours, and the head of every line is what nixpkgs demands

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

## Never

- **`Co-authored-by`** — a co-author is a person to ask, and the agent is not there next session; nixpkgs rejects it as disclosure and Mesa reserves it for humans
- **`Signed-off-by` on the agent's behalf** — the DCO is a certification only a human can make

## What upstreams require

A project's own rule wins over the convention above, and `contrib.sh repo OWNER/REPO` from the contributing skill finds its AI-policy wording. The comparison of nixpkgs, the kernel, Mesa and LLVM, and the nixpkgs form as the safe default where a project says nothing, is [references/upstream-requirements.md](references/upstream-requirements.md): **load it before a commit to someone else's repository**

## CONTRIBUTING template

A ready `## AI assistance` section for a repository's own `CONTRIBUTING.md` is [references/contributing-template.md](references/contributing-template.md): **load it when writing or reviewing a repository's AI policy**
