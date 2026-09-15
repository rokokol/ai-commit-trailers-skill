# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), dated rather than numbered, and with no `Unreleased` section — a skill is read at whatever revision you have checked out, so whatever is on the default branch is what every reader already has, and a section for work that has landed but not shipped would never close. The rule lives in the [versioning](https://github.com/rokokol/versioning-skill) skill, which owns what has no version

Written after the fact from the repository's history, so the entries below say what each change did rather than reproducing the reasoning; the commit bodies carry that

## 2026-09-15

### Changed

- `check-skill.sh` is vendored from the [skill-authoring](https://github.com/rokokol/skill-authoring-skill) skill, where the rules it checks now live, and reports the rules a skill can break without breaking as warnings on stdout, the exit code unchanged: a `Layout` or install section in runtime, `used to`, a `path:line` citation, a link to a sibling skill, a concrete model id, and the rest its `--help` lists

## 2026-09-12

### Changed

- the trailer examples in SKILL.md name `<model>` rather than one pinned model id, so an agent writes the id of the model actually running

## 2026-09-11

### Removed

- the rules for publishing under the user's identity — show the payload, wait for approval, never batch, the local-commit exception — and the checks before contributing to someone else's repository; both live in the [contributing](https://github.com/rokokol/contributing-skill) skill now, which extends the gate to the user's own repositories
- the triggers for pushes, pull requests, issues, reviews and comments, which now load the contributing skill instead

### Changed

- `SKILL.md` is the trailer rule alone, shorter, and `git log` recipes for reading the trailers back moved to the README

## 2026-09-10

### Changed

- `SKILL.md` says the trailer value is `<tool>:<model>`, so an agent in any harness names itself there rather than copying `Claude Code` from the examples, and its paragraphs end bare like the rest of the family
- the gate runs the ci skill's `check-skill.sh` and `check-pins.sh`, vendored beside `vendor-sync.sh`, in place of its own link checker and the reference list it kept by hand; the CI workflow is `build.yml` now, and so is the badge

### Fixed

- `SKILL.md` named its two references as code, not as links, so nothing an agent could follow led to them. The old gate only looked for the file name in the text and passed; the ci skill's gate follows links, and failed on the first run

- no Russian triggers in the description, unlike every sibling skill. For the skill that has to fire before a "запушь" or an "открой ишью" goes out under the user's name, a miss is a publishing miss rather than a style one
- the marketplace description still promised to "omit session links", behaviour that moved to the `attribution.*` settings on 2026-09-04
- counts restating the length of a list beside them: "the strictest of the four", "the four states", "four session-link shapes"

## 2026-09-04

### Changed

- what stays in `SKILL.md` is what a setting cannot decide: which trailer a change deserves, what each upstream demands, and the requirement to show the user exactly what is about to be published and then wait

### Removed

- the two rules that were prose asking an agent to refrain from something a setting can simply not do. `attribution.commit`, `attribution.pr` and `attribution.sessionUrl` stop Claude Code from appending its byline to a commit message or a pull request body and from adding the session link at all, so carrying the same instruction in a file loaded on every relevant turn bought nothing and cost a paragraph each time. The settings that replace them are documented in the README under Install, where somebody setting a machine up will look — a one-time configuration step does not belong in the hot path an agent reads

## 2026-09-03

### Added

- a CI gate, starting with the rule this skill is about: the repository asked other people to keep session links out of what they publish and had nothing checking that it did so itself. The check covers commit messages as well as tracked files — a link in a file is visible and gets edited away, one in a message survives everything
- the boring half of the gate: the scripts and the workflow lint, `SKILL.md` keeps the frontmatter an agent loads it by and keeps pointing at both references, and every relative link and heading anchor resolves
- nothing is trusted for being green — actionlint has to reject a broken workflow, the link checker has to redden on a fixture with a dangling path and a dead anchor, and each of the four session-link shapes is planted in a throwaway repository twice, once in a file and once in a message. The fixture builds every id from a split prefix, so it is not itself the thing the gate exists to refuse

### Changed

- the readme took the family shape: header block, badge row, Contents list, the licence as a badge pointing at `LICENSE` rather than a section restating one word, and the upgrade path stated, since a skill has no version to pin

## 2026-09-01

### Changed

- followed the `-skill` repository rename, and the CONTRIBUTING template became the canonical text again: it had drifted behind the files actually deployed across the family — the DCO sentence, the closed-unread paragraph, and the bare `Assisted-by` fallback with its pointer back here

## 2026-08-31

### Changed

- the disclosure rules apply to every interaction, not only to commits

## 2026-08-15

### Added

- the skill itself: which trailer a change deserves and why, decided by whose "why" drove it rather than by the size of the diff — grading by volume breaks in both directions
- a bare `Assisted-by` as the fallback wherever the split is unclear. A grade can be wrong in either direction; the tag without a suffix cannot, so it is the honest answer where the degree is not knowable

### Changed

- `SKILL.md` split into `references/`: the upstream comparison table and the CONTRIBUTING template were loaded on every invocation even though only some tasks need them, so both moved to load-on-demand with a pointer sentence left behind
