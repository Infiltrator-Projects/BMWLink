# Validation

## Evidence model

Build, unit, integration, lifecycle and physical-hardware evidence prove different things and are recorded separately.

## Automated gates

- .github/workflows/ci.yml
- .github/workflows/release.yml

tests/ currently proves generic diagnostics, OBD-II integration and product smoke behaviour. BMW-specific coverage must be added alongside BMW-specific implementation rather than inferred from these generic tests.

## Manual/environment evidence

Physical BMW vehicle/module and adapter behaviour requires real hardware evidence. Generic/simulated diagnostics are not a substitute for manufacturer validation.

Do not promote fixture/simulator/chroot evidence into a broader claim than the environment actually exercised.

## Release/publication criterion

The exact source revision and pinned dependencies/releases intended for publication must pass required gates. Artifacts must be traceable to that identity and documentation must not advertise known-failing or merely planned behaviour.

## Regression rule

Reproducible defects gain permanent automated coverage where practical, at the narrowest layer that captures the failure.
