# What upstreams actually require

| Project | Requirement |
|---|---|
| **nixpkgs** | `Assisted-by:` **mandatory** for LLM tooling, "including at least the tool name and the primary model name and version". `Co-authored-by:` explicitly "does not satisfy this policy". Violations are treated under the CoC clause on LLM spam |
| **Linux kernel** | `Assisted-by: LLM [TOOL1] [TOOL2]`, where the optional tools are specialized analysis tools rather than the model. AI **must not** add `Signed-off-by` — only humans certify the DCO |
| **Mesa** | `Assisted-by: TOOL (OPTIONAL: MODEL)` when AI made decisions or wrote parts, `Generated-by:` when almost all code was generated. `Co-authored-by` is reserved for humans. Contributors should write code comments, commit messages and GitLab comments themselves, and autonomous submissions are prohibited |
| **LLVM** | Disclosure required for "substantial amounts of tool-generated content" in the PR description, commit message or normal authorship location; `Assisted-by: <name of code assistant>` is the example. Autonomous publishing and AI use on `good first issue` work are prohibited |

No one trailer satisfies all four policies: nixpkgs requires tool and primary model, while the kernel prescribes `LLM` followed only by optional specialized analysis tools. Read the target repository's current policy rather than ranking these policies by strictness

**Where a project names a form, use theirs, not ours.** nixpkgs mandates `Assisted-by` and counts nothing else, the kernel prescribes `Assisted-by: LLM [TOOL...]`, and Mesa distinguishes `Assisted-by` from `Generated-by` by degree

Sources: [nixpkgs CONTRIBUTING](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md) · [kernel](https://docs.kernel.org/process/coding-assistants.html) · [Mesa](https://docs.mesa3d.org/submittingpatches.html) · [LLVM](https://llvm.org/docs/AIToolPolicy.html)
