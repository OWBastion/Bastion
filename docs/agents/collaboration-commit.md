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

## GitHub Label Rules

Use a compact three-axis label model for issues and pull requests:

1. `type/*` for the main work category.
2. `status/*` for the current workflow state.
3. `priority/*` for urgency and scheduling order.
4. Domain labels such as `event` and `map` may be added alongside the three axes.

Current canonical label set:

- `type/bug`
- `type/feature`
- `type/refactor`
- `type/docs`
- `type/perf`
- `type/chore`
- `status/triage`
- `status/in-progress`
- `status/need-review`
- `status/blocked`
- `status/ready-to-merge`
- `priority/p0`
- `priority/p1`
- `priority/p2`
- `priority/p3`

Usage constraints:

1. Apply at most one label from each axis on the same issue or pull request.
2. For new issues, prefer setting `type/*` and `priority/*` during triage.
3. For new pull requests, prefer setting `type/*` and `status/need-review`.
4. Before merge, switch the workflow label to `status/ready-to-merge` if review is complete.
