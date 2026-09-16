# BMU Spec Clarifications Log

Living record of ambiguities found while building the verification
plan/reference model, the questions raised to the design team, and how
they were resolved. Kept separate from the spec itself so it can be
shared without exposing confidential spec content.

Each entry follows: **Observation → Question Raised → Resolution →
Impact on reference model.**

> Why this document exists: a reference model built from an
> incompletely-understood spec is a silent source of verification
> escapes. Every ambiguity below was cross-checked against the spec's
> own worked examples (not just its prose tables) before being accepted
> or challenged.

---

## CLARIF-001 — Undocumented timing/reset/scan behavior

- **Observation:** Pipeline latency, register-enable behavior on
  `valid_in=0`, reset behavior, and `scan_mode` usage were not written
  anywhere in the formal spec document — only relayed informally.
- **Question raised:** Requested these be added to the spec as a
  written addendum rather than relying on informal communication.
- **Resolution:** *(update once confirmed by design team)*
- **Impact on reference model:** Reference model assumes: 1-cycle
  latency (combinational compute, registered on `valid_in`-enabled
  flop), `error` is purely combinational (not registered, not gated by
  `valid_in`), synchronous active-low reset clears both result and
  error, `scan_mode` tied off for functional sim.

## CLARIF-002 — Invalid-operation rows showing `error=0`

- **Observation:** Several per-operation behavior tables showed
  `error=0` on rows describing conflicting/invalid control-field
  combinations, contradicting the operation's own stated guard
  conditions.
- **Question raised:** Confirmed which tables were affected.
- **Resolution:** Confirmed — affected tables corrected to `error=1`
  on those rows.
- **Impact on reference model:** Reference model flags `error=1`
  whenever more than one primary operation-enable field is active
  simultaneously, for the affected operation families.

## CLARIF-003 — CTZ(0) result value

- **Observation:** Spec table stated CTZ of an all-zero input returns
  0.
- **Question raised:** Confirmed against RISC-V convention.
- **Resolution:** Confirmed — CTZ(0) = 32 (operand width), not 0.
- **Impact on reference model:** Reference model special-cases
  `a_in==0` for CTZ to return 32.

## CLARIF-004 — GREV invalid-encoding row not addressed

- **Observation:** The correction applied to CLARIF-002 was stated for
  a set of operations, but GREV's table has a differently-shaped
  invalid row (`b_in != 24`) that wasn't explicitly covered by that
  correction.
- **Question raised:** Should `b_in != 24` also force `error=1`, or is
  it intentionally a non-error "unsupported variant" case?
- **Resolution:** *(pending — see outgoing clarification email)*
- **Impact on reference model:** Currently modeled as `result=0`,
  `error=0` pending confirmation. **Flagged as a risk** — will require
  a reference-model + testcase update if resolved the other way.

## CLARIF-005 — AND vs. OR scope in CSR-conflict invalid conditions

- **Observation:** A blanket instruction to change `AND` to `OR` in
  conflict conditions, if applied globally, would contradict a worked
  example elsewhere in the spec showing `csr_ren_in=1` with no other
  control fields active as a **valid** CSR bypass read (`error=0`).
- **Question raised:** Confirmed the intended scope — is the OR logic
  local to each operation's own table (i.e., only applies when that
  operation's primary enable field is also asserted), rather than a
  global rule that `csr_ren_in=1` is always invalid?
- **Resolution:** *(pending — see outgoing clarification email)*
- **Impact on reference model:** Reference model currently treats
  `csr_ren_in=1` with all bit-manip fields deasserted as a valid
  bypass read, and `csr_ren_in=1` combined with any bit-manip enable
  field as an error — this is the interpretation that stays consistent
  with all known worked examples.

---

## Template for new entries

```markdown
## CLARIF-XXX — <short title>

- **Observation:**
- **Question raised:**
- **Resolution:**
- **Impact on reference model:**
```
