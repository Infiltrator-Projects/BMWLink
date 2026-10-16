# Changelog

## 0.2.30 — 2026-10-17

- Pin the qualified canonical Link package and its Libraries dependency.

## 0.2.27 — 2026-10-16

CI now qualifies and seals the source archive, Linux package, Windows executable and unsigned iPhone package. Publication consumes those exact artifacts, verifies commit/hash identity and compares draft and public bytes. Windows x86 launch qualification runs on a clean x64 runner.

## 0.2.26 — 2026-09-23

- Advance BMWLink to released Link 0.15.62 at `0f2cc710fb8f211013cd5f55df390fe0911886da`, consuming the canonical nested Libraries 1.19.24 pin and the guarded STM32 UDS RX fallback.
- Requalify the existing manufacturer-specific product surface against the current shared Link/Common dependency chain without broadening diagnostic permissions or inventing manufacturer behaviour.

## 0.2.25 — 2026-09-22

- Advance BMWLink to Link 0.15.55 at 0caaf4026dcf, retaining the Libraries 1.19.23 pin and corrected dependency metadata.

## 0.2.24 — 2026-09-22

- Advance BMWLink to the canonical Link 0.15.54 release at 38826aa2dca7, which pins Libraries 1.19.23, and synchronise Apple embedded-Link provenance with the exact gitlink.

## 0.2.23 — 2026-09-22

- Advance BMWLink to Link 0.15.53 at 4bb9eb719d37, which pins Libraries 1.19.23, and synchronise Apple embedded-Link provenance with the exact gitlink.

## 0.2.22 — 2026-09-22

- Advance BMWLink to Link 0.15.51, which pins Libraries 1.19.22, and synchronise the Apple embedded-Link provenance with the exact gitlink.

## 0.2.21 — 2026-09-21

- Advance the final release tree to Link 0.15.50, which pins Libraries 1.19.22, and synchronise iOS dependency provenance/version metadata with the exact gitlink.
- Standardise About presentation on the suite-wide System Monitor contract through Link 0.15.40.
- Expose the canonical build identity as its own About field on Linux; the Link-owned standard iOS face now carries the same Build field automatically.
- Keep product branding in the application shell while Link owns About geometry and Website/Credits/Licence/Close semantics.


This file records user-visible, compatibility, architecture and validation changes for BMWLink.

## Unreleased

- Canonical documentation baseline aligned with the Infiltrator project family.

## Policy

Record behaviour/support changes and material fixes. Research or internal activity belongs in specialist notes until it changes the supported product.

## Historical identity

Git tags, immutable releases and repository history remain authoritative for exact historical source/artifact identity.
