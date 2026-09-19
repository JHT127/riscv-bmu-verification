# BMU DUT Bug Review

## 1. Purpose

This document records defects found by reviewing the delivered DUT against BMU
Specification v1.2. The specification defines expected behavior. The RTL is
only the implementation under review.

The findings below originated as static review findings and are now updated
with the runtime evidence from the bound UVM environment. They must not be
closed based only on code inspection. Each finding has a reproducer and an
expected result from the specification.

## 2. Disposition Rules

- `Open - static finding`: implementation evidence exists; runtime reproduction
  is still required.
- `Open - runtime confirmed`: scoreboard mismatch reproduced in simulation.
- `Accepted`: design behavior is intentionally different and has written
  approval or a specification update.
- `Fixed`: a new DUT revision is supplied and the regression passes.

The verification team must not patch the delivered RTL locally to close a bug.

## 3. Findings Summary

| ID | Severity | Area | Status |
|---|---|---|---|
| `BMU-BUG-001` | Major | CPOP width | Open - runtime confirmed |
| `BMU-BUG-002` | Major | PACK ordering | Open - runtime confirmed |
| `BMU-BUG-003` | Major | CSR write source | Open - runtime confirmed |
| `BMU-BUG-005` | Major | GREV byte ordering | Open - runtime confirmed |
| `BMU-BUG-006` | Critical | Invalid and conflicting controls | Open - runtime confirmed |
| `BMU-BUG-007` | Major | SLT/MAX co-requisites | Open - runtime confirmed |
| `BMU-BUG-008` | Major | GREV undefined encoding error | Open - runtime confirmed; assumption-tagged |
| `BMU-BUG-009` | Major | CTZ bit reversal | Open - runtime confirmed |

## 4. Detailed Findings

### BMU-BUG-001 — CPOP ignores operand bits 16 through 31

**Severity:** Major

**Status:** Open - runtime confirmed

**Specification expectation:** Specification v1.2 Section 6.5.2 defines CPOP
as the number of set bits in the complete 32-bit `a_in` operand.

**RTL evidence:** The delivered RTL loop iterates while
`bitmanip_cpop_i < 16`, so only `a_in[15:0]` contributes to the result.

**Reproducer:** `TC_CPOP_004`, high-half-only pattern:

```text
ap.cpop=1
 a_in=0xFFFF0000
```

**Expected result:** `32`, `error=0`.

**Likely DUT result:** `0`, `error=0`.

**Impact:** Any CPOP value depending on the upper half of the operand is
incorrect. Existing mixed patterns may miss this if their low half happens to
produce the expected total by coincidence.

**Disposition:** Run the high-half and low-half tests; file against the DUT
revision if reproduced.

### BMU-BUG-002 — PACK concatenates operands in the opposite order

**Severity:** Major

**Status:** Open - runtime confirmed

**Specification expectation:** Specification v1.2 Section 6.8.1 defines:
`result = {b_in[15:0], a_in[15:0]}`.

**RTL evidence:** The delivered RTL expression is
`{a_in[15:0], b_in[15:0]}`.

**Reproducer:** `TC_PACK_001`:

```text
ap.pack=1
a_in=0x00001234
b_in=0x00005678
```

**Expected result:** `0x56781234`, `error=0`.

**Likely DUT result:** `0x12345678`, `error=0`.

**Impact:** Every non-symmetric PACK input is reversed at the half-word level.

**Disposition:** Existing directed test should reproduce this immediately.

### BMU-BUG-003 — CSR write immediate/register source selection is reversed

**Severity:** Major

**Status:** Open - runtime confirmed

**Specification expectation:** Specification v1.2 Section 6.9.2 defines:

- `ap.csr_imm=1`: result is `b_in`.
- `ap.csr_imm=0`: result is `a_in`.

**RTL evidence:** The delivered RTL assigns `a_in` when `ap.csr_imm=1` and
`b_in` otherwise.

**Reproducer:**

