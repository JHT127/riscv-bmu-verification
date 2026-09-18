# Verification Input Baseline

## Baseline identity

This baseline freezes the inputs used to make the BMU verification project
operable and reproducible. It is a control record for the current repository
snapshot and the adopted verification assumptions. It is not a replacement for
the specification or a source for expected-value changes.

| Item | Frozen value |
|---|---|
| Repository scope | `BMU-verification` working tree |
| Specification authority | BMU Specification v1.2 and the clarification log |
| Simulator | Cadence Xcelium `xrun(64) 25.03-s006` |
| UVM library | Cadence UVM 1.1d |
| Expected-value authority | Independent specification-based reference model |
| DUT change policy | No RTL changes are made by the verification team to close findings |
| Signoff stance | Pre-closure: documented runtime defects remain open |

## Controlled specification inputs

The project explicitly recognizes these as the authoritative evidence inputs:

- `docs/00_spec/README.md`
- `docs/03_clarifications_log/spec_clarifications_log.md`
- `docs/02_test_plan/BMU_Test_Plan.md`
- `docs/04_bug_reports/BMU_Bug_Log.md`
- `docs/07_coverage_reports/final_coverage_summary.md`
- `docs/07_coverage_reports/coverage_waivers.md`

The behavioral interpretation used by the reference model and the assertions is
based on the specification and the clarity log. The runtime bug log is not a
secondary source of truth; it is a record of confirmed findings against the
primary specification authority.

## Controlled RTL inputs

The delivered RTL snapshot under verification is:

- `rtl/Bit_Manipulation_Unit.sv`
- `rtl/rtl_def.sv`
- `rtl/rtl_defines.sv`
- `rtl/rtl_lib.sv`
- `rtl/rtl_param.sv`
- `rtl/rtl_pdef.sv`
- `rtl/library/`
- `rtl/rtl_filelist.f`

The RTL is the implementation under test. It is not used to derive expected
values, coverage goals, or test stimulus constraints.

## Controlled testbench inputs

The smoke simulation and verification environment use these contract files and
their included components:

- `tb/packages/bmu_types_package.sv`
- `tb/interface/bmu_interface.sv`
- `tb/packages/bmu_pkg.sv`
- `tb/top/bmu_tb_top.sv`
- `tb/env/` reference model, scoreboard, checker, and environment
- `tb/sequences/` family sequence library
- `tb/tests/` concrete UVM tests

The Xcelium source order is controlled by `sim/filelists/xcelium.f`.

## Current verification facts

The project has already produced the following evidence and should treat it as
part of the baseline record:

- Valid smoke test and directed-suite compile/run flow under Xcelium.
- Independent reference model mismatches against the RTL in multiple data-path
  and guard checks.
- Runtime-confirmed DUT defects in `docs/04_bug_reports/BMU_Bug_Log.md`.
- Functional coverage closure for the supported legal model at 100.00% in the
  closure run.
- Measured aggregate code-coverage baseline of 17.74% in the merged run.

The coverage numbers must not be interpreted as full signoff because the bug log
indicates unresolved specification violations in the DUT.

## Assumption lock

These behaviors remain assumption-tagged and must not be silently changed in a
test, report, or bug record. Because the design team is unavailable, the
project adopts these interpretations for closure using the safest reading of the
specification and worked examples. They are accepted project risks, not
confirmed design-team behavior.

- GREV with `b_in[4:0] != 24` is treated as invalid with `result=0` and
  `error=1` pending `CLARIF-004`.
- Pure CSR bypass read is valid when `csr_ren_in=1` and no BMU operation is
  active; CSR combined with an active BMU operation is invalid pending
  `CLARIF-005`.
- One-cycle result timing, live `error`, synchronous reset, and scan behavior
  follow the current model pending written confirmation under `CLARIF-001`.
- Unsupported section-8 fields remain out of scope unless the specification
  author formally adds them to the scope.

Any new repository evidence that disproves these rules requires a coordinated
update to the reference model, test plan, sequences, coverage, and bug
dispositions. External confirmation is not a prerequisite for this project's
closure gate, but the residual risk must remain visible in signoff.

## Active bug record summary for downstream authoring

The project currently holds these active runtime-confirmed defects:

- BMU-BUG-001: CPOP width issue.
- BMU-BUG-002: PACK ordering issue.
- BMU-BUG-003: CSR write source issue.
- BMU-BUG-005: GREV byte-order issue.
- BMU-BUG-006: invalid/conflicting controls not rejected.
- BMU-BUG-007: SLT/MAX missing SUB co-requisite guard.
- BMU-BUG-008: GREV undefined encoding not rejected.
- BMU-BUG-009: CTZ one-hot mismatch.

One earlier issue, BMU-BUG-004, was withdrawn after runtime verification showed
it was not a real DUT defect.

A verification-plan writer or bug writer should use this list together with the
runtime logs and the ref model to produce the final evidence package.

## Change control

This baseline is valid only when the repository state, source filelists,
simulator version, assumption status, and active bug list are recorded with each
regression run. A DUT revision change requires a new baseline record or an
explicit baseline update before results can be compared.

The verification team must keep the project honest:

- no hidden RTL edits to close findings
- no silent model changes without updating the clarifications
- no coverage closure claims beyond the supported legal domain
- no signoff claim while confirmed DUT defects remain open
