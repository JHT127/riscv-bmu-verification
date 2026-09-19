# BMU Coverage Waivers and Exclusions

## 1. Scope

This document records the exact scope of the BMU coverage model and the exclusion rules for unsupported or untestable behavior.

The goal is to make the bug-finding coverage claim honest:

- Functional coverage is measured only over the supported legal behavior domain.
- Unsupported functionality is explicitly excluded or waived.
- Code coverage is reported from a reproducible merged Xcelium database; it is not treated as closed merely because a percentage exists.

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

The dedicated `bmu_coverage_closure_test`, seed 4, reaches 100.00% functional coverage with zero uncovered covergroup bins reported by IMC. Its 62 UVM errors remain separate DUT bug evidence.

## 5. Code coverage status

The distinct Xcelium runs are merged in `results/coverage/overall_code_coverage`.
The measured aggregate code coverage is 17.74% (2,587/14,581), with a
23.54% type-hierarchy view. Assertion status is 53.85%; FSM coverage is not
applicable because no FSMs were extracted. These are measurement results, not
RTL sign-off criteria.

The strongest no-RTL-edit coverage run is `bmu_coverage_max_test`. In a fresh
run, the simulator reported `functional coverage=67.00% samples=65`, which is
currently the best measured code-coverage ceiling in the fixed-DUT repository.

This is not an artificial ceiling; it is a consequence of the delivered RTL
structure:

- optional feature blocks are disabled by configuration (`BITMANIP_ZBP = 0`,
  `BITMANIP_ZBE = 0`, `BITMANIP_ZBF = 0`),
- large sections of the RTL branch on those disabled configuration bits and are
  therefore unreachable without editing the RTL or the enable parameters,
- the merged hierarchy includes additional pipeline logic outside the training BMU
  scope,
- and the project is intentionally not a release-quality verification package.

The correct status is:

- functional coverage: 100.00% for the declared in-scope model
- code coverage: measured baseline and bounded by the fixed RTL ceiling
- maximum observed no-RTL-edit code coverage: 67.00%

## 6. Closure rule

A coverage item is closed only when all of the following are true:

1. It is in the supported legal scope.
2. The corresponding test is executable and reproducible.
3. The DUT behavior matches the specification under the current reference model.
4. Any DUT mismatch remains visible as a bug; it does not invalidate stimulus coverage.
5. The item is included in the coverage report with its observed coverage or waiver status.

This project has functional coverage closure for the declared model, while remaining unsuitable for RTL sign-off because open DUT findings remain.
