# BMU Test Plan

## 1. Purpose and authority

Verify the delivered BMU against Specification v1.2. Expected values come from the specification and adopted clarifications. Tests report both `result_ff` and `error`; failing tests remain failures on the original DUT.

The supplied Excel/PDF plans are retained as the original planning baseline. This document records the executable submission scope and additions.

## 2. Confirmed scope

OR/XOR with optional ZBB inversion; SRL/SRA/ROR; BINV; SH2ADD; SUB; SLT/SLTU; CTZ/CPOP; SEXT.B; signed MAX; PACK; GREV encoding 24; CSR read/write; reset, valid, live error, and operation guards.

Standalone CLZ, MIN, ROL, BSET/BCLR/BEXT, SLL/AND/ADD, SEXT.H, SH1ADD/SH3ADD, PACKU/PACKH, GORC, branch, and prediction behavior is not defined by this project's operation tables. Those standalone operations are excluded. Forbidden-field checks still drive their controls alongside in-scope operations.

## 3. Executable scenarios

| Test | Stimulus | Expected check |
|---|---|---|
| `bmu_model_self_test` | Spec examples; all forbidden fields; modifier/co-requisite cases; count boundaries; predictor reset/hold | 865 independent expected-value/state checks pass |
| `bmu_or_valid_test` | Complementary OR operands | Correct result and no error |
| `bmu_nominal_directed_test` | Legal example for each specified family, CSR mode, and signed/unsigned comparison | Specification arithmetic/data result; no false guard failures |
| `bmu_error_directed_test` | Operation conflicts, CSR conflicts, missing required modes, invalid GREV | Zero result and error asserted on capture |
| `bmu_timing_reset_test` | Back-to-back data, between-edge stability, hold, reset from nonzero state, reset release, scan assumption | Correct capture/hold/reset and recovery |
| `bmu_gap_checks_test` | All 32 BINV/shift positions, CPOP halves, CTZ one-hot sweep, explicit guard and idle cases | Boundary results and live error |
| `bmu_guard_matrix_test` | Each forbidden control bit for each legal operation, valid=0/1, CSR conflicts, missing ZBA/SUB | Explicit guard rejection; hold result when valid=0 |
| `bmu_coverage_closure_test` | All suites above plus operation×pattern×valid cases, shifts with upper amount bits varied, counts 0–32, comparison sign/equality boundaries, all 256 low bytes with upper-bit variation, all GREV encodings | Complete declared scenario bins; all mismatches retained |
| `bmu_legal_random_test` | 100 random legal transactions per seed | Data correctness across operations and modes |
| `bmu_corner_random_test` | 100 transactions with independently selected operand corners per seed | Equality, signs, limits, and operand interactions |
| `bmu_error_random_test` | 100 controlled-invalid transactions per seed | Rejection without silently accepting invalid controls |
| `bmu_bug_NNN_test` | Minimal isolated input for one canonical bug | Exact recorded mismatch; retest entry point for a future fix |

## 4. Coverage obligations

- Each of 17 specified operation classes and seven operand-pattern classes.
- Each requested operation under valid/idle and clean/rejected conditions where reachable.
- All 32 low-five-bit shift/index amounts for SRL/SRA/ROR/BINV.
- CTZ and CPOP expected counts 0–32, separately crossed with operation.
- Both ZBB modes for OR and XOR; signed and unsigned SLT.
- Comparison sign combinations and less/equal/greater relationships.
- SEXT.B bit 7 independently varied from bit 31.
- GREV encoding 24 plus each of the other 31 encodings under the adopted assumption.
- CSR bypass, register write, and immediate write.
- Reset states and assert/release transitions.

Coverage uses stimulus and specification classification; DUT outputs cannot manufacture coverage. Full masks are validated by the predictor self-test before DUT mismatch triage.

## 5. Execution and status

```bash
make -C sim regression
make -C sim regression CONFIG=../regression/configs/bugs.cfg
```

See the [traceability matrix](traceability_matrix.md), [measured regression](../../results/reports/regression_summary.csv), and [bug log](../04_bug_reports/BMU_Bug_Log.md). “Exercised” means the scenario ran; it does not mean the buggy DUT passed it.
