# CONTRIBUTING template

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
