# Test-to-Evidence Traceability

| Requirement / original ID | Executable test | Evidence |
|---|---|---|
| Legal operation tables | `bmu_nominal_directed_test` | Regression summary; isolated bug logs |
| `TC_BINV_004`, `TC_SHIFT_004` | `bmu_gap_checks_test`, `bmu_coverage_closure_test` | All positions in shift×amount bins |
| `TC_CPOP_004`, `TC_CTZ_005` | `bmu_gap_checks_test`, `bmu_coverage_closure_test` | Count×operation bins; BUG-001/009 |
| `TC_GUARD_001` through `004` | `bmu_gap_checks_test`, `bmu_guard_matrix_test` | Guard failures; BUG-006 |
| `TC_SLT_005`, `TC_MAX_005` | `bmu_gap_checks_test`, `bmu_guard_matrix_test` | Missing-SUB checks; BUG-007 |
| `TC_CSR_005`, `TC_TIME_004`, `TC_RESET_004` | `bmu_gap_checks_test` | Idle CSR/error and reset-conflict checks |
| Timing/reset/scan assumption | `bmu_timing_reset_test` | 17 comparisons, zero mismatches |
| Independent predictor validation | `bmu_model_self_test` | 865 checks, zero errors |
| Full guard masks | `bmu_guard_matrix_test` | 1,451 observed cycles; valid and idle cases |
| Legal/corner/invalid random | Corresponding `bmu_*_random_test`, three seeds each | Effective seeds and counts in regression CSV |
| Nine DUT defects | `bmu_bug_001_test` through `010`, excluding withdrawn `004` | One retained evidence file per bug |
| Declared scenario closure | `bmu_coverage_closure_test`, seed 4 | 562/562 functional bins |

All original gap IDs remain logged by the gap suite; dedicated `bmu_tc_*_test` classes remain available for focused debugging. The [regression CSV](../../results/reports/regression_summary.csv) is the execution record. [Bug entries](../04_bug_reports/BMU_Bug_Log.md) link exact inputs and observed outputs.
