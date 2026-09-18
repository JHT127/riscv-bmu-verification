# BMU Assertion Plan

## Scope

The protocol assertion module is
`tb/assertions/bmu_protocol_assertions.sv`. It is compiled and bound through
all simulator filelists. Assertions check interface-visible behavior and the
project-adopted specification assumptions; they do not verify unsupported
Section 8 controls.

## Implemented properties

| Property | Requirement |
|---|---|
| `reset_suppresses_error` | Reset forces `error=0`. |
| `reset_clears_result` | Synchronous reset clears `result_ff`. |
| `result_holds_when_invalid` | `result_ff` holds when `valid_in=0`. |
| `valid_result_is_registered` | A valid transaction does not leave an unknown registered result. |
| `live_error_when_invalid` | Invalid controls still update `error` while `valid_in=0`. |
| `one_primary_operation` | Multiple primary controls assert `error`. |
| `empty_valid_request` | An empty valid request asserts `error`. |
| `csr_conflict` | CSR read combined with a primary operation asserts `error`. |
| `sh2add_requires_zba` | SH2ADD without ZBA asserts `error`. |
| `sub_rejects_zba` | SUB with ZBA asserts `error`. |
| `slt_requires_sub` | SLT without SUB asserts `error`. |
| `max_requires_sub` | MAX without SUB asserts `error`. |
| `grev_encoding` | GREV encoding other than 24 asserts `error`. |

## Validation evidence

- `bmu_timing_reset_test`, seed 3: assertions compiled and ran with zero
  UVM errors/fatals and 15 scoreboard matches.
- `bmu_gap_checks_test`, seed 2: assertions detected the empty-request,
  SLT-without-SUB, and MAX-without-SUB violations on the current RTL. The
  corresponding scoreboard failures remain open DUT findings.
- Assertion failures are not waived merely because the DUT is known to be
  defective. They remain visible until a corrected RTL revision passes the
  original assertion and directed reproducer.

## Assumption boundary

GREV invalid encoding and CSR conflict scope follow the conservative project
assumptions recorded in the clarification log. No assertion was added for
unsupported Section 8 fields or an unconfirmed scan-mode functional effect.

## Closure rule

A property is closed only after the relevant directed tests and regression pass
on the same RTL revision. A project-risk acceptance may document an ambiguity,
but it cannot waive an assertion failure that contradicts the adopted expected
behavior.
