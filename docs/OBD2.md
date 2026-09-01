# Standard OBD-II baseline

BMWLINK inherits standards-based emissions diagnostics from its pinned LINK
dependency before any BMW proprietary data is added.

The baseline includes supported-PID discovery, standard current-data and
freeze-frame request/decoding, readiness, VIN, stored/pending/permanent DTC
reads, generic SAE DTC decoding/knowledge, and OBDonUDS PID/DID mapping.

This is standard OBD coverage, not a claim of BMW proprietary diagnostics.
Those brand-specific identifiers and workflows belong in BMWLINK when
evidence supports them.

The `bmwlink-obd2` CI test proves request generation for 0100, 010C, 0902
and Mode 03, RPM decoding, standard P0133 DTC decoding, and PID 0x0C to F40C
OBDonUDS mapping.
