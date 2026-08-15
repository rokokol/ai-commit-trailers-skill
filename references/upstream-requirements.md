# What upstreams actually require

| Project | Requirement |
|---|---|
| **nixpkgs** | `Assisted-by:` **mandatory** for LLM tooling, "including at least the tool name and the primary model name and version". `Co-authored-by:` explicitly "does not satisfy this policy". Violations are treated under the CoC clause on LLM spam |
| **Linux kernel** | `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL...]`. AI **must not** add `Signed-off-by` — only humans certify the DCO. In `Documentation/process/coding-assistants.rst` since 7.0 |
| **Mesa** | Two tags by degree: `Assisted-by: TOOL (MODEL)` when AI made decisions or wrote parts, `Generated-by:` when almost all of it is generated. "Do not use the `Co-authored-by` tag as this one is reserved for human co-authors" |
| **LLVM** | Disclosure mandatory for "substantial amounts of tool-generated content", `Assisted-by:` recommended as the form. Covers RFCs, issues and review comments, not just code |

nixpkgs is the strictest of the four, so a commit shaped to satisfy it satisfies the rest. Its exemptions: deterministic editor/IDE/formatter tooling reviewed by the author, and rote LLM auto-completion of boilerplate "the author would have written anyway".

**Where a project names one tag, use theirs, not ours.** nixpkgs mandates `Assisted-by` and counts nothing else, so a commit going there carries `Assisted-by (mostly)` even where it would be `Generated-by` in our own repositories. Mesa is the reverse: send them `Generated-by` when that is what it is.

Sources: [nixpkgs CONTRIBUTING](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md) · [kernel](https://docs.kernel.org/process/coding-assistants.html) · [Mesa](https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/docs/submittingpatches.rst) · [LLVM](https://llvm.org/docs/AIToolPolicy.html) · [the original proposal](https://xeiaso.net/notes/2025/assisted-by-footer/)
