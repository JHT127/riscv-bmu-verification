# BMU Verification Traceability Matrix

## Purpose

This matrix is the review-facing traceability record for the BMU training project. It connects each plan item to the executable verification evidence and records the present status honestly.

## Current traceability status

| Plan ID / requirement | Area | Executable test or sequence | Evidence path | Coverage status | Current status |
|---|---|---|---|---|---|
| `OR_VALID` | valid | `bmu_or_valid_test` | `results/logs/bmu_or_valid_test_1.log` | 19.07% | present, smoke only |
| `TIMING_RESET` | timing/reset | `bmu_timing_reset_test` | `results/logs/bmu_timing_reset_test_1.log` | 31.69% | present, baseline only |
| `TC_BINV_004` | BINV | not yet mapped to a dedicated executable test | planned | missing | open |
| `TC_SHIFT_004` | SRL/SRA/ROR | not yet mapped to a dedicated executable test | planned | missing | open |
| `TC_CPOP_004` | CPOP | not yet mapped to a dedicated executable test | planned | missing | open |
| `TC_CTZ_005` | CTZ | not yet mapped to a dedicated executable test | planned | missing | open |
| `TC_GUARD_001` | guard | `bmu_gap_checks_test` covers the empty-request class | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| `TC_GUARD_002` | guard | `bmu_gap_checks_test` includes stray-mode checks | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| `TC_GUARD_003` | guard | not yet mapped as a dedicated executable row | planned | missing | open |
| `TC_GUARD_004` | guard | not yet mapped as a dedicated executable row | planned | missing | open |
| `TC_SLT_005` | SLT | `bmu_gap_checks_test` includes a missing-SUB check | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| `TC_MAX_005` | MAX | `bmu_gap_checks_test` includes a missing-SUB check | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| `TC_CSR_005` | CSR | `bmu_gap_checks_test` includes valid/idle CSR cases | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| `TC_TIME_004` | timing | `bmu_gap_checks_test` includes invalid-idle timing behavior | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| `TC_RESET_004` | reset | `bmu_gap_checks_test` includes reset-conflict behavior | `results/logs/bmu_gap_checks_test_1.log` | 63.32% | partial |
| legal random | random legal | `bmu_legal_random_test` | `results/logs/bmu_legal_random_test_101.log` | 66.39% | present |
| corner random | random corner | `bmu_corner_random_test` | `results/logs/bmu_corner_random_test_201.log` | 57.24% | present |
| invalid random | random error | `bmu_error_random_test` | `results/logs/bmu_error_random_test_301.log` | 47.57% | present |
| unsupported Section 8 paths | excluded scope | not supported in `bmu_ctrl_t` | waiver document | excluded | intentionally out of scope |
| scan-only behavior | DFT assumption | `scan_mode_seq` | sequence inventory | assumption check only | not counted as functional coverage |

## Review note

This matrix shows the real project status: some checks exist and some are only partially exercised, but the full original plan is not yet implemented as a one-to-one executable matrix. The professional DV expectation is to resolve this before any final sign-off discussion.

## Recommended next training backlog

1. Convert each missing `TC_*` row into its own dedicated sequence/test.
2. Add dedicated coverage bins for each row in the functional covergroup.
3. Retest each row after a fix or design disposition.
4. Keep the same seed and log path for all evidence.
5. Stop at a pre-closure assessment rather than claiming final sign-off.
