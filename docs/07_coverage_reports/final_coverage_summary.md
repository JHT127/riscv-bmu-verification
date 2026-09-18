# Final Coverage Summary

## Scope and status

This document records the measured functional coverage status for the BMU training project. The goal is functional scenario closure for bug-finding; RTL correctness is assessed separately by the scoreboard and assertions.

The values below are the current measured runtime coverage baselines from the repository's simulator logs. They are evidence of current verification status, not a final closure claim.

## Functional coverage baseline

| Run | Seed | Functional coverage | Evidence |
|---|---:|---:|---|
| `bmu_or_valid_test` | 1 | 19.07% | `results/logs/bmu_or_valid_test_1.log` |
| `bmu_timing_reset_test` | 1 | 31.69% | `results/logs/bmu_timing_reset_test_1.log` |
| `bmu_gap_checks_test` | 1 | 63.32% | `results/logs/bmu_gap_checks_test_1.log` |
| `bmu_legal_random_test` | 101 | 66.39% | `results/logs/bmu_legal_random_test_101.log` |
| `bmu_corner_random_test` | 201 | 57.24% | `results/logs/bmu_corner_random_test_201.log` |
| `bmu_error_random_test` | 301 | 47.57% | `results/logs/bmu_error_random_test_301.log` |
| `bmu_coverage_closure_test` | 4 | 100.00% | `results/logs/bmu_coverage_closure_test_4.log` |

## Overall functional coverage statement

The dedicated coverage closure test reaches 100.00% functional coverage with seed 4. IMC reports zero uncovered covergroup bins in the corresponding Xcelium database under `results/coverage/bmu_coverage_closure_test_4/`.

The closure test reports 62 UVM errors and zero UVM fatals. Those failures are retained as DUT bug evidence; they do not reduce the scenario coverage result.

The correct professional statement is:

- functional coverage is measured and tracked per run,
- the dedicated closure test reaches 100.00%,
- the coverage model uses expected count/error intent for scenario coverage, so DUT bugs cannot hide planned bins,
- the scoreboard and assertions still report the DUT failures independently.

## Code coverage status

The repository includes Xcelium coverage databases under `results/coverage/`, but there is no final code-coverage report with a full line/branch sign-off statement.

The appropriate status remains:

- code coverage is not yet closed,
- no final project-wide code-coverage percentage is claimed,
- code coverage is separate from the 100.00% functional coverage result and is not claimed closed here.

## Final training-project assessment

This is functional coverage closure for the current bug-finding scope, not RTL sign-off. Open DUT findings remain intentionally visible in the regression evidence.
