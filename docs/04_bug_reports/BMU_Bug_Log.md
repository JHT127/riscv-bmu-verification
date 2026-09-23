# BMU Bug Log

## 1. Baseline and evidence

All active findings below were reproduced on the original delivered DUT with Xcelium 25.03-s006, effective seed 1, on 22 September 2026. [run_manifest.json](../../results/reports/run_manifest.json) records source/configuration and log hashes. No delivered RTL behavior was changed.

Each `bmu_bug_NNN_test` resets the DUT, then drives one isolated reproducer (two transactions for BUG-003 and BUG-007). Unless stated otherwise: `rst_l=1`, `valid_in=1`, `scan_mode=0`, `csr_ren_in=0`, `csr_rddata_in=0`, and every unlisted control/operand is zero. The first failing capture is at 15 ns; a second transaction is at 25 ns.

Expected values come from BMU Specification v1.2. The predictor passes 865 separate self-checks. Evidence extracts retain complete controls, operands, expected/actual result and error, timestamps, effective seed, and source-log hash. Full logs can be regenerated with the command in each extract.

## 2. Summary

| ID | Severity | Area | Reproducer | Status |
|---|---|---|---|---|
| BMU-BUG-001 | Major | CPOP ignores the upper operand half | `bmu_bug_001_test` | Open — runtime confirmed |
| BMU-BUG-002 | Major | PACK reverses the halfword order | `bmu_bug_002_test` | Open — runtime confirmed |
| BMU-BUG-003 | Major | CSR write selects the wrong source | `bmu_bug_003_test` | Open — runtime confirmed |
| BMU-BUG-005 | Major | GREV byte ordering is incorrect | `bmu_bug_005_test` | Open — runtime confirmed |
| BMU-BUG-006 | Critical | Invalid controls are accepted | `bmu_bug_006_test` | Open — runtime confirmed |
| BMU-BUG-007 | Major | SLT/MAX do not enforce the SUB co-requisite | `bmu_bug_007_test` | Open — runtime confirmed |
| BMU-BUG-008 | Major | Undefined GREV encoding does not assert error | `bmu_bug_008_test` | Open — runtime confirmed; assumption-tagged |
| BMU-BUG-009 | Major | CTZ bit reversal produces the wrong count | `bmu_bug_009_test` | Open — runtime confirmed |
| BMU-BUG-010 | Major | MAX selects the smaller operand | `bmu_bug_010_test` | Open — runtime confirmed |

BMU-BUG-004, the earlier CSR-bypass claim, remains withdrawn; the legal bypass check passes. The ID is not reused. Design fixes and design-owner dispositions are pending for all active findings.

## 3. Detailed findings

### BMU-BUG-001: CPOP ignores the upper operand half

- **Specification:** v1.2 section 6.5.2.
- **Stimulus:** `cpop=1`, `a=0xFFFF0000`.
- **Expected result, error:** `16`, `0`.
- **Observed result, error:** `0`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-001.txt).
- **Impact and retest:** The population-count loop stops at bit 15. Upper-half set bits do not contribute. Retest zero, all ones, both halves, and count/position sweeps.

### BMU-BUG-002: PACK reverses the halfword order

- **Specification:** v1.2 section 6.8.1.
- **Stimulus:** `pack=1`, `a=0x00001234`, `b=0x00005678`.
- **Expected result, error:** `0x56781234`, `0`.
- **Observed result, error:** `0x12345678`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-002.txt).
- **Impact and retest:** The RTL concatenates A before B. The specification requires `{b[15:0], a[15:0]}`. Retest distinct, equal, zero, and discarded-upper-half patterns.

### BMU-BUG-003: CSR write selects the wrong source

- **Specification:** v1.2 section 6.9.2.
- **Stimulus:** `csr_write=1`, `a=0x33334444`, `b=0x11112222`; immediate then register mode.
- **Expected result, error:** Immediate: `0x11112222`, `0`; register: `0x33334444`, `0`.
- **Observed result, error:** Immediate: `0x33334444`, `0`; register: `0x11112222`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-003.txt).
- **Impact and retest:** The source mux is reversed. Immediate mode must select B; register mode must select A. Retest both modes with distinct nonzero data and CSR conflicts.

