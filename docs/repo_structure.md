# Annotated Repository Structure

```text
BMU_Verification_Project/
│
├── README.md                          Project overview / entry point
├── LICENSE
├── CHANGELOG.md
├── .gitignore
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md              Structured DUT bug report template
│   │   └── feature_request.md         Template for TB enhancement requests
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
│       └── docs_lint.yml              CI: lints Markdown docs on push/PR
│
├── docs/
│   ├── README.md                      Docs index
│   ├── repo_structure.md              This file
│   ├── 00_spec/                       Spec notes (spec itself NOT included — confidential)
│   ├── 01_verification_plan/          BMU_Verification_Plan.xlsx (to be added)
│   ├── 02_test_plan/                  BMU_Test_Plan.xlsx (to be added)
│   ├── 03_clarifications_log/         spec_clarifications_log.md — living Q&A record
│   ├── 04_bug_reports/                Personal bug log (mirrors ClickUp board)
│   ├── 05_presentation/               Slides + assets for the final presentation
│   ├── 06_architecture_diagrams/      TB & DUT architecture / timing diagrams
│   ├── 07_coverage_reports/           Exported coverage snapshots
│   └── 08_signoff/                    Final sign-off checklist + summary
│
├── rtl/                                DUT RTL placeholder — see rtl/README.md
│
├── tb/                                 UVM testbench
│   ├── top/                            top_tb.sv — top-level TB module
│   ├── interface/                      DUT SystemVerilog interface(s)
│   ├── include/                        Macros, `uvm_def.sv`, global defines
│   ├── packages/                       UVM package(s) tying everything together
│   ├── env/
│   │   ├── agents/bmu_agent/           driver / monitor / sequencer for the BMU interface
│   │   ├── reference_model/            Spec-driven golden predictor (independent of RTL)
│   │   ├── scoreboard/                 Compares DUT vs. reference model
│   │   └── coverage/                   Functional coverage collector(s)
│   ├── sequences/                      One folder per operation family:
│   │   ├── base/                       Base sequence + common utilities
│   │   ├── logic_ops/                  OR / XOR
│   │   ├── shift_ops/                  SLL / SRL / SRA / ROL / ROR
│   │   ├── bit_ops/                    BSET / BCLR / BINV / BEXT
│   │   ├── count_ops/                  CLZ / CTZ / CPOP
│   │   ├── sign_extend_ops/            SEXT.B / SEXT.H
│   │   ├── minmax_ops/                 MIN / MAX
│   │   ├── pack_ops/                   PACK / PACKU / PACKH / REV8 / ORC.B
│   │   ├── csr_ops/                    CSR bypass read/write, CSR-conflict cases
│   │   ├── zba_ops/                    SH1ADD / SH2ADD / SH3ADD
│   │   ├── error_injection/            Deliberate guard-condition violations
│   │   └── reset_ops/                  Reset-during-operation scenarios
│   └── tests/                          Top-level UVM test classes
│
├── sim/
│   ├── Makefile                        Simulation entry point
│   ├── filelists/                      .f filelists per simulator/config
│   └── scripts/                        run_test.sh, run_regression.sh, etc.
│
├── regression/
│   ├── configs/                        Regression suite definitions (YAML/JSON/CSV)
│   └── logs/                           Raw regression run logs (gitignored contents)
│
├── waveforms/                          Dumped .vcd / .fsdb / .wlf debug waveforms (gitignored contents)
│
├── results/
│   ├── coverage/                       Coverage databases (gitignored contents)
│   ├── logs/                           Simulation run logs (gitignored contents)
│   └── reports/                        Generated summary reports (pass/fail, coverage %)
│
└── scripts/
    └── utils/                          Misc helper scripts (log parsing, report generation, etc.)
```

## Design notes

- **Reference model lives in the testbench (`tb/env/reference_model/`),
  not derived from the RTL.** Since the goal is to verify the RTL, the
  golden model must be built independently from the specification —
  otherwise bugs shared between RTL and model would go undetected.
- **Sequences are split per operation family** rather than one giant
  sequence file, so directed tests, constrained-random knobs, and
  coverage can all be reasoned about per instruction group — mirrors
  how the spec itself is organized.
- **`waveforms/`, `results/`, and `regression/logs/`** are runtime
  outputs — folders are versioned (via `.gitkeep`) but their generated
  contents are excluded via `.gitignore` so the repo doesn't bloat with
  binary simulation artifacts.
