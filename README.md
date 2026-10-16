# BMWLink

**Project copyright:** © 1993-2026 Shannon Smith

BMWLink is the BMW-specific member of the Link diagnostic family.

## Engineering ethos

What should a BMW diagnostic product built from first principles add without forking the standards engine beneath it? BMWLink exists to turn BMW-specific evidence into a product face while keeping generic diagnostic behaviour in the exact pinned Link dependency.

Standard OBD, transport, UDS, sequencing, safety and common application behaviour are not copied into this repository. BMW-specific identities, topology, definitions and verified manufacturer behaviour belong here. External databases, captures, documentation and mature tools are evidence to study; unsupported manufacturer knowledge remains unknown rather than being inferred from another brand or silently guessed.

The project prefers evidence, reproducibility and stable ownership over novelty. New manufacturer knowledge is accepted when it can be traced and tested, while generic improvements are made once in Link rather than becoming private BMW variants.

## Architecture

BMWLink owns only BMW-specific diagnostic behaviour: vehicle/profile
selection, ECU/module knowledge, proprietary identifiers, manufacturer DTC
knowledge, addressing, security/session policy, branding and brand-specific
workflows.

Link is the shared automotive application engine for the family, not only a
protocol library. It owns reusable diagnostic behaviour and common application
infrastructure, including CAN/CAN-FD, ISO-TP, OBD-II/J1979, generic DTC
knowledge, UDS, KWP where shared, diagnostic flow, adapters/transports,
portable platform support, the operator-task information architecture and
shared presentation behaviour that should remain consistent across product
faces.

Product protocols and manufacturer data feed that shared task model; BMWLink
must not fork generic navigation, diagnostic sequencing or common application
behaviour merely to present BMW-specific content.

This repository deliberately starts small. Manufacturer-specific behaviour
must be evidence-backed rather than guessed or copied from another brand.

## Dependency

The `src/link` gitlink pins a tested Link release. Product code must consume
that pin rather than duplicate Link sources.

## Baseline functionality

Even before BMW-specific definitions are added, BMWLink is already a
functional **standard OBD-II core** because it consumes the pinned Link
diagnostic engine.

That baseline includes standard supported-PID discovery, current-data PID
request construction and decoding, freeze-frame reads, readiness, VIN,
stored/pending/permanent DTC reads, generic SAE DTC decoding/knowledge, and
Link's standard OBDonUDS mapping. It also inherits Link's shared operator-task
application model and common presentation contracts. See `docs/OBD2.md` and
`docs/GENERIC_BASELINE.md`.

CI exercises this inherited OBD path directly so BMWLink cannot silently
become a brand shell that no longer exposes Link's standard diagnostics.

## Status

Generic diagnostic/application baseline: **available through Link** — adapter
capability modelling, ELM327 sessions/CAN, standard OBD-II, ISO-TP, UDS, DoIP
framing, read-only discovery safety, parameters/scheduling, telemetry/evidence,
transport-neutral diagnostic requests and shared operator-task application
behaviour.

BMW-specific/proprietary vehicle coverage: not claimed yet; it will be added
here only from evidence-backed BMW data.


## Linux installation paths

The Linux application has two supported build paths from the same native C source graph:

```sh
# Generic distributable build used for the published .deb
cmake -S . -B build-generic -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DBMWLINK_BUILD_LINUX_GUI=ON -DBMWLINK_BUILD_PROFILE=generic
cmake --build build-generic --parallel
cpack --config build-generic/CPackConfig.cmake -G DEB

# Hardware-native local source build
cmake -S . -B build-native -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DBMWLINK_BUILD_LINUX_GUI=ON -DBMWLINK_BUILD_PROFILE=native
cmake --build build-native --parallel
sudo cmake --install build-native
```

The generic profile is the release/packaging contract. The native profile compiles the same implementation locally and enables compiler CPU tuning for the machine doing the build.
