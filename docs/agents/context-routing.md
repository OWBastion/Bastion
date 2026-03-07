# Context Routing and Conditional Loading (Canonical)

This document is the canonical rule source for agent context-loading behavior.

## Route-First Policy

1. Directory ownership is the first routing key.
2. Map task scope to owning directories before reading docs.
3. Avoid reading unrelated domains in the same turn when one routed subtree is sufficient.

## Layered Read Protocol

1. Layer 1: directly touched file(s).
2. Layer 2: immediate dependencies (includes/config/constants used by Layer 1).
3. Layer 3: only the routed rule document(s) from `docs/agents/`.

## Full-Context Injection Ban

1. Do not default-load all `docs/agents/*`.
2. Do not default-load all `docs/modules/*`.
3. Do not preload both entry files and all module docs unless explicitly required by task scope.

## Scope Disclosure

In change summaries, include a short loaded-scope statement so reviewers can verify conditional loading was followed.