### BMU-BUG-005: GREV byte ordering is incorrect

- **Specification:** v1.2 section 6.8.2.
- **Stimulus:** `grev=1`, `a=0x12345678`, `b=24`.
- **Expected result, error:** `0x78563412`, `0`.
- **Observed result, error:** `0x56781234`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-005.txt).
- **Impact and retest:** The RTL swaps halfwords instead of reversing all four bytes. Retest distinct bytes and variation in ignored upper amount bits.

### BMU-BUG-006: Invalid controls are accepted

- **Specification:** v1.2 section 4–5.
- **Stimulus:** Empty control packet, `ap=0`, `csr_ren=0`.
- **Expected result, error:** `0`, `1`.
- **Observed result, error:** `0`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-006.txt).
- **Impact and retest:** The error logic does not enforce the complete operation guards. The guard-matrix suite additionally exercises each forbidden field with valid high and low. Retest the complete matrix and result hold during idle failures.

### BMU-BUG-007: SLT/MAX do not enforce the SUB co-requisite

- **Specification:** v1.2 section 6.4.2 / 6.7.1.
- **Stimulus:** SLT: `slt=1`, `sub=0`, `a=0xFFFFFFFF`, `b=1`; MAX: `max=1`, `sub=0`, `a=10`, `b=20`.
- **Expected result, error:** Both: `0`, `1`.
- **Observed result, error:** SLT: `0`, `0`; MAX: `20`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-007.txt).
- **Impact and retest:** The missing-SUB guard is absent. These requests are invalid even when a numerical result looks plausible. Retest each missing co-requisite and legal SLT/MAX controls separately.

### BMU-BUG-008: Undefined GREV encoding does not assert error

- **Specification:** v1.2 section 6.8.2 / 7.1.
- **Stimulus:** `grev=1`, `a=0x12345678`, `b=5`.
- **Expected result, error:** `0`, `1`.
- **Observed result, error:** `0`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-008.txt).
- **Impact and retest:** Assumption-tagged under CLARIF-004: the adopted contract rejects every non-24 low-five-bit encoding. The datapath returns zero but does not signal the invalid encoding. Retest all 31 rejected encodings.

### BMU-BUG-009: CTZ bit reversal produces the wrong count

- **Specification:** v1.2 section 6.5.1.
- **Stimulus:** `ctz=1`, `a=1`.
- **Expected result, error:** `0`, `0`.
- **Observed result, error:** `1`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-009.txt).
- **Impact and retest:** The reversed operand used for CTZ is not a correct full-width bit reversal. The one-hot sweep exposes further positions. Retest all 32 positions, zero (expected 32), and multi-bit patterns.

### BMU-BUG-010: MAX selects the smaller operand

- **Specification:** v1.2 section 6.7.1.
- **Stimulus:** `max=1`, `sub=1`, `a=10`, `b=20`.
- **Expected result, error:** `20`, `0`.
- **Observed result, error:** `10`, `0`.
- **Evidence:** [isolated runtime extract](../../results/bugs/BMU-BUG-010.txt).
- **Impact and retest:** The operand selector `ge ^ ap_max` reverses the signed MAX choice. This legal-data defect is separate from BUG-007. Retest swapped/equal operands, both sign combinations, and signed extrema.

## 4. Reproduce and close

```bash
make -C sim regression CONFIG=../regression/configs/bugs.cfg
# Example: reproduce the legal MAX failure
make -C sim run TEST=bmu_bug_010_test SEED=1
```

Every active reproducer returns failure on the original DUT. A finding closes only after a supplied revised DUT passes its reproducer and related regression, or a written specification disposition explicitly accepts the behavior. Coverage completion does not close any of these bugs. Assumption changes must update the clarification log, predictor, tests, and evidence together.
