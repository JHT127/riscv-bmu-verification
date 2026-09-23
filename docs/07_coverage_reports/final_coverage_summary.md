# Final Coverage Summary

## 1. Run and scope

Measured on 22 September 2026 using Xcelium 25.03-s006 and IMC 25.09-a020. The dedicated `bmu_coverage_closure_test`, effective seed 4, executes 5,036 monitored cycles on the original DUT.

The exact database is `results/coverage/bmu_coverage_closure_test_4/scope/test_sv4`. The old unseeded `scope/test` database is not the submission baseline.

## 2. Functional coverage

| Measurement | Result | Evidence |
|---|---:|---|
| Declared covergroup bins | 562/562 — 100.00% | [IMC functional summary](../../results/reports/functional_coverage.txt) |
| Uncovered functional bins | 0 | [IMC hole report](../../results/reports/functional_coverage_holes.txt) |
| Scoreboard comparisons | 5,036 | [Regression summary](../../results/reports/regression_summary.csv) |
| Matching comparisons | 3,488 | Coverage-run scoreboard summary |
| Mismatching comparisons | 1,548 | Coverage-run scoreboard summary |
| Native assertion failure messages | 513 | Coverage-run log |
| UVM fatals | 0 | Regression summary |

The model covers specified operation classes, legal operand patterns, request×error/valid, all shift positions, separate CTZ/CPOP counts, modifiers, comparison boundaries, byte-extension sign bits, CSR modes, GREV encodings, and reset transitions. Coverage uses expected classifications rather than DUT outputs.

100% means the declared scenarios were exercised. It does not mean the DUT passed, that all possible operand combinations were tested, or that all temporal behavior is formally proven.

## 3. DUT code coverage

The following are the cumulative covered-bin grades for `bmu_tb_top.dut` and its instantiated children from the same run. Unrelated library roots are excluded by selecting `bmu_tb_top` at elaboration.

| Metric | Result |
|---|---:|
| Block | 100.00% — 16/16 |
| Expression | 100.00% — 3/3 |
| Toggle | 65.01% — 1,230/1,892 |
| FSM | N/A; no FSM extracted |

[Raw DUT report](../../results/reports/dut_coverage.txt). Expression coverage is the limited default Xcelium instrumentation; this percentage does not establish full arithmetic/operator coverage. No unreachable-code refinements were applied and no maximum-achievable claim is made. Uncovered toggles remain open structural coverage gaps.

## 4. Assertions and exclusions

IMC reports 11/13 assertions covered. Its grade is not a pass rate: the detailed report contains both successful and failing attempts, and two properties have no successful attempts. See [assertion counters](../../results/reports/assertion_coverage.txt).

Scope exclusions and assumptions are recorded in [coverage_waivers.md](coverage_waivers.md). The [bug log](../04_bug_reports/BMU_Bug_Log.md) remains open.

## 5. Reproduce

```bash
make -C sim regression
imc -exec sim/scripts/report_coverage.tcl
```

The regression intentionally exits nonzero on the delivered buggy DUT. Source/configuration and log hashes are recorded in [run_manifest.json](../../results/reports/run_manifest.json).
