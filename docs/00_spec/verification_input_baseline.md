# Verification Input Baseline

## Baseline identity

This baseline freezes the inputs used to make the BMU smoke simulation
executable. It is a control record, not a replacement for the confidential
functional specification.

| Item | Frozen value |
|---|---|
| Repository revision | `c359efc` (`main`) |
| Specification authority | BMU Specification v1.2 and the public clarification summary |
| Simulator | Cadence Xcelium `xrun(64) 25.03-s006` |
| Test-plan baseline | 64 existing cases plus 13 required additions, 77 planned checks |
| Concrete executable test | `bmu_or_valid_test` |
| Expected-value authority | Independent specification-based reference model |
| RTL change policy | No RTL changes are made by the verification team to close findings |

## Controlled specification inputs

- `docs/00_spec/BMU_Specification_v1.2.pdf`
- `docs/03_clarifications_log/spec_clarifications_log.md`
- `docs/02_test_plan/BMU_Test_Plan.md`
- `docs/04_bug_reports/BMU_Bug_Log.md`

The PDF remains the primary behavior authority. The clarification log records
assumptions and unresolved questions without changing the specification.

## Controlled RTL inputs

The delivered RTL snapshot under verification is:

- `rtl/Bit_Manipulation_Unit.sv`
- `rtl/rtl_def.sv`
- `rtl/rtl_defines.sv`
- `rtl/rtl_lib.sv`
- `rtl/rtl_param.sv`
- `rtl/rtl_pdef.sv`
- `rtl/library/rtl_param.vh`
- `rtl/rtl_filelist.f`

The RTL is an implementation under test. It is not used to derive expected
values, coverage goals, or test stimulus constraints.

## Controlled testbench inputs

The smoke simulation uses these contract files and their included components:

- `tb/packages/bmu_types_package.sv`
- `tb/interface/bmu_interface.sv`
- `tb/packages/bmu_pkg.sv`
- `tb/top/bmu_tb_top.sv`
- `tb/env/` reference model, scoreboard, checker, and environment
- `tb/sequences/logic_ops/or_valid_seq.sv`
- `tb/tests/bmu_or_valid_test.sv`

The Xcelium source order is controlled by `sim/filelists/xcelium.f`.

## Assumption lock

These behaviors remain assumption-tagged and must not be silently changed in a
test or report. Because the design team is unavailable, the project adopts
these interpretations for closure using the safest reading of the
specification and worked examples. They are accepted project risks, not
design-team confirmations:

- GREV with `b_in[4:0] != 24` is treated as invalid with `result=0` and
  `error=1` pending `CLARIF-004`.
- Pure CSR bypass read is valid when `csr_ren_in=1` and no BMU operation is
  active; CSR combined with an active BMU operation is invalid pending
  `CLARIF-005`.
- One-cycle result timing, live `error`, synchronous reset, and scan behavior
  follow the current model pending written confirmation under `CLARIF-001`.

Any new repository evidence that disproves these rules requires a coordinated
update to the reference model, test plan, sequences, coverage, and bug
dispositions. External confirmation is not a prerequisite for this project's
closure gate, but the residual risk must remain visible in sign-off.

## Change control

This baseline is valid only when the repository revision, source filelists,
simulator version, and assumption status are recorded with each regression
run. A DUT revision change requires a new baseline record or an explicit
baseline update before results can be compared.
