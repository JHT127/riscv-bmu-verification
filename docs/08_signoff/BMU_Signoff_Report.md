# BMU Sign-off Report

## 1. Scope

This report documents the current verification status for the BMU DUT as of the repository state captured in this project. It is intended for engineering review and closure preparation, not final design sign-off.

## 2. Verification status summary

The project has completed the required DV infrastructure work for directed checks, assertions, random verification, coverage collection, and regression reporting. However, the current DUT still shows open runtime findings and is not yet in a final sign-off state.

## 3. Verification evidence

### 3.1 Directed checks

The repository currently contains a directed gap suite and runtime evidence for the open findings.

Evidence:

- [results/logs/bmu_gap_checks_test_1.log](../../results/logs/bmu_gap_checks_test_1.log)
- [results/logs/bmu_nominal_directed_test_1.log](../../results/logs/bmu_nominal_directed_test_1.log)
- [results/logs/bmu_error_directed_test_1.log](../../results/logs/bmu_error_directed_test_1.log)

Observed outcomes:

- gap suite: 131 matches, 41 mismatches, 0 fatals
- nominal suite: 7 mismatches, 0 fatals
- error suite: 7 mismatches, 0 fatals

### 3.2 Random verification

The repository contains legal, corner, and invalid randomized tests with seed-based reproducibility.

Evidence:

- [results/logs/bmu_legal_random_test_101.log](../../results/logs/bmu_legal_random_test_101.log)
- [results/logs/bmu_corner_random_test_201.log](../../results/logs/bmu_corner_random_test_201.log)
- [results/logs/bmu_error_random_test_301.log](../../results/logs/bmu_error_random_test_301.log)

Observed outcomes:

- legal random: 45 mismatches, 0 fatals, 66.39% functional coverage
- corner random: 18 mismatches, 0 fatals, 57.24% functional coverage
- error random: 84 mismatches, 0 fatals, 47.57% functional coverage

### 3.3 Functional coverage

The coverage model currently reports the following functional coverage values from the executed log files:

| Run | Coverage |
|---|---:|
| `bmu_or_valid_test` | 19.07% |
| `bmu_timing_reset_test` | 31.69% |
| `bmu_gap_checks_test` | 63.32% |
| `bmu_legal_random_test` | 66.39% |
| `bmu_corner_random_test` | 57.24% |
| `bmu_error_random_test` | 47.57% |

These are regression baselines. The dedicated `bmu_coverage_closure_test`, seed 4, reaches 100.00% functional coverage with zero uncovered covergroup bins; the open UVM errors remain DUT findings.

## 4. Code coverage status

The merged Xcelium database reports 17.74% aggregate code coverage
(2,587/14,581), 23.54% in the type-hierarchy view, and 53.85% assertion
status. No FSMs were extracted. These are measured baselines, not RTL
sign-off results.

Correct status:

- functional coverage: 100.00% for the declared in-scope model
- code coverage: measured baseline, not closed

## 5. Open bug status

The project currently tracks the following open runtime-confirmed issues in [docs/04_bug_reports/BMU_Bug_Log.md](../04_bug_reports/BMU_Bug_Log.md):

- `BMU-BUG-001` CPOP width
- `BMU-BUG-002` PACK ordering
- `BMU-BUG-003` CSR write source
- `BMU-BUG-005` GREV byte ordering
- `BMU-BUG-006` invalid/conflicting controls
- `BMU-BUG-007` SLT/MAX co-requisites
- `BMU-BUG-008` GREV undefined-encoding assumption
- `BMU-BUG-009` CTZ reversal

`BMU-BUG-004` is withdrawn after a passing runtime check and is not treated as an active DUT defect.

## 6. Assumption and waiver status

Assumption-tagged items are recorded in [docs/03_clarifications_log/spec_clarifications_log.md](../03_clarifications_log/spec_clarifications_log.md).

The explicit exclusions and waivers are in [docs/07_coverage_reports/coverage_waivers.md](../07_coverage_reports/coverage_waivers.md).

This project uses conservative assumptions for:

- `CLARIF-001` reset/valid/scan timing behavior
- `CLARIF-004` GREV invalid encoding
- `CLARIF-005` CSR conflict scope

These are accepted as project risk, not design-team confirmation.

## 7. Final assessment

The current repository is in a professional pre-closure state.

It is ready for:

- design review,
- issue triage,
- closure discussion with the design owner,
- final sign-off only after the open DUT findings are fixed or formally accepted by the responsible authority.

It is not ready for a final sign-off claim because:

- open runtime-confirmed issues remain,
- open DUT findings remain despite functional coverage closure,
- code coverage is measured but remains a baseline rather than a closed result,
- there is no final design-owner sign-off on the accepted-risk items.

## 8. Recommended next step

The next engineering step is to fix or formally disposition the open runtime findings, then rerun the exact reproducer and regression suite before preparing the final close-out report.
