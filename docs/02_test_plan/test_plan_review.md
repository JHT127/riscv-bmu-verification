# BMU Test Plan Review

## 1. Purpose

This document preserves the current BMU test plan and records the verification
review performed against BMU Specification v1.2. The specification is the
behavior authority. The RTL is used only to identify DUT risks after the plan
has been defined; it is not used to create expected values.

The current organized test plan reports **64 test cases**:

| Category | Current count |
|---|---:|
| Directed-valid | 19 |
| Directed-corner | 12 |
| Directed-error | 17 |
| Timing | 3 |
| Reset | 3 |
| CSR | 4 |
| Random | 3 |
| Scope-TBD | 3 |
| **Total** | **64** |

The current plan is retained as the baseline. The additions below close gaps
found during the review. No existing test is removed because each current case
has traceability value or protects a documented corner condition.

The counts below are planning counts, not executed-test counts. The current
repository has one concrete smoke test (`bmu_or_valid_test`) and a sequence
library, but it does not yet provide one runnable UVM test class per planned
case. Coverage and reporting must remain blocked until the planned IDs are
mapped to executable tests and run.

## 2. Confirmed Scope

The plan covers the operations fully specified in Specification v1.2:

- OR and XOR, including the `ap.zbb` inverted modes.
- SRL, SRA, ROR, and BINV.
- SH2ADD.
- SUB, SLT/SLTU, and MAX.
- CTZ and CPOP.
- SEXT.B.
- PACK and the documented GREV byte-reverse subset.
- CSR bypass read and CSR write.
- Timing, `valid_in`, reset, and `scan_mode` behavior.
- Operation guards and chip-wide conflict conditions.

Section 8 fields remain out of scope until they have written behavior:

- `ap.min`, `ap.clz`, `ap.rol`.
- `ap.bset`, `ap.bclr`.
- `ap.packu`, `ap.packh`, `ap.gorc`.
- Branch and prediction fields.

Those fields must not be used as expected-value sources or normal functional
coverage targets.

## 3. Current Plan Assessment

### Retain

The current plan correctly includes:

- Nominal directed cases for every documented operation family.
- CTZ(0)=32.
- GREV valid and undefined-encoding cases.
- CSR bypass read and CSR conflict behavior.
- SH2ADD without `ap.zba`.
- Plain SUB with `ap.zba` misuse.
- One-cycle latency, `valid_in` hold, and back-to-back timing.
- Reset clear, reset during operation, and scan-mode behavior.
- Legal, corner-weighted, and random error regressions.

### Clarify

1. Every expected result and error value must come from the reference model,
   not from a DUT waveform or RTL expression.
2. The current plan's `Scope-TBD` cases must remain blocked until Section 8
   fields receive a written specification.
3. GREV invalid encoding and CSR conflict scope are adopted assumptions. Their
   tests remain required, but results must be marked assumption-dependent.
4. Timing tests must check `result_ff` one cycle later while checking `error`
   in the same cycle as the inputs.
5. Repeated transactions must not be deduplicated by the monitor.

### Readiness status

| Area | Current repository evidence | Status before coverage work |
|---|---|---|
| Specification authority | v1.2 behavior summary and clarification log | Ready with assumption tags |
| Reference model | Independent model and scoreboard compare result and error | Ready for review; runtime evidence pending |
| Directed tests | Sequence inventory exists; only smoke test is a concrete test | Not ready |
| Error matrix | Error-injection sequence is incomplete for the added guards | Not ready |
| Functional coverage | No coverage subscriber or covergroups are present | Not ready |
| Simulator execution | Makefile compile/run targets are placeholders | Blocked |
| Regression configuration | Nightly names tests that do not exist | Blocked |
| Reporting inputs | No coverage database or regression summary exists | Blocked |

The next implementation step is to make the test IDs executable and repair
the simulator and regression entry points. Do not generate a coverage
percentage from the current sequence inventory.

## 4. Required Additions

The following additions are required. They increase the reviewed plan from 64
tests to 77 planned checks if each row is implemented as a separate test case.
A team may combine rows into one test class, but each row must retain its own
ID, expected result, and coverage obligation.

