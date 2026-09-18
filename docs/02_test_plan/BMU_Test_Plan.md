# BMU Test Plan

## 1. Purpose and authority

This is the working Markdown test plan for BMU Specification v1.2. The
specification defines expected behavior. The reference model is the expected
value source; the RTL is used only to identify implementation risk. A passing
RTL result is not evidence that the expected value is correct.

This document preserves the current organized plan and adds the gaps found in
the review. It is a planning document, not a coverage report. No test is
reported as passing until it has a runnable test, a recorded seed, and
scoreboard evidence for both `result_ff` and `error`.

## 2. Current baseline

The current plan contains 64 cases:

| Category | Count | Disposition |
|---|---:|---|
| Directed-valid | 19 | Retain |
| Directed-corner | 12 | Retain |
| Directed-error | 17 | Retain and extend |
| Timing | 3 | Retain and extend |
| Reset | 3 | Retain and extend |
| CSR | 4 | Retain and extend |
| Random | 3 | Retain and constrain |
| Scope-TBD | 3 | Keep blocked until specified |
| **Total** | **64** | **Baseline** |

No baseline case is removed. Each case either protects a specified behavior,
an interface condition, or a documented corner. The three `Scope-TBD` cases
must not contribute to in-scope coverage until Section 8 behavior is written.

## 3. Confirmed scope

The in-scope operation families are:

- OR and XOR, including the `ap.zbb` inverted modes.
- SRL, SRA, ROR, and BINV.
- SH2ADD.
- SUB, SLT, SLTU, and MAX.
- CTZ and CPOP.
- SEXT.B.
- PACK and the specified GREV byte-reverse subset.
- CSR bypass read and CSR write.
- `valid_in`, result latency, reset, and `scan_mode` behavior.
- Operation guards and chip-wide conflict conditions.

The following remain out of scope because written behavior is unavailable:

- `ap.min`, `ap.clz`, and `ap.rol`.
- `ap.bset`, `ap.bclr`, `ap.packu`, `ap.packh`, and `ap.gorc`.
- Branch and prediction fields.

Do not use these fields as reference-model expectations or normal functional
coverage targets. If a random sequence can assert them, constrain them low.

## 4. Required additions

These 13 checks increase the plan from 64 to 77 planned checks. They may be
implemented in fewer UVM test classes, but every ID must remain visible in the
test-to-coverage traceability.

| ID | Area | Required stimulus | Expected result and error | Coverage obligation |
|---|---|---|---|---|
| `TC_BINV_004` | BINV | Sweep `b_in[4:0]` from 0 through 31 | Toggle exactly the selected bit; `error=0` | All 32 bit positions |
| `TC_SHIFT_004` | SRL/SRA/ROR | Sweep each shift amount 0 through 31 for each operation | Reference-model result; `error=0` | Operation x shift amount |
| `TC_CPOP_004` | CPOP | High-half-only and low-half-only patterns | Full 32-bit population count; `error=0` | Count values 0 through 32 and operand half |
| `TC_CTZ_005` | CTZ | One-hot `a_in` at every bit position | Result equals one-hot index; `error=0` | CTZ values 0 through 31; retain CTZ(0)=32 |
| `TC_GUARD_001` | Guards | No operation field asserted | `result=0`, `error=1` | Empty request |
| `TC_GUARD_002` | Guards | `ap.zbb=1` with no OR/XOR primary enable | `result=0`, `error=1` | Stray mode |
| `TC_GUARD_003` | Guards | `ap.csr_imm=1` with no `ap.csr_write` | `result=0`, `error=1` | Stray CSR mode |
| `TC_GUARD_004` | Guards | `ap.zba=1` without SH2ADD or valid co-requisite | `result=0`, `error=1` | Stray Zba mode |
| `TC_SLT_005` | SLT | `ap.slt=1`, `ap.sub=0` | `result=0`, `error=1` | Missing subtractor co-requisite |
| `TC_MAX_005` | MAX | `ap.max=1`, `ap.sub=0` | `result=0`, `error=1` | Missing subtractor co-requisite |
| `TC_CSR_005` | CSR | Pure CSR read with `valid_in=0` | Result holds; live `error` follows current controls | CSR read x valid gating |
| `TC_TIME_004` | Timing | Invalid input while `valid_in=0` | Result holds; `error=1` in the same cycle | Invalid x invalid-valid condition |
| `TC_RESET_004` | Reset | Reset with `valid_in=1` and conflicting controls | Reset dominates; result clears and `error=0` under the adopted reset rule | Reset x valid x conflict |