```text
ap.csr_write=1
ap.csr_imm=1
a_in=0x33334444
b_in=0x11112222
```

**Expected result:** `0x11112222`, `error=0`.

**Likely DUT result:** `0x33334444`, `error=0`.

**Impact:** Both CSR write forms select the wrong source field.

**Disposition:** `TC_CSR_002` and `TC_CSR_003` must run independently so both
forms are covered.

### DV false lead not retained in the final bug list

This item was an internal verification mistake, not a DUT defect, and it is not
kept as a project bug record.

**Original claim:** Pure CSR bypass read is a defect.

**Why it is not retained:** The received RTL explicitly includes the CSR bypass
path and the runtime check passed under the project's accepted interpretation.
This was a misclassification in the early review stage, not a specification
violation in the DUT.

**Disposition:** No permanent issue is filed for this item. It remains only as a
lesson for future DV reviews: do not treat a model assumption or a stale static
claim as a DUT bug before the pure bypass case is reproduced and checked against
spec.

### BMU-BUG-005 — GREV byte-reverse result ordering is incorrect

**Severity:** Major

**Status:** Open - runtime confirmed

**Specification expectation:** For the supported GREV encoding
`b_in[4:0]=24`, Specification v1.2 requires full byte reversal:
`{a_in[7:0], a_in[15:8], a_in[23:16], a_in[31:24]}`.

**RTL evidence:** The delivered RTL constructs
`{a_in[15:8], a_in[7:0], a_in[31:24], a_in[23:16]}`.

**Reproducer:** `TC_GREV_001`:

```text
ap.grev=1
a_in=0x12345678
b_in[4:0]=24
```

**Expected result:** `0x78563412`, `error=0`.

**Likely DUT result:** `0x34127856`, `error=0`.

**Impact:** The implemented permutation is not the specified byte reversal.

**Disposition:** Run the existing GREV valid sequence and retain the exact
waveform/result pair in the report.

### BMU-BUG-006 — Generic invalid/conflicting control combinations are not rejected

**Severity:** Critical

**Status:** Open - runtime confirmed

**Specification expectation:** Specification v1.2 Sections 4 and 5 require
invalid combinations to force `result=0` and `error=1`. This includes multiple
primary operation fields, invalid guard combinations, and unsupported empty
requests.

**RTL evidence:** The delivered `error` expression checks CSR plus operation,
missing Zba mode for SHxADD, and SUB plus Zba. It does not generally check
multiple primary fields, stray mode fields, or an empty operation selection.

**Reproducers:**

```text
ap.lor=1; ap.lxor=1
ap=0
ap.zbb=1 with ap.lor=0 and ap.lxor=0
```

Use `TC_OR_003`, `TC_GUARD_001`, and `TC_GUARD_002` from the reviewed plan.

**Expected result:** `result=0`, `error=1` for each invalid request.

**Likely DUT result:** `error=0` in combinations not covered by the three
explicit RTL error terms.

**Impact:** Illegal decode combinations can silently produce zero or a partial
operation result, masking upstream decode errors.

**Disposition:** Execute a systematic invalid-control matrix. Split this bug
into narrower DUT reports if the matrix shows different root causes.

### BMU-BUG-007 — SLT and MAX do not enforce the required SUB co-requisite

**Severity:** Major

**Status:** Open - runtime confirmed

**Specification expectation:** Specification v1.2 Sections 6.4.2 and 6.7.1
require `ap.sub=1` together with `ap.slt=1` or `ap.max=1`.

**RTL evidence:** The delivered datapath selects `slt_one` from `ap.slt` and
selects min/max from `ap.max` without an error term requiring `ap.sub`.

**Reproducers:**

```text
ap.slt=1; ap.sub=0
a_in=0xFFFFFFFF; b_in=1

ap.max=1; ap.sub=0
a_in=10; b_in=20
```

**Expected result:** `result=0`, `error=1`.

**Likely DUT result:** A comparison result with `error=0`.

