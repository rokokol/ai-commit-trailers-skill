# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), dated rather than numbered, and with no `Unreleased` section — a skill is read at whatever revision you have checked out, so whatever is on the default branch is what every reader already has, and a section for work that has landed but not shipped would never close. The rule lives in the [ci](https://github.com/rokokol/ci-skill) skill, which owns what has no version

Written after the fact from the repository's history, so the entries below say what each change did rather than reproducing the reasoning; the commit bodies carry that

## 2026-09-04

### Removed

- the two rules that were prose asking an agent to refrain from something a setting can simply not do. `attribution.commit`, `attribution.pr` and `attribution.sessionUrl` stop Claude Code from appending its byline to a commit message or a pull request body and from adding the session link at all, so carrying the same instruction in a file loaded on every relevant turn bought nothing and cost a paragraph each time. The settings that replace them are documented in the README under Install, where somebody setting a machine up will look — a one-time configuration step does not belong in the hot path an agent reads

### Changed

- what stays in `SKILL.md` is what a setting cannot decide: which trailer a change deserves, what each upstream demands, and the requirement to show the user exactly what is about to be published and then wait

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
