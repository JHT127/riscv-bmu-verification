# Reference Model Audit

## Audit scope

The model in `tb/env/reference_model/bmu_reference_model.sv` was reviewed
against the BMU specification before the verification expansion and prior to
any signoff claim. The implemented DUT was not used to define expected values.

This file records the expected behavior used by the scoreboard and the test
plan, and it separates confirmed behavior from adopted assumptions.

## Confirmed behavior

The following are treated as confirmed specification-side behavior and are
implemented in the reference model:

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

The model uses the valid legal domain, not accidental implementation patterns.
Therefore, any mismatch reported by the scoreboard is a real DUT mismatch unless
it is explicitly documented as a scope waiver.

## Assumption-dependent behavior

The following are adopted project assumptions and remain visibly separate from
confirmed behavior:

- GREV encodings other than 24 are modeled as `result=0`, `error=1` pending
  `CLARIF-004`.
- CSR conflict scope follows the valid pure-bypass interpretation pending
  `CLARIF-005`.
- Timing, reset, and scan behavior follow the current adopted model pending
  `CLARIF-001`.
- Unsupported section-8 fields remain out of scope unless a formal spec update
  adds them to the in-scope contract.

These assumptions are not silently changed by a test or a bug disposition.

## Structural checks added

The scoreboard now checks for unmatched actual/reference transactions in UVM
`check_phase`. This prevents a test from passing when the model or monitor
silently drops a transaction.

The executable timing/reset suite exercises back-to-back transactions,
registered result timing, valid hold, reset, and scan behavior. It passed with
15 result/error comparisons and zero UVM errors in the current Xcelium run.

## Runtime evidence and bug mapping

The nominal and directed-error suites run through the same independent model and
scoreboard. Their current mismatches are DUT findings, not model waivers:

- Nominal suite: 7 scoreboard mismatches, including SLT/MAX, PACK, GREV, and
  CSR write behavior.
- Error suite: 7 scoreboard mismatches, including missing invalid-control and
  co-requisite errors.
- Gap-check suite: 131 matches and 41 mismatches at seed 1, consistent with
  the open CPOP, CTZ, guard, and SLT/MAX DUT findings.

The detailed reproducers and dispositions are tracked in
`docs/04_bug_reports/BMU_Bug_Log.md` and `docs/04_bug_reports/bug_report_review.md`.
A model change requires re-running the focused timing suite and the affected
directed suite before any bug is closed.

## Exact bug-to-spec traceability

These are the runtime-confirmed defects and the spec rule they violate:

- BMU-BUG-001: CPOP width issue
  - violates the full-width CPOP rule in the spec and the audit
  - expected: count all 32 bits; actual: lower half only or partial-width result
- BMU-BUG-002: PACK ordering issue
  - violates `result = {b_in[15:0], a_in[15:0]}`
- BMU-BUG-003: CSR write source issue
  - violates `ap.csr_imm=1 => select b_in`, otherwise select `a_in`
- BMU-BUG-005: GREV byte-order issue
  - violates the valid GREV byte-reverse rule for the supported encoding
- BMU-BUG-006: invalid/conflicting controls not rejected
  - violates guard behavior: exactly one valid primary operation is required
- BMU-BUG-007: SLT/MAX without SUB not rejected
  - violates the co-requisite rules for SLT and MAX
- BMU-BUG-008: GREV undefined encoding not rejected
  - violates the adopted invalid-encoding rule with `error=1`
- BMU-BUG-009: CTZ one-hot mismatch
  - violates CTZ semantics across all 32 bit positions and CTZ(0)=32

## Gap-check and assertion evidence

The executable `bmu_gap_checks_test` covers the full set of added test-plan
IDs, including the BINV and shift sweeps. At seed 1 on Xcelium, it produced
131 matching result/error comparisons and 41 mismatches. The mismatches are
consistent with the open CPOP, CTZ, guard, and SLT/MAX DUT findings; they are
not model waivers.

The protocol assertion module is bound through the simulator filelists. The
reset/timing suite passed with all assertions enabled. The gap suite detected the
adopted empty-request, SLT-without-SUB, and MAX-without-SUB violations in
addition to the reference-model evidence.

## Coverage interaction with the model

The reference model intentionally covers the supported legal domain only.
Functional coverage is therefore defined over the in-scope BMU model and not
over unsupported Section 8 fields or residual-project-risk assumptions.

This means:

- 100.00% functional coverage is valid for the supported legal domain
- the measured aggregate code coverage is a separate baseline and not closure
- any model change that affects legal behavior must be reflected in the bug log,
  coverage bins, sequences, and the signoff sections together

## Evidence files for downstream authors

The project expects downstream authors to read the following when writing the
verification plan, test plan, or bug log:

- `docs/00_spec/verification_input_baseline.md`
- `docs/03_clarifications_log/spec_clarifications_log.md`
- `docs/02_test_plan/BMU_Test_Plan.md`
- `docs/04_bug_reports/BMU_Bug_Log.md`
- `docs/04_bug_reports/bug_report_review.md`
- `docs/07_coverage_reports/final_coverage_summary.md`
- `docs/07_coverage_reports/coverage_waivers.md`
- `results/logs/bmu_nominal_directed_test_1.log`
- `results/logs/bmu_error_directed_test_1.log`
- `results/logs/bmu_gap_checks_test_1.log`
- `results/logs/bmu_coverage_closure_test_4.log`
- `results/reports/overall_code_coverage_summary.txt`

## Closure rules

A model change or a bug disposition requires the following before it can be
closed:

1. A reproducer from a legal, well-defined stimulus pattern.
2. An expected value trace from the reference model or written spec.
3. Actual DUT result and error evidence from the log or scoreboard.
4. A fresh regression run on the updated design or a justified accepted-risk note.
5. An explicit update to the bug log, coverage report, and associated docs.

The project remains in a pre-closure state until the open DUT defects are fixed
or formally accepted by the design authority.
