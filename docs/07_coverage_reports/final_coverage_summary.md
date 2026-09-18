# Final Coverage Summary

## Scope and status

This document records the final measured coverage status for the BMU training project. The project is not a final sign-off exercise and must not be presented as fully closed.

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

## Overall functional coverage statement

The best current measured functional coverage is 66.39%, from the legal-random run with seed 101.

This is not a final project-wide coverage closure number. The repository does not contain a merged overall functional coverage report across all legal bins, because the project is still in a pre-closure state and the current DUT still has open runtime findings.

The correct professional statement is:

- functional coverage is measured and tracked per run,
- the highest current measured value is 66.39%,
- the project is not yet at the final functional coverage target,
- the current state is a measured coverage baseline, not a closed metric.

## Code coverage status

The repository includes Xcelium coverage databases under `results/coverage/`, but there is no final code-coverage report with a full line/branch sign-off statement.

The appropriate status is:

- code coverage is not yet closed,
- no final project-wide code-coverage percentage is claimed,
- the project remains in a pre-closure state until the open DUT findings are fixed or formally accepted.

## Final training-project assessment

This document is the final coverage statement for the training project.

It intentionally stops at a professional pre-closure level:

- measured coverage exists,
- evidence exists,
- open findings remain,
- no false final sign-off claim is made.
