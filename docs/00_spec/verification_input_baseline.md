# Verification Input Baseline

## Controlled inputs

| Item | Submission baseline |
|---|---|
| Behavior authority | BMU Specification v1.2 and the clarification log |
| DUT | Original `rtl/Bit_Manipulation_Unit.sv` and its delivered dependencies |
| Testbench | `tb/`, compiled by `sim/filelists/xcelium.f` |
| Simulator | Xcelium 25.03-s006, Cadence UVM 1.1d |
| Coverage tool | IMC 25.09-a020 |
| Simulation top | `bmu_tb_top` |
| Structural coverage scope | `bmu_tb_top.dut`, including instantiated children |
| Full regression | `regression/configs/full.cfg` |
| Source identity | [run_manifest.json](../../results/reports/run_manifest.json) |

The manifest records the source commit, file hashes, specification hash, effective run set, and log hashes. The delivered RTL has not been changed to close findings. The separate `fix_v1` sources are not part of the default filelist or submission results.

## Adopted assumptions

The [clarification log](../03_clarifications_log/spec_clarifications_log.md) remains the authority for assumptions:

- `CLARIF-001`: registered capture, valid hold, reset, live error, and scan behavior.
- `CLARIF-004`: GREV encodings other than 24 return zero and assert error.
- `CLARIF-005`: pure CSR bypass is legal; CSR combined with operation controls is invalid.

These are project assumptions, not written design-owner acceptance. Unsupported standalone operations remain outside the specified scope. Their bits can still violate the guard of a specified operation.

## Change control

A change to RTL, specification, control classification, or expected values requires rerunning affected tests and updating retained evidence. Functional coverage closure does not close a DUT bug. A bug is fixed only after the supplied revised DUT passes its reproducer and relevant regression.
