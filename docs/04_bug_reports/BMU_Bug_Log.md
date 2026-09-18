# BMU Bug Log

## 1. Purpose and rules

This log records specification-based DUT risks for BMU Specification v1.2.
Expected behavior comes from the specification and independent reference
model. RTL inspection identifies candidates; it does not close a bug. The
verification environment must reproduce a candidate before it is reported as
runtime-confirmed.

The verification team must not patch the delivered RTL locally to close a
finding. Every confirmed finding needs a failing test, scoreboard evidence,
the RTL revision, and a retest result after the design fix.

Status meanings:

- `Open - static finding`: implementation evidence exists; simulation is still
  required.
- `Open - runtime confirmed`: the scoreboard reproduced the specification
  mismatch on the delivered DUT.
- `Withdrawn`: the original claim is not supported by the current RTL or was a
  documentation error; the associated test remains required when applicable.
- `Accepted`: written design/specification approval accepts the behavior.
- `Fixed`: a new DUT revision passes the reproducer and relevant regression.

Severity meanings:

- `Critical`: blocks sign-off or permits broad invalid behavior.
- `Major`: incorrect result or error behavior under a plausible condition.
- `Minor`: limited impact or low-risk boundary issue.

## 2. Summary

| ID | Severity | Area | Reproducer | Status |
|---|---|---|---|---|
| `BMU-BUG-001` | Major | CPOP width | `TC_CPOP_004` | Open - static finding |
| `BMU-BUG-002` | Major | PACK ordering | `TC_PACK_001` | Open - static finding |
| `BMU-BUG-003` | Major | CSR write source | `TC_CSR_002`, `TC_CSR_003` | Open - static finding |
| `BMU-BUG-004` | N/A | CSR bypass documentation | `TC_CSR_001` | Withdrawn; runtime check pending |
| `BMU-BUG-005` | Major | GREV byte ordering | `TC_GREV_001` | Open - static finding |
| `BMU-BUG-006` | Critical | Invalid/conflicting controls | `TC_GUARD_001` through `TC_GUARD_004` | Open - static finding |
| `BMU-BUG-007` | Major | SLT/MAX co-requisites | `TC_SLT_005`, `TC_MAX_005` | Open - static finding |
| `BMU-BUG-008` | Major | GREV undefined encoding | `TC_GREV_002` | Open - static finding; assumption-tagged |
| `BMU-BUG-009` | Major | CTZ bit reversal | `TC_CTZ_005` | Open - static finding |

No finding is runtime-confirmed in this repository snapshot. The lack of
runtime status is a verification-readiness gap, not evidence that the DUT is
correct.

## 3. Detailed findings

### BMU-BUG-001: CPOP ignores bits 16 through 31

- **Specification expectation:** CPOP counts set bits in the complete 32-bit
  `a_in` operand.
- **RTL evidence:** The population-count loop iterates only while its index is
  less than 16.
- **Reproducer:** `ap.cpop=1`, `a_in=0xFFFF0000`.
- **Expected:** `result=32`, `error=0`.
- **Likely DUT result:** `result=0`, `error=0`.
- **Impact:** All CPOP results dependent on upper-half bits can be wrong.
- **Required evidence:** Run `TC_CPOP_004` with high-half-only, low-half-only,
  all-zero, all-one, and mixed patterns.

### BMU-BUG-002: PACK concatenates operands in the opposite order

- **Specification expectation:** `result={b_in[15:0],a_in[15:0]}`.
- **RTL evidence:** The current expression is `{a_in[15:0],b_in[15:0]}`.
- **Reproducer:** `ap.pack=1`, `a_in=0x00001234`, `b_in=0x00005678`.
- **Expected:** `0x56781234`, `error=0`.
- **Likely DUT result:** `0x12345678`, `error=0`.
- **Impact:** Non-symmetric PACK operands are reversed at the half-word level.
- **Required evidence:** Run `TC_PACK_001` and retain the exact monitor and
  scoreboard values.

### BMU-BUG-003: CSR write source selection is reversed

- **Specification expectation:** `ap.csr_imm=1` selects `b_in`; zero selects
  `a_in`.
- **RTL evidence:** The current `csr_write_data` assignment selects `a_in` when
  `ap.csr_imm=1` and `b_in` otherwise.
- **Reproducer:** `ap.csr_write=1`, `ap.csr_imm=1`, `a_in=0x33334444`,
  `b_in=0x11112222`.
- **Expected:** `0x11112222`, `error=0`.
- **Likely DUT result:** `0x33334444`, `error=0`.
- **Impact:** Both CSR write forms can select the wrong source.
- **Required evidence:** Run immediate and register-source cases independently.

