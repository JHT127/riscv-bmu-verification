# Test Plan

**File to add here:** `BMU_Test_Plan.xlsx`

## Recommended sheet structure

| Column | Purpose |
|---|---|
| `Test ID` | e.g. `TC_OR_001` |
| `Operation` | Which BMU operation family this exercises |
| `Description` | What scenario is being tested |
| `Stimulus` | Control fields + operand values (or "constrained-random, N iterations") |
| `Expected Result` | From the reference model, in `result` / `error` terms |
| `Coverage Bin(s)` | Which functional coverage bin(s) this closes |
| `Linked Verification Plan Feature` | Traceability back to `01_verification_plan` |
| `Status` | Not started / In progress / Passing / Failing / Blocked |
| `Linked Bug` | Bug ID if a failure was filed |

## Suggested test categories (mirrors `tb/sequences/`)

1. Directed valid-operation tests (one per instruction, nominal values)
2. Directed corner-case tests (all-zero, all-one, max shift amount, sign boundary, CTZ(0)=32, etc.)
3. Directed error/guard-violation tests (conflicting `ap.*` fields, CSR conflict, Zba misuse)
4. `valid_in` gating tests (hold behavior, back-to-back valid cycles, valid_in toggling mid-stream)
5. Reset tests (reset during a pending result, reset with `valid_in` held high)
6. CSR bypass read/write tests (including the pure-bypass-read case from CLARIF-005)
7. Constrained-random regression (wide operand coverage, all operation fields, weighted toward corner cases)
