# Reference Model Audit

## Audit scope

The model in `tb/env/reference_model/bmu_reference_model.sv` was reviewed against
Specification v1.2 before expanding executable tests. The RTL was not used to
define expected values.

## Confirmed behavior

- Result state is held when `valid_in=0` and cleared during reset.
- `error` is calculated from the current transaction and remains live when
  `valid_in=0`.
- CSR bypass read is valid only with no active BMU operation and returns
  `csr_rddata_in`.
- OR/XOR ZBB inversion, shifts, BINV, SH2ADD, SUB, SLT/SLTU, CTZ, CPOP,
  SEXT.B, MAX, PACK, GREV, and CSR writes use specification-side expressions.
- CTZ scans all 32 bits and returns 32 for zero.
- CPOP scans all 32 bits.
- PACK uses `{b_in[15:0], a_in[15:0]}`.
- CSR immediate mode selects `b_in`; register mode selects `a_in`.
- The model rejects multiple primary operations and invalid mode/co-requisite
  combinations.

## Assumption-dependent behavior

- GREV encodings other than 24 are modeled as `result=0`, `error=1` pending
  `CLARIF-004`.
- CSR conflict scope follows the valid pure-bypass interpretation pending
  `CLARIF-005`.
- Timing, reset, and scan behavior follow the current adopted model pending
  `CLARIF-001`.

These assumptions are not silently changed by a test or bug disposition.

## Structural checks added

The scoreboard now checks for unmatched actual/reference transactions in
UVM `check_phase`. This prevents a test from passing when the model or monitor
silently drops a transaction.

The executable timing/reset suite exercises back-to-back transactions,
registered result timing, valid hold, reset, and scan behavior. It passed with
15 result/error comparisons and zero UVM errors in the current Xcelium run.

## Runtime evidence

The nominal and directed-error suites now run through the same independent
model and scoreboard. Their current mismatches are DUT findings, not model
waivers:

- Nominal suite: 7 scoreboard mismatches, including SLT/MAX, PACK, GREV, and
  CSR write behavior.
- Error suite: 7 scoreboard mismatches, including missing invalid-control and
  co-requisite errors.

The detailed reproducers and dispositions are tracked in
`docs/04_bug_reports/BMU_Bug_Log.md`. A model change requires re-running the
focused timing suite and the affected directed suite before any bug is closed.