**Impact:** Shared-datapath control protocol violations are accepted as valid
operations.

**Disposition:** Add and run `TC_SLT_005` and `TC_MAX_005`.

### BMU-BUG-008 — GREV undefined encoding does not assert error

**Severity:** Major

**Status:** Open - runtime confirmed; assumption-tagged

**Specification expectation:** Under the adopted Specification v1.2 Section
7.1 assumption, `ap.grev=1` with `b_in[4:0] != 24` must produce `result=0`,
`error=1`.

**RTL evidence:** The delivered RTL gates its byte-reverse enable with the
encoding comparison, but the error expression does not assert an error for a
GREV request with another encoding.

**Reproducer:** `TC_GREV_002`:

```text
ap.grev=1
a_in=0x12345678
b_in[4:0]=5
```

**Expected result:** `0`, `error=1` under the adopted safe assumption.

**Likely DUT result:** `0`, `error=0`.

**Impact:** An unsupported permutation encoding is silently accepted.

**Disposition:** Keep this test assumption-tagged. If the design owner later
changes the behavior, update the spec, reference model, and test plan together.

### BMU-BUG-009 — CTZ input reversal swaps adjacent bits only

**Severity:** Major

**Status:** Open - runtime confirmed

**Specification expectation:** Specification v1.2 Section 6.5.1 defines CTZ
as the number of consecutive zero bits starting at bit 0 of the complete
32-bit operand. A one-hot input at bit `n` must return `n`; CTZ(0) must return
32.

**RTL evidence:** The CTZ path uses `bitmanip_a_reverse_ff`, but that mapping
only swaps each adjacent pair (`a[1]` with `a[0]`, `a[3]` with `a[2]`, and so
on). It does not reverse the complete 32-bit operand before the leading-zero
encoder.

**Reproducer:** `TC_CTZ_005`, one-hot sweep:

```text
ap.ctz=1
a_in=1 << n, for n = 0 through 31
```

**Expected result:** `n`, `error=0` for every one-hot input. The existing
`TC_CTZ_001` zero case must also remain `32`, `error=0`.

**Likely DUT result:** Adjacent-bit positions are transformed incorrectly;
for example, `a_in=0x00000001` is not presented to the encoder as a bit at the
required reversed position, so the result is not 0.

**Impact:** CTZ results are incorrect for normal nonzero operands, not merely
for an unsupported corner. This can affect every instruction using the count
result.

**Disposition:** Run the one-hot sweep against the reference model. File
against the DUT revision if any position mismatches.

## 5. Additional Review Risks

These are not filed as DUT bugs yet because they require either runtime
reproduction or scope clarification:

- The delivered RTL contains active fields outside Specification v1.2 Section
  8. They are forced low by the verification adapter and are not verified.
- The delivered RTL has a physical control struct different from the
  specification-facing `bmu_ctrl_t`; the adapter must remain explicit.
- The DUT emits compile warnings for its inline parameter include syntax. This
  is a packaging/style warning, not currently a behavioral bug.
- The adopted GREV and CSR assumptions remain risks until formally confirmed.

## 6. Expert Bug-Document Pattern

A professional bug document normally contains the following fields:

1. Title and unique ID.
2. Severity and status.
3. Short summary of the defect.
4. Exact specification reference.
5. Reproducer setup and input values.
6. Expected result.
7. Actual result and log evidence.
8. Root cause or affected RTL block.
9. Impact on functionality or safety.
10. Traceability to the test, log, and scoreboards.
11. Owner and disposition.

This keeps the record credible and reviewable. The repo should not keep stale
internal mistakes as bug entries unless they are needed as lessons for the
verification team.

## 7. Required Bug Evidence

For every runtime-confirmed bug, attach:

1. Test ID and sequence name.
2. Input transaction and active control fields.
3. Specification section and expected values.
4. Actual monitor values.
5. Scoreboard message.
6. Waveform around the active clock edge.
7. RTL revision/commit.
8. Severity, owner, status, and retest result.
