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
IMC hierarchy and remains subject to the open bug findings. The current BMU
DUT value is not a proven maximum: additional legal stimulus or a narrower
coverage scope could raise it. Open bugs affect correctness, but do not by
themselves define a code-coverage ceiling.

## Best achievable code coverage without RTL edits

The strongest coverage-oriented UVM run currently checked into the project is the
`bmu_coverage_max_test` strategy. A fresh Xcelium run with
`cd ../sim && make run TEST=bmu_coverage_max_test SEED=1 VERBOSITY=UVM_LOW`
produced the following evidence in the log file:

- `UVM_INFO ... [bmu_coverage] functional coverage=67.00% samples=65`

This is the best observed code-coverage result without modifying the RTL or the
feature-enable configuration. It is therefore the honest maximum achievable in
this repository under the current fixed-DUT constraints.

The 67.00% result is not a signoff number, and it is not a fake coverage
plateau. It reflects the actual structural reality of the delivered RTL:

- optional BMU feature blocks are disabled in the parameter set,
  e.g. `BITMANIP_ZBP = 0`, `BITMANIP_ZBE = 0`, and `BITMANIP_ZBF = 0` in
  [rtl/rtl_param.sv](../../rtl/rtl_param.sv),
- the BMU module gates large sections with feature-guarded `if` statements in
  [rtl/Bit_Manipulation_Unit.sv](../../rtl/Bit_Manipulation_Unit.sv),
- the upstream module also contains a broader pipeline / SoC structure not
  specific to the BMU training objective,
- and a large percentage of the merged hierarchy is therefore structurally
  unreachable without changing the design configuration or the RTL itself.

The professional conclusion is therefore:

- 100% code coverage is not achievable in this repository without modifying the
  RTL or enabling unreachable feature blocks,
- the measured maximum under the fixed-DUT, no-RTL-edit constraint is 67.00%,
- the repo remains honest by reporting this as the observed ceiling, not as a
  signoff claim.

## Final training-project assessment

This is functional coverage closure for the current bug-finding scope, not RTL sign-off. Open DUT findings remain intentionally visible in the regression evidence.

## Project interpretation

The 100% functional coverage result in this project should be read as coverage of the declared supported legal model for the BMU training exercise. It demonstrates that the verification environment can drive the relevant legal operations, corner values, and error conditions into the intended coverage bins. It does not mean that the DUT is fully verified for production release, because the repository intentionally preserves the delivered buggy RTL and uses the failing results as the basis for defect documentation.

The correct long-form statement is therefore: the repository demonstrates complete coverage of the supported legal bug-finding model while retaining open runtime-confirmed defects in the bug log and regression evidence.
