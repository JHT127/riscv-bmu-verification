# BMU Bug Log

## 1. Purpose and rules

This log records specification-based DUT risks for BMU Specification v1.2.
Expected behavior comes from the specification and the independent reference
model. RTL inspection identifies candidates; it does not close a bug. The
verification environment must reproduce a candidate before it is reported as
runtime-confirmed.

The verification team must not patch the delivered RTL locally to close a
finding. Every confirmed finding requires a failing reproducer, scoreboard
evidence, the RTL revision, and a retest result after the design fix.

## 2. Status and severity rules

Status meanings:

- `Open - static finding`: implementation evidence exists; runtime reproduction is still required.
- `Open - runtime confirmed`: the scoreboard reproduced a specification mismatch on the delivered DUT.
- `Withdrawn`: the original claim is not supported by the current RTL or was a documentation error.
- `Accepted`: written design/specification approval accepts the behavior.
- `Accepted project risk`: the design team is unavailable; the behavior is frozen under the safest documented interpretation and recorded as residual risk.
- `Fixed`: a new DUT revision passes the reproducer and relevant regression.

Severity meanings:

- `Critical`: blocks sign-off or permits broad invalid behavior.
- `Major`: incorrect result or error behavior under plausible conditions.
- `Minor`: limited impact or low-risk boundary condition.

## 3. Summary

| ID | Severity | Area | Reproducer | Status |
|---|---|---|---|---|
| `BMU-BUG-001` | Major | CPOP width | `TC_CPOP_004` | Open - runtime confirmed |
| `BMU-BUG-002` | Major | PACK ordering | `TC_PACK_001` | Open - runtime confirmed |
| `BMU-BUG-003` | Major | CSR write source | `TC_CSR_002`, `TC_CSR_003` | Open - runtime confirmed |
| `BMU-BUG-004` | N/A | CSR bypass documentation | `TC_CSR_001` | Withdrawn; runtime check passed |
| `BMU-BUG-005` | Major | GREV byte ordering | `TC_GREV_001` | Open - runtime confirmed |
| `BMU-BUG-006` | Critical | Invalid/conflicting controls | `TC_GUARD_001` through `TC_GUARD_004` | Open - runtime confirmed |
| `BMU-BUG-007` | Major | SLT/MAX co-requisites | `TC_SLT_005`, `TC_MAX_005` | Open - runtime confirmed |
| `BMU-BUG-008` | Major | GREV undefined encoding | `TC_GREV_002` | Open - runtime confirmed; assumption-tagged |
| `BMU-BUG-009` | Major | CTZ bit reversal | `TC_CTZ_005` | Open - runtime confirmed |

## 4. Current runtime evidence

The current repository state confirms the following runtime evidence on Xcelium `25.03-s006`:

| Run | Seed | Result | Evidence |
|---|---:|---|---|
| `bmu_gap_checks_test` | 1 | 131 matches, 41 mismatches, 0 fatals | `results/logs/bmu_gap_checks_test_1.log` |
| `bmu_nominal_directed_test` | 1 | 7 mismatches, 0 fatals | `results/logs/bmu_nominal_directed_test_1.log` |
| `bmu_error_directed_test` | 1 | 7 mismatches, 0 fatals | `results/logs/bmu_error_directed_test_1.log` |
| `bmu_legal_random_test` | 101 | 45 mismatches, 0 fatals | `results/logs/bmu_legal_random_test_101.log` |
| `bmu_corner_random_test` | 201 | 18 mismatches, 0 fatals | `results/logs/bmu_corner_random_test_201.log` |
| `bmu_error_random_test` | 301 | 84 mismatches, 0 fatals | `results/logs/bmu_error_random_test_301.log` |

These results are evidence of open DUT defects, not proof of correct RTL behavior. The failing logs must be retained and associated with the corresponding bug records until the RTL is fixed or formally accepted.

## 5. Detailed findings

### BMU-BUG-001: CPOP ignores bits 16 through 31

- **Specification expectation:** CPOP counts set bits in the complete 32-bit `a_in` operand.
- **RTL evidence:** The population-count loop only iterates across the lower half of the operand.
- **Reproducer:** `ap.cpop=1`, `a_in=0xFFFF0000`.
- **Expected:** `result=32`, `error=0`.
- **Likely DUT result:** `result=0`, `error=0`.
- **Impact:** Upper-half population count is incorrect.

### BMU-BUG-002: PACK concatenates operands in the wrong order

