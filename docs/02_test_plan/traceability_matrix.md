# BMU Verification Traceability Matrix

## Purpose

This matrix is the review-facing traceability record for the BMU training project. It connects each plan item to the executable verification evidence and records the present status honestly.

## Current traceability status

| Plan ID / requirement | Area | Executable test or sequence | Evidence path | Coverage status | Current status |
|---|---|---|---|---|---|
| `OR_VALID` | valid | `bmu_or_valid_test` | `results/logs/bmu_or_valid_test_1.log` | 19.07% | present, smoke only |
| `TIMING_RESET` | timing/reset | `bmu_timing_reset_test` | `results/logs/bmu_timing_reset_test_1.log` | 31.69% | present, baseline only |
| `TC_BINV_004` | BINV | `bmu_tc_binv_004_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT findings may remain |
| `TC_SHIFT_004` | SRL/SRA/ROR | `bmu_tc_shift_004_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT findings may remain |
| `TC_CPOP_004` | CPOP | `bmu_tc_cpop_004_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT findings may remain |
| `TC_CTZ_005` | CTZ | `bmu_tc_ctz_005_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT findings may remain |
| `TC_GUARD_001` | guard | `bmu_tc_guard_001_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| `TC_GUARD_002` | guard | `bmu_tc_guard_002_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| `TC_GUARD_003` | guard | `bmu_tc_guard_003_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT findings may remain |
| `TC_GUARD_004` | guard | `bmu_tc_guard_004_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT findings may remain |
| `TC_SLT_005` | SLT | `bmu_tc_slt_005_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| `TC_MAX_005` | MAX | `bmu_tc_max_005_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| `TC_CSR_005` | CSR | `bmu_tc_csr_005_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| `TC_TIME_004` | timing | `bmu_tc_time_004_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| `TC_RESET_004` | reset | `bmu_tc_reset_004_test`, `bmu_coverage_closure_test` | `results/logs/bmu_coverage_closure_test_4.log` | closed by stimulus | DUT finding remains |
| legal random | random legal | `bmu_legal_random_test` | `results/logs/bmu_legal_random_test_101.log` | 66.39% | present |
| corner random | random corner | `bmu_corner_random_test` | `results/logs/bmu_corner_random_test_201.log` | 57.24% | present |
| invalid random | random error | `bmu_error_random_test` | `results/logs/bmu_error_random_test_301.log` | 47.57% | present |
| unsupported Section 8 paths | excluded scope | not supported in `bmu_ctrl_t` | waiver document | excluded | intentionally out of scope |
| scan-only behavior | DFT assumption | `scan_mode_seq` | sequence inventory | assumption check only | not counted as functional coverage |

## Review note

The dedicated gap-plan tests and closure sequence now exercise all listed gap-plan rows. “Closed by stimulus” means the scenario is covered; it does not mean the current DUT passes the expected behavior.

## Recommended next training backlog

1. Retest each row after a DUT fix or design disposition.
2. Keep the same seed and log path for all evidence.
3. Preserve the distinction between stimulus coverage and DUT correctness.
