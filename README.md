# BMU Verification Project

<div align="center">

![Status](https://img.shields.io/badge/status-verification%20in%20progress-yellow)
![Methodology](https://img.shields.io/badge/UVM-based%20verification-blue)
![Simulator](https://img.shields.io/badge/xcelium-supported-green)
![License](https://img.shields.io/badge/license-portfolio-lightgrey)

</div>

A polished verification package for a RISC-V Bit Manipulation Unit (BMU), built to validate the delivered RTL against the frozen specification, exercise real test scenarios, and document open functional issues with clear evidence.

This project is aimed at demonstrating professional design verification practice: spec-driven testing, independent reference model checks, assertion-based validation, gap tracking, and traceable bug documentation.

---

## Index

1. [Executive summary](#1-executive-summary)
2. [What this project verifies](#2-what-this-project-verifies)
3. [Verification strategy](#3-verification-strategy)
4. [Test architecture](#4-test-architecture)
5. [Assertion and bug story](#5-assertion-and-bug-story)
6. [Repository map](#6-repository-map)
7. [How to run the checks](#7-how-to-run-the-checks)
8. [Evidence and status](#8-evidence-and-status)
9. [License and notes](#9-license-and-notes)

---

## 1. Executive summary

This repo is a complete verification project for a BMU RTL snapshot. It contains:

- a real UVM testbench
- a spec-driven reference model and scoreboard
- directed and constrained-random tests
- protocol assertions for guard and validity conditions
- a structured bug log with runtime-confirmed defects
- documentation for verification planning, testing, and findings

The important distinction is that the repository preserves the original delivered DUT and documents the issues found against it. It does not claim the original RTL is production-ready. The purpose is to demonstrate high-quality verification discipline and evidence capture.

---

## 2. What this project verifies

The BMU covers key bit-manipulation behaviors from the RISC-V BitManip space, including:

- Zbb: CLZ, CTZ, CPOP, MIN, MAX, SEXT.B, SEXT.H, ROL, ROR
- Zbs: BSET, BCLR, BINV, BEXT
- Zbp: PACK, PACKU, PACKH, GREV, and GREV subset validation
- Zba: SH1ADD, SH2ADD, SH3ADD
- CSR read/write bypass behavior
- logic operations and shift variants
- reset, valid gating, and invalid-control rejection

The verification scope is deliberately broad enough to cover legal functionality as well as guard conditions and illegal control combinations.

---

## 3. Verification strategy

The verification effort follows a standard, credible UVM flow:

- spec baseline is treated as the expected behavior authority
- the RTL under test is treated as a design input, not a source of truth
- the reference model independently predicts expected outputs
- the scoreboard compares actual DUT results to the reference model
- directed tests target known risky behaviors and corner cases
- constrained-random tests expand behavioral coverage over legal and illegal conditions
- assertions monitor protocol-level correctness in real time

This provides both functional confidence and traceability from a failing test to a specific bug declaration or guard violation.

---

## 4. Test architecture

The project includes a full UVM testbench structure under `tb/`.

### Core test categories

- base and smoke tests
- directed behavior tests
- gap-check reproducer tests
- gap-plan and custom sweep tests
- random legal and illegal cases
- coverage-closure tests

### Real tests present in the repo

The repo contains actual test files under `tb/tests/`, including:

- `bmu_base_test.sv`
- `bmu_gap_checks_test.sv`
- `bmu_gap_plan_tests.sv`
- `bmu_directed_suite_tests.sv`
- `bmu_or_valid_test.sv`
- `bmu_random_tests.sv`
- `bmu_coverage_closure_test.sv`
- `bmu_coverage_max_test.sv`

These are not placeholders; they are real test classes wired into the UVM package and simulator flow.

### What the tests do

- verify valid operations match ref-model expectations
- exercise corner cases like zero, all-ones, one-hot patterns, and bit-position sweeps
- ensure invalid combinations trigger error behavior
- confirm reset and hold semantics
- validate the regression and bug-reproduction flow end-to-end

---

## 5. Assertion and bug story

### Assertion story

The repository includes assertion-based checks in `tb/assertions/bmu_protocol_assertions.sv` and the fix-variant companion file.

These assertions validate:

- reset clears error and result state
- `result_ff` holds when `valid_in` is low
- illegal control combinations are rejected
- `SLT` and `MAX` require the `SUB` co-requisite
- GREV invalid encodings must fail
- CSR and operation conflicts are caught
- empty requests are flagged as invalid

Assertions are a key part of the verification story because they expose protocol-level violations even before the scoreboard catches a mismatch.

### Bug story

The project contains a real bug log showing open runtime-confirmed issues. The bug record tracks issues such as:

- CPOP width/count mismatch
- PACK ordering error
- CSR write source selection issue
- GREV byte-ordering bug
- invalid control handling problems
- SLT/MAX guard omission
- GREV invalid encoding acceptance
- CTZ issue for one-hot positions

Those defects are recorded as Open and remain traceable to the test evidence and logs in the project.

The repo intentionally keeps the original DUT and the bug findings separate from any fix investigation work, which is important for honest engineering documentation.

---

## 6. Repository map

```text
BMU-verification/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── docs/
│   ├── 00_spec/
│   ├── 01_verification_plan/
│   ├── 02_test_plan/
│   ├── 03_clarifications_log/
│   ├── 04_bug_reports/
│   ├── 05_presentation/
│   ├── 06_architecture_diagrams/
│   ├── 07_coverage_reports/
│   └── 08_signoff/
├── rtl/
│   ├── Bit_Manipulation_Unit.sv
│   ├── Bit_Manipulation_Unit_fix_v1.sv
│   ├── rtl_lib.sv
│   ├── rtl_lib_fix_v1.sv
│   ├── rtl_def.sv
│   ├── rtl_param.sv
│   └── ...
├── tb/
│   ├── assertions/
│   ├── env/
│   ├── include/
│   ├── interface/
│   ├── packages/
│   ├── sequences/
│   ├── tests/
│   └── top/
├── sim/
│   ├── Makefile
│   ├── filelists/
│   └── scripts/
├── regression/
├── results/
├── waveforms/
├── scripts/
├── xcelium.d/
└── .gitignore
```

This structure separates:

- design input and preserved original DUT
- verification environment and testbench
- documentation and project plan
- generated evidence and logs
- isolated fix-version work

---

## 7. How to run the checks

### Prerequisites

- Cadence Xcelium installed and available in PATH
- a Linux shell environment
- repo access via Git

### Standard compile and smoke run

```bash
cd BMU-verification/sim
make TEST=bmu_or_valid_test SEED=1 VERBOSITY=UVM_MEDIUM
```

### Directed bug reproducer

```bash
cd BMU-verification/sim
make TEST=bmu_gap_checks_test SEED=1 VERBOSITY=UVM_LOW
```

### Regression entry point

```bash
cd BMU-verification/sim
make regression
```

### Summary command

```bash
echo "=== BMU repo summary ===" && \
git --no-pager status --short --branch && \
find tb/tests -maxdepth 1 -type f -name "*.sv" | sort && \
find results/logs -maxdepth 1 -type f | sort | tail -n 12
```

---

## 8. Evidence and status

The repository keeps runtime evidence under `results/` and `waveforms/` so a reviewer can see the real failure signatures and not just narrative conclusions.

### Current project stance

- the delivered DUT is preserved and documented as the original RTL snapshot
- the verification flow is active and real
- known issues are tracked as Open in the bug log
- fix-version work is isolated separately from the original RTL
- the repo is structured for professional review and presentation

This is a valid engineering position for a training and verification project: honest evidence, traceable findings, and clear separation of original and repaired work.

---

## 9. License and notes

See [LICENSE](LICENSE).

This project is designed for verification and portfolio use. It is not a vendor sign-off or production release artifact, and it intentionally keeps the original RTL and the fixed investigation separate.

---

## 10. Final note

This repository is a strong example of professional verification engineering because it shows the full story:

- what was intended
- what was tested
- what was observed
- what remains open
- where the evidence is kept

That is the foundation of a credible, presentable verification project.