`TC_CTZ_005` is the primary runtime reproducer for `BMU-BUG-009`. `TC_CSR_001`
remains mandatory because the current RTL contains a CSR bypass datapath; it is
a runtime confirmation check, not an open bug assertion.

## 5. Expected-value and timing rules

Every executed row must record:

1. Test ID, sequence/class name, simulator, RTL revision, and seed.
2. Specification section and behavior-table reference.
3. All input operands and active control fields.
4. Expected `result_ff` and expected `error` from the reference model.
5. The observation cycle for the registered result.
6. Coverage bins and crosses closed by the row.
7. Any assumption or clarification dependency.
8. Scoreboard result, log path, and waveform path if it fails.

`result_ff` is checked one cycle after a valid transaction under the adopted
one-cycle model. `error` is checked as a live combinational value in the same
cycle as the input controls. When `valid_in=0`, the result must hold while
`error` still reflects the current controls. Repeated transactions on adjacent
cycles are distinct transactions and must not be deduplicated by the monitor.

## 6. Coverage obligations

Before coverage is generated, the environment must provide covergroups for:

- Every in-scope primary operation.
- OR/XOR mode combinations.
- All shift amounts 0 through 31 for SRL, SRA, and ROR.
- All BINV positions 0 through 31.
- CTZ values 0 through 32 and CPOP values 0 through 32.
- SEXT.B positive, negative, zero, and sign-boundary operands.
- Signed and unsigned SLT equal, boundary, and ordering cases.
- MAX ordering and signed boundary cases.
- PACK half-word boundary patterns.
- GREV encoding 24 and the adopted invalid-encoding case.
- CSR bypass, both write-source forms, and CSR conflict.
- Valid, invalid, `valid_in=0`, reset, and scan conditions.
- Operation x corner class x valid/error crosses.

Coverage must report bins for the 13 additions separately. A sequence name or
random iteration count is not a substitute for a closed bin.

## 7. Safe assumptions and ambiguity handling

The following behavior is used conservatively until written confirmation is
available:

- GREV with `b_in[4:0] != 24` is treated as invalid: `result=0`, `error=1`.
  This is tracked by `CLARIF-004` and must remain assumption-tagged.
- A pure CSR read with `csr_ren_in=1` and no bit-manip operation is valid.
  CSR combined with an active bit-manip operation is invalid. This is tracked
  by `CLARIF-005` and must remain assumption-tagged.
- Reset clears the registered result and suppresses `error` under the current
  model. Timing, reset, and scan behavior remain pending written confirmation
  under `CLARIF-001`.

If a clarification changes one of these rules, update the reference model,
affected tests, coverage bins, and bug disposition together. Do not silently
change expected values in a report.

## 8. Execution order and exit criteria

Run in this order:

1. OR smoke test.
2. Nominal directed tests.
3. Corner and boundary sweeps.
4. Guard and error-injection tests.
5. CSR, timing, reset, and scan tests.
6. Legal constrained-random regression.
7. Invalid-control regression.
8. Bug reproduction and retest runs.
9. Coverage review and report generation.

The plan is ready to feed coverage/reporting only when the test IDs are mapped
to executable tests, the simulator entry point works, the regression names
resolve, and each planned mismatch has a bug disposition. Final sign-off also
requires all in-scope tests passing, defined coverage targets met or waived,
no open Critical/Major bugs, and all assumptions either resolved or explicitly
accepted as risk.
