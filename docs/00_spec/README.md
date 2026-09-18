# Specification

The controlled BMU Specification v1.2 PDF is present in this repository for
the verification baseline. The specification is the behavior authority; RTL
is never used to create expected values.

The current verification input baseline is documented in
[`verification_input_baseline.md`](verification_input_baseline.md). It records
the specification revision, RTL snapshot, simulator version, test-plan
baseline, and assumption status used for simulation.

## Controlled inputs

- `BMU_Specification_v1.2.pdf` — functional behavior, port list, and
  per-operation behavior tables.
- [`../03_clarifications_log/spec_clarifications_log.md`](../03_clarifications_log/spec_clarifications_log.md)
  — tracked questions, assumptions, and resolutions.
- [`verification_input_baseline.md`](verification_input_baseline.md) — frozen
  execution inputs and change-control rules.