### BMU-BUG-004: CSR bypass finding withdrawn pending runtime check

- **Original claim:** Pure CSR bypass read did not drive `csr_rddata_in`.
- **Current evidence:** The RTL `lout` expression explicitly includes
  `csr_ren_in & csr_rddata_in`.
- **Disposition:** Withdraw the static defect claim. `TC_CSR_001` remains
  mandatory because a wide OR datapath and error gating still require runtime
  confirmation.
- **Do not report as:** An open Critical bug unless the current RTL fails the
  pure bypass scoreboard check.

### BMU-BUG-005: GREV byte-reverse ordering is incorrect

- **Specification expectation:** For `b_in[4:0]=24`, reverse the four bytes:
  `{a_in[7:0],a_in[15:8],a_in[23:16],a_in[31:24]}`.
- **RTL evidence:** The current expression is
  `{a_in[15:8],a_in[7:0],a_in[31:24],a_in[23:16]}`.
- **Reproducer:** `ap.grev=1`, `a_in=0x12345678`, `b_in[4:0]=24`.
- **Expected:** `0x78563412`, `error=0`.
- **Likely DUT result:** `0x34127856`, `error=0`.
- **Impact:** The supported GREV permutation does not match the specification.

### BMU-BUG-006: Invalid and conflicting controls are not generally rejected

- **Specification expectation:** Invalid control combinations force
  `result=0`, `error=1`.
- **RTL evidence:** The current error equation covers selected CSR, Zba, and
  SUB conditions but does not generally reject multiple primary fields, empty
  requests, or stray mode fields.
- **Reproducers:** Empty request; `ap.zbb=1` without OR/XOR; `ap.zba=1`
  without a valid operation; and multiple primary enables.
- **Expected:** `result=0`, `error=1` for every invalid row.
- **Impact:** Upstream decode errors can be silently accepted or produce a
  partial result.
- **Required evidence:** Execute the full guard matrix and split the finding
  into separate reports if different root causes appear.

### BMU-BUG-007: SLT and MAX do not enforce SUB co-requisites

- **Specification expectation:** SLT and MAX require `ap.sub=1`.
- **RTL evidence:** The comparison and min/max datapaths are selected without
  an error condition requiring SUB.
- **Reproducers:** `ap.slt=1, ap.sub=0, a_in=0xFFFFFFFF, b_in=1`; and
  `ap.max=1, ap.sub=0, a_in=10, b_in=20`.
- **Expected:** `result=0`, `error=1` for both.
- **Likely DUT result:** A comparison/min-max result with `error=0`.

### BMU-BUG-008: GREV undefined encoding does not assert error

- **Specification expectation under the safe adopted assumption:**
  `ap.grev=1` with `b_in[4:0] != 24` produces `result=0`, `error=1`.
- **RTL evidence:** The datapath disables the byte-reverse term for another
  encoding, but the error equation does not reject the request.
- **Reproducer:** `ap.grev=1`, `a_in=0x12345678`, `b_in[4:0]=5`.
- **Expected:** `0`, `error=1`.
- **Status condition:** Keep assumption-tagged until `CLARIF-004` is resolved.

### BMU-BUG-009: CTZ reverses adjacent bits instead of the complete operand

- **Specification expectation:** CTZ returns the number of trailing zero bits
  in the complete 32-bit operand. A one-hot bit at position `n` returns `n`.
- **RTL evidence:** The CTZ preprocessing mapping swaps adjacent pairs only;
  it does not reverse all 32 bits before the leading-zero encoder.
- **Reproducer:** `ap.ctz=1`, `a_in=1 << n`, for every `n` from 0 through 31.
- **Expected:** `result=n`, `error=0`; retain `CTZ(0)=32`.
- **Likely DUT result:** At least adjacent-bit positions produce incorrect
  counts; `a_in=0x00000001` is an immediate discriminating case.
- **Impact:** CTZ is broadly incorrect for nonzero operands.

## 4. Required confirmation record

For every candidate or confirmed bug, record:

1. Test ID, sequence/class, simulator, seed, and RTL commit.
2. Complete input transaction and active control fields.
3. Specification reference and independent expected values.
4. Actual `result_ff` and `error`, including observation cycle.
5. Scoreboard message and log path.
6. Waveform path around the active clock edge.
7. Severity, owner, status, and design disposition.
8. Fixed-revision retest result and regression impact.

An assumption-dependent mismatch must not be closed by changing the expected
value locally. Resolve the clarification, then update the reference model,
test plan, coverage bins, and bug status as one change set.