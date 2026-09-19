# Architecture

## Purpose

BMWLINK is the BMW manufacturer product face over the shared LINK diagnostics engine.

## System decomposition

- BMW product facade
- exact LINK dependency
- Linux/iPhone/Windows-facing product surfaces
- generic diagnostics integration tests
- BMW-specific knowledge layer as it grows

## Ownership boundaries

LINK owns transports, standards, sequencing, safety and common application behaviour. BMWLINK owns only BMW-specific vehicle identity, topology, definitions and manufacturer interpretation.

Mechanisms supplied by GitHub, APT, an operating system, LINK/Common or a platform toolkit sit behind explicit project-owned policy. The external mechanism must not silently become the source of product meaning.

## Source of truth

Code, tests, pinned dependency/release identities and generated artifacts define executable/publication behaviour. Documentation defines ownership and support boundaries. Specialist files may refine a subsystem but must not contradict this model.

## Change discipline

Keep generic behaviour in its shared owner and local behaviour in this repository. Unknown, unavailable and unsupported states stay explicit. Changes to persistent/publication identity require an intentional version or migration decision.

## Specialist documentation

- docs/GENERIC_BASELINE.md
- docs/OBD2.md
