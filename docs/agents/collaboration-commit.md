# Collaboration and Commit Hygiene (Canonical)

This document is the canonical rule source for AI collaboration boundaries and commit process.

## Collaboration Rules

1. Read relevant modules before editing. Avoid blind edits in large entry files.
2. Follow minimal-change scope by default.
3. Do not casually rename existing rule, constant, or macro names.
4. Do not change build-entry conventions unless explicitly required.
5. In change summaries, clearly state impacted entry points and required linkage validation.

## Commit Process Rules

1. Never bypass hooks with `git commit --no-verify`.
2. Commit only intentional changes for the current task.
3. Keep commit messages concise and conventional.
