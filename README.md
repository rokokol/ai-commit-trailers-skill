<div align="center">

# AI disclosure skill

**Say what made the commit, in the form the project asks for (｡•̀ᴗ-)✧**

[![Agent Skill](https://img.shields.io/badge/Agent_Skill-6E56CF?style=flat)](https://agentskills.io)
![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![no dependencies](https://img.shields.io/badge/dependencies-none-3DA639?style=flat)
[![license](https://img.shields.io/badge/MIT-3DA639?style=flat)](LICENSE)

</div>

Teaches an agent to disclose its own share of a commit in a trailer, in the form the receiving project asks for — with the tool's own byline and session links switched off in settings rather than argued about in the prompt. Approving what gets published under your name, and reading a project's policy before contributing to it, moved to the [contributing](https://github.com/rokokol/contributing-skill) skill

This is one person's convention, not a neutral survey: it says what I ask an agent to write in my repositories, and why

One file and nothing else. `SKILL.md` is the whole skill — the four states, the test that picks between them, the two forms that are never right, and one line sending the agent to read the receiving project's own policy first. No script, no dependencies, nothing loaded on demand, because a convention this short has nowhere to defer to

## Contents

- [Why](#why)
- [The convention](#the-convention)
- [Install](#install)
- [Turning the tool's own byline off](#turning-the-tools-own-byline-off)
- [What it does](#what-it-does)
- [Taking it further](#taking-it-further)
- [What it is not](#what-it-is-not)

## Why

`Co-authored-by: Claude` is the reflex, and it is wrong twice over. It claims a co-author who cannot answer a question about the code six months later, and every project that has written a policy refuses it as disclosure — nixpkgs says so outright, Mesa reserves the tag for humans. It misfires mechanically too: GitHub resolves the address to whatever account holds it, so the trailer can hang a stranger's avatar on your commit

What those projects converged on is `Assisted-by:`, with Mesa adding `Generated-by:` for the unattended case

## The convention

```
Generated-by: Claude Code:<model>           # carried out without my hand in it
Assisted-by: Claude Code:<model> (mostly)   # most of the final diff is the agent's, I steered it
Assisted-by: Claude Code:<model> (partly)   # a substantial part is
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
/plugin marketplace add rokokol/skills
/plugin install ai-commit-trailers@rokokol-skills
```

or by hand — clone into whichever skills directory your agent reads:

```bash
git clone https://github.com/rokokol/ai-commit-trailers-skill \
  ~/.claude/skills/ai-commit-trailers
```

> [!NOTE]
> A skill has no version to pin — it is read at whatever revision you have checked out, so `git pull` is the whole upgrade path

## Turning the tool's own byline off

Claude Code appends attribution of its own to commit messages and pull request descriptions, and from a web or Remote Control session a `claude.ai` session link with it. That is the opposite of the convention above: the disclosure belongs in a trailer written into the message, in the form the receiving project asks for, and a session link resolves for one account and is dead text to every other reader. Turn the defaults off in `settings.json` and the omission becomes configuration instead of something a person has to remember while writing a pull request — which is why this is a setup step here rather than a rule in `SKILL.md`

```json
{
  "attribution": {
    "commit": "",
    "pr": "",
    "sessionUrl": false
  }
}
```

| Field | Effect |
| --- | --- |
| `commit` | Text appended to every commit message. `""` hides it; any other string replaces the default wholesale, so a project that wants its own wording puts it here |
| `pr` | The same, for pull request descriptions |
| `sessionUrl` | `false` omits the `Claude-Session:` trailer and the PR-body session link that web and Remote Control sessions otherwise add. Defaults to `true` |

`includeCoAuthoredBy: false` is the deprecated predecessor. It still works and still removes the `Co-authored-by` line, but it does not cover the session link

The same field also decides what the agent is *told*, and that is where this bites. Empty, and it is told to append nothing — in some session kinds as a flat "do not add attribution lines to git commit messages or pull request descriptions (this replaces any earlier attribution guidance)", which reads as a ban on the trailer too unless the agent's own instructions have already drawn the line between a byline the tool appends by itself and a trailer the author writes into the message. Non-empty, and the string is handed over to be appended verbatim, one fixed line on every commit — which is why this convention cannot live in the setting at all: the trailer names the model that actually ran and one of four states, and neither is knowable at the moment the setting is written

Which file decides the scope, later overriding earlier: `~/.claude/settings.json` for every project on the machine, `.claude/settings.json` committed in a repository to hold its contributors to the same behaviour, `.claude/settings.local.json` for that repository without committing it

Emptying these fields removes only what the tool writes by itself. The trailer this skill asks for is composed into the message deliberately and is untouched — one disclosure, chosen, in the form the project wants. `git log -1 --format=%B` shows what actually landed

## What it does

- **Keeps session links and tool bylines out of what gets published.** Disclosure names the tool and model and nothing else; the `attribution` settings above stop Claude Code from appending a `Claude-Session:` line, a coding-session URL or a "generated with" byline to a message or a pull request body
- **Grades the commit before naming it**, by the one question a reviewer would ask, and puts the answer in the trailer block where `git interpret-trailers` can find it
- **Sends you to the receiving project's policy before the commit, not after.** Where a project names a form, theirs wins over the convention above: nixpkgs counts nothing but `Assisted-by`, so a fully generated commit still goes there as `Assisted-by`
- **Names the two absolutes.** Never `Co-authored-by` for a tool; never `Signed-off-by` on its behalf — only a human can certify the DCO
- **Says what needs no trailer.** Formatter runs, grep-swept renames, dictated changes. nixpkgs exempts deterministic tooling and rote completion explicitly; the point is that the trailer stays a signal, and a log where every commit carries one says nothing about any of them

Reading the disclosure back out of history:

```bash
git log --format='%h %s%n%(trailers:key=Assisted-by,key=Generated-by)'   # what carries a trailer
git log --grep='Generated-by' --oneline                                  # ran without the user's hand
git log --grep='(mostly)' --oneline                                      # the agent wrote the bulk, the user steered
git log --invert-grep --grep='Assisted-by' --grep='Generated-by' --oneline   # the user's own work
```

## Taking it further

If you disagree with the grading, the part worth keeping is the exemption list — formatter runs, swept renames, dictated changes — because that is the half that keeps the trailer a signal rather than boilerplate. Swap the graded states for Mesa's plain `Assisted-by` / `Generated-by` pair, or drop degree entirely and disclose the bare fact; either still satisfies every policy this was built against. Fix whichever you pick in your own `CONTRIBUTING`, because a convention that lives only in your head gets applied differently by month three

## What it is not

Not a legal opinion, and not a licensing or copyright analysis — attribution practice only. Not a survey of what upstreams require, either: it names the four projects worth reading and sends you to read them, because the only policy that binds a commit is the current one of the repository receiving it, and a table copied here would be a second copy of it going stale. Not an enforcement mechanism: nothing inspects a diff to decide how much of it was generated. That judgement stays with whoever writes the commit, which is the point every one of these policies makes
