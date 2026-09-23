# BMU Verification Project

<div align="center">

![Status](https://img.shields.io/badge/status-training%20submission-blue)
![Methodology](https://img.shields.io/badge/Methodology-UVM-blue)
![Simulator](https://img.shields.io/badge/Simulator-Xcelium-green)

</div>

A UVM verification project for the delivered RISC-V Bit Manipulation Unit (BMU). The training objective is to find, reproduce, and document RTL bugs against BMU Specification v1.2.

The delivered DUT is preserved. The submission contains nine open DUT findings, isolated reproducers, directed and random tests, assertions, and measured coverage.

---

## 1. Verification scope

- OR / XOR, including ZBB inversion
- SRL / SRA / ROR and BINV
- SH2ADD, SUB, SLT / SLTU, and signed MAX
- CTZ, CPOP, and SEXT.B
- PACK and the specified GREV byte-reverse encoding
- CSR bypass read and both write-data modes
- Reset, result capture, valid hold, live error, and forbidden control combinations

Standalone operations without a behavior table in the supplied specification are outside the functional scope. Their control bits are still exercised as forbidden fields of specified operations. Timing/scan, GREV invalid encodings, and CSR conflict assumptions are recorded in the [clarification log](docs/03_clarifications_log/spec_clarifications_log.md).

## 2. Test architecture

```text
sequence -> sequencer -> driver -> interface -> DUT
                                     |
                                  monitor
                                  /     \
                        reference model  actual
                                  \     /
                                 scoreboard
                                     |
                                  checker
```

The monitor also feeds functional coverage. The predictor uses specification expressions and explicit control masks. Its self-test checks 865 legal, illegal, boundary, and state cases. Assertions check reset, hold, and control guards; the scoreboard compares both `result_ff` and `error` and records complete failing transactions.

The expanded suite includes every shift/index position, CTZ/CPOP counts 0–32, independent operand corners, signed comparisons, byte-extension boundaries, a forbidden-control matrix, and multiple effective random seeds.

## 3. Run the verification

Prerequisites: Cadence Xcelium 25.03-s006 with UVM 1.1d and a working license, GNU Make, Bash, and Python 3.6 or later. IMC 25.09-a020 is used for coverage extraction.

Run from the repository root:

```bash
# Predictor self-check and passing interface checks
make -C sim run TEST=bmu_model_self_test SEED=1
make -C sim run TEST=bmu_or_valid_test SEED=1
make -C sim run TEST=bmu_timing_reset_test SEED=1

# Full regression, including nine isolated bug reproducers
make -C sim regression

# Reproduce the MAX data-selection bug
make -C sim run TEST=bmu_bug_010_test SEED=1

# Capture waveforms
make -C sim waves TEST=bmu_or_valid_test SEED=1

# Extract coverage after the full regression
imc -exec sim/scripts/report_coverage.tcl
```

**The full regression returns a failure status on the original buggy DUT.** Errors are retained, not suppressed or converted to passes. Xcelium uses `-svseed`; the report records the effective seed. VCS and Questa are not supported by the Makefile.

## 4. Submission results

The 22 September 2026 regression completed 26 runs: three passed and 23 reported DUT failures, with zero UVM fatals. The predictor self-test, OR smoke, and timing/reset tests passed.

| Measurement | Result |
|---|---:|
| Functional coverage | 100.00% — 562/562 bins |
| Coverage-run comparisons | 5,036 |
| Coverage-run scoreboard mismatches | 1,548 |
| DUT hierarchy block coverage | 100.00% — 16/16 |
| DUT hierarchy scored expression coverage | 100.00% — 3/3 |
| DUT hierarchy toggle coverage | 65.01% — 1,230/1,892 |
| Open DUT bugs | 9 |

Functional coverage measures exercised scenarios, not correct DUT behavior. Code coverage uses the default Xcelium instrumentation and is scoped to `bmu_tb_top.dut`; it is not a claim of complete expression, branch, or design verification.

- [Bug log and isolated evidence](docs/04_bug_reports/BMU_Bug_Log.md)
- [Test plan](docs/02_test_plan/BMU_Test_Plan.md)
- [Coverage summary](docs/07_coverage_reports/final_coverage_summary.md)
- [Regression results](results/reports/regression_summary.csv)
- [Source and log hashes](results/reports/run_manifest.json)
- [Training verification report](docs/08_signoff/BMU_Signoff_Report.md)

## 5. Repository map

```text
rtl/         delivered DUT and separate exploratory fix variant
tb/         UVM environment, assertions, sequences, and tests
sim/         Xcelium flow and result/coverage helpers
regression/  full, short, random, and bug-reproducer configurations
results/     retained evidence and measured reports
docs/       specification, plans, clarifications, bugs, and final report
waveforms/   generated waveform databases (ignored by Git)
```

The default flow uses the original DUT. The existing `fix_v1` files are exploratory and are not used as submission evidence. See [LICENSE](LICENSE).
