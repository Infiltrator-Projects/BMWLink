# Design

## First-principles position

BMWLINK is not intended to become a copy of LINK with BMW colours. It should contain exactly the behaviour that is genuinely BMW-specific and rely on the shared engine for everything else.

## Goals

- one shared diagnostic engine across vehicle products;
- BMW-specific knowledge with explicit provenance;
- native Linux, Windows and iPhone product faces over the same core;
- no guessed manufacturer catalogue merely to make the application appear complete;
- deny-by-default request safety inherited from LINK.

## Thin-product rule

A manufacturer repository being small is a success when LINK owns the generic capability. Code count is not a measure of maturity.

BMWLINK should grow only when real BMW-specific evidence justifies new identity, topology, parameter, service or procedure knowledge.

## Language/platform rule

C/C++ are preferred for first-party native/domain code. Swift and Objective-C are platform-boundary languages on Apple. Toolkit code renders state; it does not redefine diagnostics.

## Evidence rule

Generic OBD/UDS behaviour proves standards integration, not BMW manufacturer coverage. A BMW-specific definition requires a traceable source, captured/physical evidence or another documented basis strong enough to support the interpretation.

## Failure rule

Unknown BMW values remain raw/unknown. Unsupported manufacturer requests remain unavailable. A decoder being present in LINK does not mean BMWLINK is permitted to send it.

## Shared improvement rule

If BMWLINK needs a capability that is product-neutral, LINK should be improved and BMWLINK should consume it. Private compatibility layers are temporary and should shrink rather than become a second framework.
