# BMU (Bit Manipulation Unit) — Functional Verification Project

![Status](https://img.shields.io/badge/status-in--progress-yellow)
![Methodology](https://img.shields.io/badge/methodology-UVM-blue)
![License](https://img.shields.io/badge/license-see%20LICENSE-lightgrey)

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

> **Verification inputs:** Specification v1.2 and the delivered RTL snapshot
> are controlled inputs for this repository. The specification remains the
> behavior authority; the RTL is never used to create expected values. See
> [`docs/00_spec/verification_input_baseline.md`](docs/00_spec/verification_input_baseline.md)
> for the frozen revision, simulator, and assumption record.

---

## 2. Repository Structure

```text
BMU-verification/
├── docs/                     # Verification plan, test plan, bug log, presentation, sign-off
├── rtl/                      # Delivered DUT RTL snapshot and compile support
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
cd BMU-verification

# Run the concrete Xcelium smoke test
cd sim
make TEST=bmu_or_valid_test SEED=1 VERBOSITY=UVM_HIGH

# Run the full regression
make regression
```

> The checked-in simulation baseline supports Cadence Xcelium. See
> [`sim/README.md`](sim/README.md) for compile, smoke-test, and regression
> commands.

### 4.1 Canonical evidence layout

This repo separates narrative documentation from generated artifacts:

- `docs/` — project records, interpretation, planning, and review notes
- `results/` — generated logs, coverage databases, summaries, and extracted bug evidence
- `waveforms/` — transient waveform output only, not versioned evidence by default

For coverage specifically, the generated outputs are under `results/coverage/` and
`results/reports/`; the files under [`docs/07_coverage_reports/`](docs/07_coverage_reports)
explain and interpret those generated results rather than duplicating them.

---

## 5. Status

| Milestone | Status |
|---|---|
| Spec review & clarification log | ✅ Complete |
| Verification input baseline | ✅ Frozen for Xcelium smoke execution |
| Verification plan | ✅ Captured |
| Testbench skeleton | ✅ Scaffolded |
| Reference model | ✅ Implemented and exercised |
| Directed sequences (per operation) | ✅ Implemented, including explicit gap-plan tests |
| Constrained-random regression | ✅ Executed; open DUT findings remain |
| Functional coverage closure | ✅ 100% on the dedicated in-scope closure test |
| Bug log | ✅ Runtime findings documented |
| Training verification report | ✅ Complete |

> This project is intentionally scoped as a training verification exercise focused on bug discovery, reproducibility, and documentation. It is not a production RTL sign-off package and the DUT is intentionally kept in its delivered buggy state.

---

## 6. Verification scope and project objective

This repository is a specification-driven verification project for a delivered BMU RTL snapshot. The purpose is to build a credible verification environment, exercise the supported legal behavior space, reproduce specification mismatches, and document those findings in a reviewable and reproducible form.

The project is intentionally scoped as a bug-finding and documentation exercise. The DUT remains in its delivered buggy state, and the repository does not claim design sign-off or RTL repair. In this context, the verification claim is bounded and honest: the project demonstrates that the supported legal model is covered and that runtime-confirmed defects are visible, reproducible, and tracked.

A 100% functional coverage result in this repository therefore means that the declared in-scope bug-finding model is fully exercised, not that the BMU is release-ready or fully corrected. The final claim is validation of the verification flow and evidence capture, not production closure.

## 7. Author

Verification engineer (trainee project) — see presentation in
[`docs/05_presentation/`](docs/05_presentation) for the full write-up
and results walkthrough.

## 8. License

See [`LICENSE`](LICENSE) — this repository's original content
(testbench code, documentation, plans) is shared for portfolio purposes.
It does not include or relicense any third-party or employer-confidential
material (spec, RTL).
