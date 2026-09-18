# BMU Coverage Waivers and Exclusions

## 1. Scope

This document records the exact scope of the BMU coverage model and the exclusion rules for unsupported or untestable behavior.

The goal is to make the final sign-off honest:

- Functional coverage is measured only over the supported legal behavior domain.
- Unsupported functionality is explicitly excluded or waived.
- Code coverage is reported only when a final, reproducible coverage database with a valid report exists.

## 2. In-scope behavior

The current functional coverage model in [tb/env/coverage/bmu_coverage.sv](../../tb/env/coverage/bmu_coverage.sv) covers the following supported classes:

- OR / XOR / ZBB mode behavior
- SRL / SRA / ROR shift operations
- BINV bit-position sweeps
- CTZ / CPOP counts
- SLT / MAX / SUB co-requisite checks
- PACK and GREV valid encoding coverage
- CSR read/write and bypass behavior
- Reset / valid / invalid / idle states
- Operation × error and operation × valid crosses

## 3. Explicit exclusions and waivers

The following are excluded from the in-scope functional coverage and must remain outside the final closure claim unless written behavior is added to the specification:

- Section 8 fields not implemented in `bmu_ctrl_t`: `min`, `clz`, `rol`, `bset`, `bclr`, `packu`, `packh`, `gorc`
- DFT-only `scan_mode` behavior is not counted as normal operation coverage; it is retained as a behavioral assumption check only
- Unsupported or unconfirmed GREV behaviors outside the adopted `b_in[4:0] == 24` valid encoding rule remain assumption-tagged
- Any CSR behavior beyond the adopted project interpretation remains tracked in the clarification log and not counted as a closed design requirement

## 4. Current measured coverage

These values are based on the latest Xcelium reports currently checked into the repo:

| Run | Functional coverage |
|---|---:|
| `bmu_or_valid_test` | 19.07% |
| `bmu_timing_reset_test` | 31.69% |
| `bmu_gap_checks_test` | 63.32% |
| `bmu_legal_random_test` | 66.39% |
| `bmu_corner_random_test` | 57.24% |
| `bmu_error_random_test` | 47.57% |

These numbers are not a final sign-off result. They are the current measured baseline and reflect the fact that the DUT still has open runtime findings.

## 5. Code coverage status

The repository contains coverage databases under [results/coverage](../../results/coverage), but there is no final code-coverage report that can honestly be presented as a sign-off result.

The correct status is:

- functional coverage: measured, not complete
- code coverage: not yet closed; no final pass/fail statement exists

## 6. Closure rule

A coverage item is closed only when all of the following are true:

1. It is in the supported legal scope.
2. The corresponding test is executable and reproducible.
3. The DUT behavior matches the specification under the current reference model.
4. There is no open bug or accepted-risk note contradicting the expected result.
5. The item is included in the final sign-off report with its observed coverage or waiver status.

This project is therefore in a professional pre-closure state, not a final sign-off state.