- **Specification expectation:** `result={b_in[15:0],a_in[15:0]}`.
- **RTL evidence:** The current implementation returns the reversed half-word ordering.
- **Reproducer:** `ap.pack=1`, `a_in=0x00001234`, `b_in=0x00005678`.
- **Expected:** `0x56781234`, `error=0`.
- **Likely DUT result:** `0x12345678`, `error=0`.
- **Impact:** Data ordering is wrong for non-symmetric PACK operands.

### BMU-BUG-003: CSR write source selection is reversed

- **Specification expectation:** `ap.csr_imm=1` selects `b_in`; otherwise it selects `a_in`.
- **RTL evidence:** The source-selection logic is inverted.
- **Reproducer:** `ap.csr_write=1`, `ap.csr_imm=1`, `a_in=0x33334444`, `b_in=0x11112222`.
- **Expected:** `0x11112222`, `error=0`.
- **Likely DUT result:** `0x33334444`, `error=0`.
- **Impact:** CSR write selects the wrong source.

### BMU-BUG-004: CSR bypass claim withdrawn

- **Claim:** Pure CSR bypass read did not drive `csr_rddata_in`.
- **Current evidence:** The RTL datapath includes the CSR bypass path and the runtime check passed.
- **Disposition:** Withdrawn. `TC_CSR_001` remains required as a runtime confirmation check, but it is not an active DUT defect.

### BMU-BUG-005: GREV byte-reverse ordering is incorrect

- **Specification expectation:** For `b_in[4:0]=24`, reverse the four bytes in the documented byte order.
- **RTL evidence:** The current implementation reorders the bytes incorrectly.
- **Reproducer:** `ap.grev=1`, `a_in=0x12345678`, `b_in[4:0]=24`.
- **Expected:** `0x78563412`, `error=0`.
- **Likely DUT result:** `0x34127856`, `error=0`.
- **Impact:** GREV does not match the specification.

### BMU-BUG-006: Invalid and conflicting controls are not rejected generally

- **Specification expectation:** Invalid control combinations force `result=0`, `error=1`.
- **RTL evidence:** The DUT accepts empty requests and stray modes without reproducing the expected invalid behavior.
- **Reproducers:** Empty request, stray `zbb`, stray `zba`, invalid CSR mode, and multiple primary controls.
- **Expected:** `result=0`, `error=1` for every invalid row.
- **Impact:** Invalid decode paths can silently pass.

### BMU-BUG-007: SLT and MAX do not enforce the SUB co-requisite

- **Specification expectation:** SLT and MAX require `ap.sub=1`.
- **RTL evidence:** The comparison and max datapaths do not assert the expected error when `sub` is absent.
- **Reproducers:** `ap.slt=1, ap.sub=0` and `ap.max=1, ap.sub=0`.
- **Expected:** `result=0`, `error=1` in both cases.
- **Likely DUT result:** Result is produced with `error=0`.

### BMU-BUG-008: GREV undefined encoding does not assert error

- **Specification expectation (adopted assumption):** `ap.grev=1` with `b_in[4:0] != 24` yields `result=0`, `error=1`.
- **RTL evidence:** The datapath does not reject the undefined encoding path.
- **Reproducer:** `ap.grev=1`, `a_in=0x12345678`, `b_in[4:0]=5`.
- **Expected:** `0`, `error=1`.
- **Status:** assumption-tagged until the clarification is formally closed.

### BMU-BUG-009: CTZ is wrong for one-hot positions

- **Specification expectation:** CTZ returns the number of trailing zero bits in the complete 32-bit operand.
- **RTL evidence:** The CTZ logic does not correctly reverse the full operand and fails one-hot positions.
- **Reproducer:** `ap.ctz=1`, `a_in=1 << n` for every `n` from 0 through 31.
- **Expected:** `result=n`, `error=0`; `CTZ(0)=32`.
- **Likely DUT result:** Adjacent bit positions are mismatched.

## 6. Required confirmation record

For every confirmed issue, the recorder must include:

1. Test ID, sequence/class name, simulator, seed, and RTL revision.
2. Complete input transaction and active control fields.
3. Independent expected value and specification reference.
4. Actual `result_ff` and `error`, including the cycle observed.
5. Scoreboard message and log path.
6. Waveform or relevant trace path.
7. Severity, owner, status, and design disposition.
8. Fixed-revision retest result and regression impact.

The project closure policy keeps unresolved clarifications as accepted project risk, not as design-team confirmation.

## 7. Closure gate

This bug log is ready for the next step only when the project has:

- a verified reproducer for every open issue,
- a written design or specification disposition, or an accepted project-risk note,
- a retest on a revised DUT revision, and
- a current status that is consistent with the final sign-off report.

At the moment, the repository is in a professional pre-closure state: the defects are documented, reproduced, and traceable, but the RTL is not yet fixed or accepted for sign-off.
