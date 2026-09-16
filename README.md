# BMU (Bit Manipulation Unit) — Functional Verification Project

[![Status](https://img.shields.io/badge/status-in--progress-yellow)]()
[![Methodology](https://img.shields.io/badge/methodology-UVM-blue)]()
[![License](https://img.shields.io/badge/license-see%20LICENSE-lightgrey)]()

> A UVM-based functional verification environment for a RISC-V BitManip
> (Zbb / Zbs / Zbp / Zba) execution unit, built as part of a design
> verification training project.

---

## 1. Overview

This repository contains the **verification infrastructure, plans, and
documentation** for the Bit Manipulation Unit (BMU) — a combinational
RISC-V bit-manipulation execution block with a single-cycle registered
output.

The BMU supports:

| Family | Instructions covered |
|---|---|
| Zbb | CLZ, CTZ, CPOP, MIN, MAX, SEXT.B, SEXT.H, ROL, ROR |
| Zbs | BSET, BCLR, BINV, BEXT |
| Zbp | PACK, PACKU, PACKH, GREV (byte-reverse subset), GORC (subset) |
| Zba | SH1ADD, SH2ADD, SH3ADD |
| Misc | CSR bypass read/write, logic ops (OR/XOR), shifts (SLL/SRL/SRA), SLT |

> **Note on confidentiality:** the original design specification and RTL
> source were provided by the design team as part of a training
> engagement and are **not included** in this public repository. See
> [`docs/00_spec/README.md`](docs/00_spec/README.md) and
> [`rtl/README.md`](rtl/README.md) for details. Everything in this repo
> — testbench, plans, and documentation — is original work produced
> during the verification effort.

---

## 2. Repository Structure

```
BMU_Verification_Project/
├── docs/                     # Verification plan, test plan, bug log, presentation, sign-off
├── rtl/                      # DUT RTL placeholder (not included — see rtl/README.md)
├── tb/                       # UVM testbench (env, agents, sequences, tests)
├── sim/                      # Simulation scripts, Makefile, filelists
├── regression/               # Regression configs and logs
├── waveforms/                # Dumped waveform files (vcd/fsdb/wlf) from debug sessions
├── results/                  # Coverage databases, run logs, summary reports
└── scripts/                  # Misc utility / helper scripts
```

Full annotated tree: see [`docs/repo_structure.md`](docs/repo_structure.md).

---

## 3. Verification Methodology

This project follows a standard **UVM class-based verification
methodology**:

- **Agent** — driver + monitor + sequencer around a single DUT interface
- **Reference Model** — an independent, spec-driven predictor of expected
  BMU behavior (built directly from the specification, not from the RTL,
  to avoid circular validation)
- **Scoreboard** — compares DUT output against the reference model
  transaction-by-transaction
- **Functional Coverage** — cross-coverage of operation type × operand
  corner cases × error conditions, tracked in `tb/env/coverage/`
- **Sequences** — organized per operation family (logic, shift, bit-ops,
  count-ops, sign-extend, min/max, pack, CSR, Zba, error-injection,
  reset) so directed and constrained-random stimulus stay modular

See [`docs/01_verification_plan/`](docs/01_verification_plan) for the
full verification plan and [`docs/02_test_plan/`](docs/02_test_plan) for
the detailed test list, and
[`docs/03_clarifications_log/spec_clarifications_log.md`](docs/03_clarifications_log/spec_clarifications_log.md)
for a running log of spec ambiguities raised and resolved with the
design team — a key part of the verification record, not just an aside.

---

## 4. Getting Started

```bash
# Clone
git clone <repo-url>
cd BMU_Verification_Project

# Run a single test (see sim/scripts for wrappers)
cd sim
make TEST=dut_reg_test

# Run the full regression
make regression
```

> Simulator-specific setup notes live in `sim/README.md` (add your
> simulator of choice — VCS, Questa, Xcelium — once environment access
> is available).

---

## 5. Status

| Milestone | Status |
|---|---|
| Spec review & clarification log | ✅ In progress |
| Verification plan | ⏳ Drafting |
| Testbench skeleton | ✅ Scaffolded |
| Reference model | ⏳ Not started |
| Directed tests (per operation) | ⏳ Not started |
| Constrained-random regression | ⏳ Not started |
| Functional coverage closure | ⏳ Not started |
| Bug log | ⏳ Not started |
| Final sign-off report | ⏳ Not started |

---

## 6. Author

Verification engineer (trainee project) — see presentation in
[`docs/05_presentation/`](docs/05_presentation) for the full write-up
and results walkthrough.

## 7. License

See [`LICENSE`](LICENSE) — this repository's original content
(testbench code, documentation, plans) is shared for portfolio purposes.
It does not include or relicense any third-party or employer-confidential
material (spec, RTL).
