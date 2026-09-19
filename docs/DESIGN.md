# Design

## First-principles position

BMWLINK is designed from the behaviour it must own. Existing tools, standards and hosted services are evidence or mechanisms, not specifications to clone or dependencies allowed to redefine project policy.

## Goals

- remain a thin manufacturer face over LINK
- add BMW knowledge only from traceable evidence
- avoid private generic protocol/application copies
- keep unsupported manufacturer behaviour explicit

## Non-goals

Generic OBD success does not constitute BMW-specific coverage, and BMW behaviour is not inferred from another manufacturer simply because the same UDS service exists.

## Dependency policy

Prefer first-party C/C++ implementation for portable/native logic where appropriate and exact pinned first-party shared dependencies for common contracts. External tools/services are acceptable when their interface is useful and replaceable; semantics remain documented and testable in this repository.

## Failure philosophy

Missing, unsupported, stale and failed are distinct states. The project prefers a visible refusal or unavailable result to manufacturing a plausible success. Destructive/publication/manufacturer actions require stronger evidence than read-only discovery.

## Decision quality

A design change should identify ownership, alternatives, evidence and validation. Newness alone is not a benefit; a change should improve correctness, resilience, safety, performance, fidelity or maintainability.
