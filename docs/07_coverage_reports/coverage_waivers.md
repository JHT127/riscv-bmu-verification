# BMU Coverage Waivers and Exclusions

## 1. Functional scope

Only operation behavior defined by Specification v1.2 is a standalone functional target. CLZ, MIN, ROL, BSET/BCLR/BEXT, SLL/AND/ADD, SEXT.H, SH1ADD/SH3ADD, PACKU/PACKH, GORC, and branch/prediction functions are outside that scope. Their exposed control bits remain available for forbidden-field checks on specified operations.

DFT scan behavior is an assumption check, not scan-chain verification. GREV non-24 encodings and CSR conflicts follow the visibly recorded adopted assumptions; testing them does not constitute design-owner approval.

## 2. Cross exclusions

The request×error cross ignores two unreachable classes under the adopted model:

- Clean `BMU_INVALID`: invalid controls must assert error.
- Rejected pure CSR bypass: `BMU_CSR_READ` is classified only when CSR read is asserted and all control fields are zero.

Conflicting CSR requests are still counted under the requested operation or invalid classification. Legal operation/data bins sample only active, legal transactions. Reset and idle scenarios have separate coverage.

## 3. Structural coverage

Structural reporting is scoped to the DUT hierarchy. No tool refinement exclusions or automatic unreachable-code waivers were applied. Remaining toggles include unexercised/internal and out-of-scope behavior; their exact reachability has not been proven. The measured 65.01% toggle grade is a baseline, not a ceiling.

See [final_coverage_summary.md](final_coverage_summary.md) for actual metrics. DUT failures remain open regardless of scenario coverage.
