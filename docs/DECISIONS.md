# Decisions

## ADR-001 — BMWLink remains a thin Link product face

**Decision.** Generic protocol, sequencing, safety and application behaviour stays in Link.

**Rationale.** Product copies would diverge and make safety fixes inconsistent.

**Consequence.** BMWLink grows mainly through BMW-specific knowledge.

## ADR-002 — One Link dependency defines shared behaviour

**Decision.** BMWLink links directly against the exact pinned Link source and does not choose Common independently.

**Rationale.** A single dependency chain makes releases reproducible and avoids mixed shared-library assumptions.

**Consequence.** Dependency changes are reviewed by changing the Link gitlink.

## ADR-003 — Manufacturer gaps remain explicit

**Decision.** Do not infer BMW module/network semantics from other makes or generic UDS conventions.

**Rationale.** Similar service numbers do not guarantee identical manufacturer meaning.

**Consequence.** Generic tests may pass while BMW-specific sections legitimately remain unimplemented.

## ADR-004 — Platform shells stay thin

**Decision.** GTK, Win32 and SwiftUI layers present shared core state and handle native integration only.

**Rationale.** Protocol/application behaviour must not fork by platform.

**Consequence.** Cross-platform parity fixes normally belong below the shell.

## ADR-005 — Version identity is single-source checked

**Decision.** Root VERSION and public product version must agree at configure time.

**Rationale.** Packaging and product APIs must not silently advertise different versions.

**Consequence.** Version drift is a build failure.
