# BMWLINK

**Project copyright:** © 1993-2026 Shannon Smith

BMWLINK is the BMW-specific member of the LINK diagnostic family.

## Engineering ethos

What should a BMW diagnostic product built from first principles add without forking the standards engine beneath it? BMWLINK exists to turn BMW-specific evidence into a product face while keeping generic diagnostic behaviour in the exact pinned LINK dependency.

Standard OBD, transport, UDS, sequencing, safety and common application behaviour are not copied into this repository. BMW-specific identities, topology, definitions and verified manufacturer behaviour belong here. External databases, captures, documentation and mature tools are evidence to study; unsupported manufacturer knowledge remains unknown rather than being inferred from another brand or silently guessed.

The project prefers evidence, reproducibility and stable ownership over novelty. New manufacturer knowledge is accepted when it can be traced and tested, while generic improvements are made once in LINK rather than becoming private BMW variants.

## Architecture

BMWLINK owns only BMW-specific diagnostic behaviour: vehicle/profile
selection, ECU/module knowledge, proprietary identifiers, manufacturer DTC
knowledge, addressing, security/session policy, branding and brand-specific
workflows.

LINK is the shared automotive application engine for the family, not only a
protocol library. It owns reusable diagnostic behaviour and common application
infrastructure, including CAN/CAN-FD, ISO-TP, OBD-II/J1979, generic DTC
knowledge, UDS, KWP where shared, diagnostic flow, adapters/transports,
portable platform support, the operator-task information architecture and
shared presentation behaviour that should remain consistent across product
faces.

Product protocols and manufacturer data feed that shared task model; BMWLINK
must not fork generic navigation, diagnostic sequencing or common application
behaviour merely to present BMW-specific content.

This repository deliberately starts small. Manufacturer-specific behaviour
must be evidence-backed rather than guessed or copied from another brand.

## Dependency

The `src/link` gitlink pins a tested LINK release. Product code must consume
that pin rather than duplicate LINK sources.

## Baseline functionality

Even before BMW-specific definitions are added, BMWLINK is already a
functional **standard OBD-II core** because it consumes the pinned LINK
diagnostic engine.

That baseline includes standard supported-PID discovery, current-data PID
request construction and decoding, freeze-frame reads, readiness, VIN,
stored/pending/permanent DTC reads, generic SAE DTC decoding/knowledge, and
LINK's standard OBDonUDS mapping. It also inherits LINK's shared operator-task
application model and common presentation contracts. See `docs/OBD2.md` and
`docs/GENERIC_BASELINE.md`.

CI exercises this inherited OBD path directly so BMWLINK cannot silently
become a brand shell that no longer exposes LINK's standard diagnostics.

## Status

Generic diagnostic/application baseline: **available through LINK** — adapter
capability modelling, ELM327 sessions/CAN, standard OBD-II, ISO-TP, UDS, DoIP
framing, read-only discovery safety, parameters/scheduling, telemetry/evidence,
transport-neutral diagnostic requests and shared operator-task application
behaviour.

BMW-specific/proprietary vehicle coverage: not claimed yet; it will be added
here only from evidence-backed BMW data.
