# Contributing to BMWLink

BMWLink is a manufacturer product face over the shared Link diagnostics engine. Contributions must preserve the dependency direction **Common → Link → BMWLink** and keep product-neutral diagnostics out of this repository.

## Ownership

- Common owns broadly reusable non-automotive primitives.
- Link owns generic transports, OBD, ISO-TP, UDS/KWP/DoIP, diagnostic sequencing, evidence/safety policy and common application behaviour.
- BMWLink owns BMW-specific identity, network/module knowledge, verified definitions, product presentation and genuinely manufacturer-specific behaviour.
- If a change is useful across manufacturers, improve Link rather than creating a private BMWLink copy.
- Do not modify the nested Link/Common source from this repository as a substitute for updating the dependency deliberately.

## Languages and platform boundaries

C and C++ are preferred first-party implementation languages; choose whichever gives the stronger implementation for the component. Swift and Objective-C are appropriate at Apple platform/UI/CoreBluetooth boundaries. GTK and Win32 code should remain shell/provider code rather than a second diagnostic engine.

## Evidence discipline

Manufacturer knowledge must be traceable. Useful evidence includes public/official documentation, sanitised captures with known context and repeatable physical-vehicle observation.

Generic UDS/OBD behaviour is not by itself evidence that a BMW-specific identifier or procedure means what another brand uses it for. Unknown values stay raw or unavailable until interpretation is justified.

Do not copy proprietary diagnostic databases, security algorithms, procedure payloads or source from commercial tools. Mature tools may be studied for architecture/workflow only where legally and technically appropriate.

## Safety

Decode support, adapter capability and transmit permission are separate contracts. Adding a DID, module or service decoder does not automatically permit sending a request. New manufacturer-specific transmit paths need explicit safety classification and regression coverage.

Read-only discovery should remain bounded. Failed/not-scanned/scanning/clean states must remain distinct.

## Build and test

```sh
git submodule update --init --recursive
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
ctest --test-dir build --output-on-failure
```

Product changes should keep Link's own shared test suite healthy through the pinned dependency and add BMWLink-level tests for manufacturer semantics introduced here.

## Documentation

Use `docs/README.md` as the map. Update Architecture when ownership changes, Design when principles/trade-offs change, Decisions for durable choices, Roadmap for direction and Validation for evidence/support boundaries.

Do not inflate documentation with guessed manufacturer coverage merely to match another product's page count.

## Repository policy

`main` is the working development/release branch. Published tags/releases are immutable. The exact BMWLink source and Link gitlink together define a tested product revision.

## Licence

Contributions are accepted under the repository licence unless explicitly agreed otherwise.