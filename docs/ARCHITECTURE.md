# Architecture

## Purpose

BMWLINK is the BMW manufacturer product face over the shared LINK diagnostics engine. The repository is intentionally thin: generic automotive behaviour stays in LINK while BMW-specific identity and evidence grow here.

## Dependency hierarchy

```text
Infiltratr Common
        ↓
       LINK
        ↓
     BMWLINK
```

The build adds `src/link` and links `bmwlink-core` publicly against `LINK::Core`. BMWLINK does not select an independent Common revision.

## Product core

`src/bmwlink.c` and public headers under `include/bmwlink/` define product identity and BMW-specific facade behaviour.

The repository currently retains small `src/obd2/` and `src/uds/` source areas only where product-owned compatibility/facade code remains; generic standards semantics belong in LINK and should not grow privately here.

## Platform faces

### Linux

The optional GTK4 shell is a native product face. It links BMWLINK::Core and uses LINK's shared Linux application/adapter enablement. GTK resources and product identity remain local.

### Windows

The Windows Discover executable is created through LINK's shared Discover constructor. BMWLINK supplies product identity, icon and theme overrides, while generic Windows Discover behaviour stays in LINK.

### iPhone

SwiftUI provides presentation. Objective-C transport/controller code bridges Apple platform mechanics to the shared diagnostic core. Apple code must not become a duplicate protocol stack.

## Version identity

The root `VERSION` and public `BMWLINK_VERSION` macro must agree at configure time. Release/platform builds therefore consume one project version.

## Tests

- `test_smoke.c` checks product/version/dependency integration.
- `test_obd2.c` checks the inherited standards-facing baseline through the product facade.
- `test_generic_diagnostics.c` checks generic diagnostic flow exposure through BMWLINK.

These tests establish the generic baseline only; they do not constitute BMW-specific module/network qualification.

## Ownership rule

BMW-specific VIN/profile/module/network/definition behaviour belongs here when evidence exists. Until then, the repository remains deliberately thin rather than filling gaps with guessed manufacturer data.
