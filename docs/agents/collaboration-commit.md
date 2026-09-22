# Collaboration, Review, and Commit Hygiene (Canonical)

This document is the canonical Bastion rule source for task scope, remote delivery, PR review handoff, and commit hygiene.

## Scope and collaboration

1. Read the relevant Issue and implementation surface before editing; avoid blind edits in large entry files.
2. Keep changes within the task-owned behavior. Include only bounded structural work required for correctness or coherent responsibility.
3. Do not casually rename existing rule, constant, or macro names or change build-entry conventions.
4. Do not turn a review finding into unrelated cleanup, redesign, or architecture work.
5. In change summaries, identify affected entry points and the validation that actually supports the claim.

## Delivery is part of completion

A verified local worktree is not the shared review surface.

- An `implement` or `fix` request normally authorizes in-scope code edits, non-destructive validation, commit, push to a non-default branch, and opening or updating the task PR. Stop earlier only for an explicit local-only request or a concrete blocker.
- A PR review request normally authorizes posting the review result to the PR. Review the complete relevant diff in one pass where practical; report actionable findings rather than a sequence of speculative micro-comments.
- If review finds no blocking issue, use the repository-appropriate approve/LGTM signal rather than asking the user to repeat the review action manually.
- Review-fix work is complete only after verified corrections are pushed to the existing PR branch, affected threads are handled without hiding unresolved findings, and the PR is handed back for review.
- Never push implementation commits directly to the default branch unless explicitly authorized.
- Merge, release, deployment, production mutation, destructive actions, and material scope expansion remain separate authorization boundaries.

Why: leaving verified work only in an agent worktree, or leaving review conclusions only in chat, creates coordination work for the user and leaves the authoritative GitHub surface stale.

## Commit process

1. Never bypass hooks with `git commit --no-verify`.
2. Commit only intentional task-owned changes.
3. Keep commit messages concise and conventional.
4. Before handoff, inspect the final diff for unrelated files, generated artifacts that do not belong in source control, credentials, and private data.

## Review quality

- Start from the Issue/contract and observable behavior, not from a preferred implementation shape.
- First review should aim to cover the full PR scope. Prioritize correctness, lifecycle/state cleanup, ownership boundaries, Workshop performance risk, compatibility, and evidence gaps.
- Do not require a refactor solely because another structure is aesthetically preferable when the current implementation satisfies the contract cleanly.
- Follow-up review should focus on original findings, the new diff, and regressions introduced by the fix rather than reopening unrelated design questions.
- CI/test counts are evidence summaries, not correctness conclusions. For material behavior, require the independent falsification routed by root `AGENTS.md`.

## GitHub labels

Use labels for routing, not as a second source of project status or architecture truth. Prefer one label from each configured `type/*`, `status/*`, and `priority/*` axis when those labels exist, plus domain labels such as `event` or `map` where useful. Query the repository's current labels instead of treating a hard-coded label inventory in documentation as authoritative.