| New ID | Area | Required check | Reason |
|---|---|---|---|
| `TC_BINV_004` | BINV | Sweep all bit positions 0 through 31. | Existing cases cover only representative positions; the spec defines every low-five-bit index. |
| `TC_SHIFT_004` | SRL/SRA/ROR | Sweep every shift amount 0 through 31 for each operation. | Boundary-only tests do not prove all defined amounts. |
| `TC_CPOP_004` | CPOP | Count high-half-only and low-half-only patterns. | Separates all 32 operand bits and detects partial-width implementation. |
| `TC_CTZ_005` | CTZ | Sweep one-hot inputs across all 32 bit positions. | Proves the complete trailing-zero result range. |
| `TC_GUARD_001` | Guards | No operation field asserted: result 0, error 1. | The guard philosophy defines an invalid empty request. |
| `TC_GUARD_002` | Guards | `ap.zbb=1` without OR/XOR primary enable. | Mode bits without a primary operation must be invalid. |
| `TC_GUARD_003` | Guards | `ap.csr_imm=1` without `ap.csr_write`. | CSR mode must not create an unselected operation. |
| `TC_GUARD_004` | Guards | `ap.zba=1` without SH2ADD or a valid Zba co-requisite. | Isolates a stray mode bit. |
| `TC_SLT_005` | SLT | `ap.slt=1` without `ap.sub=1`. | The specification requires the subtractor co-requisite. |
| `TC_MAX_005` | MAX | `ap.max=1` without `ap.sub=1`. | The specification requires the subtractor co-requisite. |
| `TC_CSR_005` | CSR | Pure CSR read with `valid_in=0` and live error check. | Separates registered-result hold from combinational error behavior. |
| `TC_TIME_004` | Timing | Invalid input while `valid_in=0`; result holds and error updates. | Explicitly proves the live-error rule. |
| `TC_RESET_004` | Reset | Reset asserted with `valid_in=1` and conflicting controls. | Proves reset overrides both operation and error conditions. |

Each new row is mandatory until it is either executed and passing or waived
with a written reason. `TC_CTZ_005` is the primary runtime reproducer for
`BMU-BUG-009`. `TC_CSR_001` remains mandatory, but it is a runtime check for
the corrected CSR-bypass review status, not evidence for an open bug.

## 5. Expected-Value Rules

For every row, record:

1. Input values and active control fields.
2. Specification section and table row.
3. Expected `result_ff` value at the observed cycle.
4. Expected `error` value for the current inputs.
5. Whether the result is immediate or one-cycle delayed.
6. Coverage bins closed.
7. Assumption or clarification dependency.

The reference model must calculate the result independently. The scoreboard
must compare both `result_ff` and `error`; a matching result with a wrong error
is a failure.

## 6. Coverage Plan

Functional coverage must include:

- Every documented primary operation.
- OR/XOR `ap.zbb` modes.
- SRL/SRA/ROR shift amounts 0, 1, 4, 15, 16, 30, and 31, with the full
  0-to-31 range covered by the sweep tests.
- BINV bit positions 0, 1, 2, 15, 16, 30, and 31, with full range coverage.
- CTZ values 0 through 32.
- CPOP values 0 through 32.
- Positive and negative SEXT.B values.
- Signed and unsigned SLT boundary/equal cases.
- MAX operand ordering and sign boundary.
- PACK half-word boundary patterns.
- GREV encoding 24 and the adopted invalid-encoding case.
- CSR bypass, immediate write, register write, and conflict.
- Valid, invalid, `valid_in=0`, and reset conditions.
- Crosses of operation x corner class x valid/error condition.

Coverage must not claim closure for Section 8 fields.

## 7. Execution Order

1. Run the OR valid smoke test.
2. Run all nominal directed tests.
3. Run corner and boundary sweeps.
4. Run guard and error-injection tests.
5. Run CSR, timing, and reset tests.
6. Run constrained-random legal and corner regressions.
7. Run random invalid-control regression.
8. Review every mismatch against Specification v1.2.
9. Update bug records and coverage results.

## 8. Exit Criteria

The plan is complete only when:

- All in-scope directed cases pass.
- All required additions are implemented or explicitly waived.
- Functional coverage reaches the defined target or has documented waivers.
- Every DUT mismatch has a bug disposition.
- Adopted assumptions are either accepted as risk or replaced by written
  clarification.
- No unreviewed Section 8 behavior is counted as verified.
