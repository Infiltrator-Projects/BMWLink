# Validation

## Current automated evidence

BMWLINK CI builds the product against its exact LINK dependency and exercises three direct C tests:

- product/version smoke integration;
- standard OBD-II exposure;
- generic diagnostics flow.

Platform workflows additionally compile/package the product faces defined by the repository.

## What this proves

The current suite proves that BMWLINK remains a valid product facade over LINK and that the generic standards path is exposed correctly.

It does **not** prove manufacturer-specific BMW module topology, proprietary parameters, enhanced procedures or compatibility with a particular physical vehicle.

## Manufacturer evidence levels

1. documented public/official source;
2. sanitised captured traffic with known context;
3. repeatable physical-vehicle observation;
4. regression fixture derived from verified evidence.

A generic UDS expectation without BMW evidence is not enough to name or enable a manufacturer feature.

## Safety evidence

BMWLINK inherits LINK's request/safety engine. Any BMW-specific request allowlist or enhanced action added here must gain product-level regression coverage proving its permitted scope.

## Physical validation

BLE/J2534/vehicle behaviour ultimately requires real adapters and BMW vehicles. Simulator/build success is platform-integration evidence, not physical diagnostic qualification.

## Release criterion

The exact product source and LINK gitlink must pass the required build/test/release gates. Documentation must distinguish generic baseline from BMW-specific verified capability.

## Qualified publication

`VERSION` is the sole release-intent authority. CI builds and tests each distributable once, then preserves per-platform SHA-256 manifests and the exact source commit. The release workflow downloads only artifacts from that successful push-to-`main` run; it never recompiles. A draft is byte-compared before publication and the public release is compared again. Published tags and bytes remain immutable. Windows qualification retains the x86 executable required by J2534 and runs its real window/title/close test on a clean x64 Windows runner. Native Linux verification remains separate from the generic public package.
