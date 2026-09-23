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
- **Resolution:** Design-team confirmation is unavailable. The project adopts
  the conservative model behavior as a closure assumption: one-cycle result
  capture, result hold when `valid_in=0`, live combinational `error`,
  synchronous active-low reset, and no functional `scan_mode` effect.
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
- **Resolution:** Design-team confirmation is unavailable. The project adopts
  the safe invalid-control interpretation: GREV with `b_in[4:0] != 24` is
  `result=0`, `error=1`. This remains an accepted project risk, not a
  design-team confirmation.
- **Impact on reference model:** Modeled as `result=0`, `error=1` under the adopted
  assumption. The predictor, tests, coverage, and BUG-008 use this rule;
  a later design-owner clarification requires updating them together.

## CLARIF-005 — AND vs. OR scope in CSR-conflict invalid conditions

- **Observation:** A blanket instruction to change `AND` to `OR` in
  conflict conditions, if applied globally, would contradict a worked
  example elsewhere in the spec showing `csr_ren_in=1` with no other
  control fields active as a **valid** CSR bypass read (`error=0`).
- **Question raised:** Confirmed the intended scope — is the OR logic
  local to each operation's own table (i.e., only applies when that
  operation's primary enable field is also asserted), rather than a
  global rule that `csr_ren_in=1` is always invalid?
- **Resolution:** Design-team confirmation is unavailable. The project adopts
  the worked-example interpretation: pure CSR bypass with no active BMU
  operation is valid, while CSR combined with an active BMU operation is an
  error. This remains an accepted project risk, not a design-team
  confirmation.
- **Impact on reference model:** Reference model currently treats
  `csr_ren_in=1` with all bit-manip fields deasserted as a valid
  bypass read, and `csr_ren_in=1` combined with any bit-manip enable
  field as an error — this is the interpretation that stays consistent
  with all known worked examples.

## Project closure policy — design-team clarification unavailable

The design team is unavailable for the remainder of this verification
project. Pending clarifications must therefore be closed using the safest
interpretation supported by the specification text, worked examples, and
architectural conventions. This is a verification project decision, not a
claim that the design team confirmed the behavior.

For closure, each pending item must record:

- the adopted expected behavior;
- the evidence and rationale for choosing it;
- the affected model, tests, coverage, and bug records;
- the residual risk and exact sign-off disclosure.

Under this policy, `CLARIF-001`, `CLARIF-004`, and `CLARIF-005` remain
assumption-tagged and are reported as accepted project risk unless later
evidence inside the repository disproves the adopted interpretation. A
future design owner may reopen them, but that is outside this project's
verification closure gate.

---

## Template for new entries

```markdown
## CLARIF-XXX — <short title>

- **Observation:**
- **Question raised:**
- **Resolution:**
- **Impact on reference model:**
```
