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


## Coverage model audit

The declared model contains 206 cover bins and the seed-4 closure database
reports zero uncovered bins. The audited scope includes:

- all 18 operation classifications represented by `bmu_ctrl_t` and CSR read,
- OR/XOR ZBB modes, all 32 shift amounts, and all 32 BINV positions,
- CTZ/CPOP expected values 0 through 32,
- operand sign, signed/unsigned SLT, GREV valid/invalid encoding, and all CSR modes,
- reset, valid, scan, and expected-error states,
- operation x valid and operation x expected-error crosses.

Count and error coverage intentionally use independent specification-derived
functions (`expected_count` and `expected_error`). This prevents an incorrect
DUT output from either hiding stimulus coverage or manufacturing a false
coverage result. The scoreboard and assertions remain the correctness checks.

## Overall code coverage status

The distinct Xcelium run databases were merged with IMC into
`results/coverage/overall_code_coverage`. The merge reported zero conflicts and
zero unmerged items. The committed extraction record is
`results/reports/overall_code_coverage_summary.txt`.

| Metric | Result | Evidence |
|---|---:|---|
| Aggregate code coverage | 17.74% (2,587/14,581) | IMC merged report |
| Type-hierarchy code view | 23.54% (1,228/5,217) | IMC merged report |
| Assertion status | 53.85% | IMC merged report |
| FSM | N/A; no FSMs extracted | Xcelium elaboration logs |

The code result is a measured baseline, not a closure claim. The merged model
includes the delivered RTL library hierarchy, much of which is not exercised
by the BMU tests. The BMU DUT instance itself is reported separately in the
IMC hierarchy and remains subject to the open bug findings.

## Final training-project assessment

This is functional coverage closure for the current bug-finding scope, not RTL sign-off. Open DUT findings remain intentionally visible in the regression evidence.
