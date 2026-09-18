# Randomization Plan

## Scope

Randomized verification is required for BMU closure. The current implementation
uses reproducible Xcelium seeds passed through `+ntb_random_seed` and records a
per-test coverage database under `results/coverage/`.

## Randomized tests

| Test | Stimulus contract | Configuration |
|---|---|---|
| `bmu_legal_random_test` | 100 legal transactions across every documented operation, including CSR writes and valid GREV | `regression/configs/legal_random.cfg` |
| `bmu_corner_random_test` | 100 corner-weighted transactions across every documented operation | `regression/configs/corner_random.cfg` |
| `bmu_error_random_test` | 100 invalid transactions across multi-primary, CSR, ZBB, CSR mode, ZBA, missing SUB, and invalid GREV classes | `regression/configs/error_random.cfg` |

Section 8 controls remain excluded from legal and corner randomization. Invalid
randomization intentionally exercises only documented guard violations and the
adopted GREV invalid-encoding assumption.

## Baseline seed evidence

| Test | Seed | Samples | Functional coverage | UVM errors | Status |
|---|---:|---:|---:|---:|---|
| `bmu_legal_random_test` | 101 | 101 | 66.39% | 45 | Open DUT findings |
| `bmu_corner_random_test` | 201 | 101 | 57.24% | 18 | Open DUT findings |
| `bmu_error_random_test` | 301 | 101 | 47.57% | 84 | Open DUT findings |

These are baseline measurements, not closure results. The failures are
expected to remain visible until the corresponding DUT bugs are fixed or
accepted as project risk.

## Reproducibility rule

A failure is reproducible only when the test name, seed, simulator version,
RTL revision, and configuration are preserved. A corrected RTL revision must
rerun the original seed before a bug disposition changes.
