# BMU Verification Project Reference

## 1. Purpose

This file is the main continuation guide for the BMU verification project.
Read it before adding RTL, UVM components, sequences, tests, or simulation
scripts.

The project verifies the BMU from the verification-ready functional
specification. The delivered RTL snapshot is present for DUT integration and
risk review, but it must not be used as the source of expected behavior.

The formal behavior source is Specification v1.2:

- `Bit Manipulation Unit (BMU) Functional Specification — Verification-Ready Edition`
- Sections 1 through 6 define the documented behavior.
- Section 7 contains adopted assumptions pending design-team confirmation.
- Section 8 lists fields outside the current documented scope.

This repository is structured as a verification-first project. The expected
value model, scoreboard, protocol assertions, and coverage model are all
separate from the DUT implementation so that the verification team can catch
real design defects without changing RTL during signoff preparation.

## 2. Current project status

### 2.1 Completed baseline

- BMU control type package.
- BMU interface with driver and monitor clocking blocks.
- Sequence item, sequencer, driver, monitor, and agent.
- Independent specification-based reference model.
- Separate checker and scoreboard.
- UVM environment connections.
- Common sequence base and family sequence bases.
- Concrete sequence inventory and smoke test setup.
- Package include order for all current UVM components and sequences.
- Compile-safe top-level testbench shell.
- Reusable base UVM test.
- Approved delivered RTL snapshot and specification summary.
- RTL parameter include wrapper and simulator filelist.
- Coverage model and closure-style legal-operation test.

### 2.2 In-flight verification facts

- The project has confirmed runtime DUT defects in the bug log.
- The verification environment is independently checking the RTL against the
  specification; it is not an environment-only mismatch problem.
- Functional coverage for the supported in-scope model reaches 100.00% in the
  closure run.
- The broader max-coverage probe is still failing legal cases and is therefore
  not a signoff-quality closure result.
- The aggregate code coverage baseline remains low because the merged run
  includes a broad RTL library context and out-of-scope logic.

### 2.3 Verification status summary

This project is in a genuine pre-closure finding state, not a green-signoff
state.

The repo contains:

- a functioning independent reference model
- a directed and random test suite
- a bug log with runtime-confirmed findings
- an assertion module that checks invalid-control and protocol rules
- a functional coverage model for the supported legal domain
- a measured code coverage baseline, but not a signoff-closed code target

## 3. Specification contract

### 3.1 Interface

| Signal | Width | Direction | Meaning |
|---|---:|---|---|
| `clk` | 1 | input | Clock. |
| `rst_l` | 1 | input | Active-low synchronous reset. |
| `scan_mode` | 1 | input | DFT control with no functional role. |
| `valid_in` | 1 | input | Enables `result_ff` capture. |
| `a_in` | 32 | input | First operand. |
| `b_in` | 32 | input | Second operand or shift/index value. |
| `ap` | struct | input | Decoded operation controls. |
| `csr_ren_in` | 1 | input | CSR bypass-read request. |
| `csr_rddata_in` | 32 | input | CSR read data. |
| `result_ff` | 32 | output | Registered result. |
| `error` | 1 | output | Combinational error flag. |

### 3.2 Timing and reset

- The BMU has one-cycle registered result behavior.
- `result_ff` captures the calculated result when `valid_in=1`.
- `result_ff` holds its previous value when `valid_in=0`.
- `error` is live and combinational; it may be asserted while the DUT is idle.
- `rst_l=0` is a synchronous reset that clears `result_ff` and `error`.
- `scan_mode` has no functional effect and is normally driven low.

### 3.3 Documented operations

| Operation | Primary control | Required mode or co-requisite |
|---|---|---|
| OR | `ap.lor` | `ap.zbb` optionally selects inverted `b_in`. |
| XOR | `ap.lxor` | `ap.zbb` optionally selects inverted `b_in`. |
| SRL | `ap.srl` | Shift amount is `b_in[4:0]`. |
| SRA | `ap.sra` | Arithmetic right shift by `b_in[4:0]`. |
| ROR | `ap.ror` | Rotate right by `b_in[4:0]`. |
| BINV | `ap.binv` | Invert bit at `b_in[4:0]`. |
| SH2ADD | `ap.sh2add` | Requires `ap.zba=1`. |
| SUB | `ap.sub` | Plain SUB requires `ap.zba=0`. |
| SLT/SLTU | `ap.slt` | Requires `ap.sub`; `ap.unsign` selects unsigned mode. |
| CTZ | `ap.ctz` | `CTZ(0)=32`. |
| CPOP | `ap.cpop` | Counts set bits in `a_in`. |
| SEXT.B | `ap.siext_b` | Sign-extends `a_in[7:0]`. |
| MAX | `ap.max` | Requires `ap.sub`; signed comparison. |
| PACK | `ap.pack` | Result is `{b_in[15:0], a_in[15:0]}`. |
| GREV subset | `ap.grev` | Only `b_in[4:0]=24` is implemented. |
| CSR read | `csr_ren_in` | Valid only when all `ap` fields are clear. |
| CSR write | `ap.csr_write` | `ap.csr_imm=1` selects `b_in`, otherwise `a_in`. |

### 3.4 Guard rules

Each operation must have exactly one valid primary operation selection.
Conflicting operation fields force `result=0` and `error=1`.

The following are also errors:

- A bit-manipulation operation combined with `csr_ren_in=1`.
- `SH2ADD` without `ap.zba=1`.
- Plain `SUB` with `ap.zba=1`.
- `SLT` or `MAX` without the required `ap.sub` co-requisite.
- A GREV request with an encoding other than 24.
- Any unsupported or invalid control combination.

CSR bypass read is valid when `csr_ren_in=1` and all `ap` fields are clear.

## 4. Adopted assumptions and residual risk

These are from specification Section 7 and must remain visibly separated from
confirmed behavior:

- GREV with `b_in[4:0] != 24` returns zero and asserts `error`.
- CSR conflict logic is scoped to an active operation. A CSR read with no active
  BMU operation remains valid.
- Timing, reset, and scan behavior follow the current adopted model pending a
  written design clarification.

These assumptions are not silently changed by a test or a bug disposition. If
an assumption is changed, update the clarification log, reference model, test
plan, and bug dispositions together.

## 5. Runtime-confirmed DUT findings

The following defects are currently documented as open runtime-confirmed DUT
issues in the bug log:

- BMU-BUG-001: CPOP width issue.
- BMU-BUG-002: PACK ordering issue.
- BMU-BUG-003: CSR write source issue.
- BMU-BUG-005: GREV byte-order issue.
- BMU-BUG-006: invalid/conflicting controls not rejected.
- BMU-BUG-007: SLT/MAX missing SUB co-requisite guard.
- BMU-BUG-008: GREV undefined encoding not rejected.
- BMU-BUG-009: CTZ one-hot mismatch.

One item, BMU-BUG-004, was withdrawn after runtime verification showed it was
not a real DUT defect.

These problems are not treated as model waivers. They are current defects to be
fixed or formally accepted by the design team.

## 6. Coverage status and evidence

### 6.1 Functional coverage

The supported in-scope closure model reaches 100.00% in the dedicated closure
run. Evidence is in:

- `results/logs/bmu_coverage_closure_test_4.log`
- `docs/07_coverage_reports/final_coverage_summary.md`

This functional coverage number is valid only for the legal supported domain
and does not imply signoff completion.

### 6.2 Code coverage baseline

The measured merged code-coverage baseline is 17.74% aggregate. Evidence is in:

- `results/reports/overall_code_coverage_summary.txt`
- `docs/07_coverage_reports/coverage_waivers.md`

This is a measured baseline, not a closed design-signoff target.

### 6.3 Why the code coverage remains low

The aggregate run includes the full library hierarchy and out-of-scope logic in
addition to the BMU itself. It is therefore useful as a current baseline but not
as proof of a closed RTL signoff. The project was intentionally scoped to
verification and defect capture, not RTL modification.

## 7. Verification architecture

```text
sequence
   |
sequencer -> driver -> bmu_interface -> DUT
                                  |
                              monitor
                              /     \
                 reference model   actual stream
                         |             |
                         +-> scoreboard -> checker
```

The monitor publishes one transaction per clock. Repeated transactions must not
be suppressed because valid hold, reset, back-to-back operations, and live error
behavior are all meaningful.

The reference model calculates expected behavior from the specification only.
It does not import, call, inspect, or copy RTL behavior.

The scoreboard aligns actual and expected streams. The checker compares
`result_ff` and `error`. Keep these responsibilities separate.

## 8. Key evidence files

These are the files that a plan writer or bug document author should review when
building the formal verification and bug documents:

- `docs/00_spec/verification_input_baseline.md`
- `docs/01_verification_plan/reference_model_audit.md`
- `docs/02_test_plan/BMU_Test_Plan.md`
- `docs/03_clarifications_log/spec_clarifications_log.md`
- `docs/04_bug_reports/BMU_Bug_Log.md`
- `docs/04_bug_reports/bug_report_review.md`
- `docs/07_coverage_reports/final_coverage_summary.md`
- `docs/07_coverage_reports/coverage_waivers.md`
- `results/logs/bmu_nominal_directed_test_1.log`
- `results/logs/bmu_error_directed_test_1.log`
- `results/logs/bmu_gap_checks_test_1.log`
- `results/logs/bmu_legal_random_test_101.log`
- `results/logs/bmu_corner_random_test_201.log`
- `results/logs/bmu_error_random_test_301.log`
- `results/logs/bmu_coverage_closure_test_4.log`
- `results/reports/overall_code_coverage_summary.txt`

## 9. What a verification-plan author must include

A verification-plan writer should capture the following in the final plan:

- The BMU legal operation set and guard rules.
- The independent reference model strategy.
- The expected behavior for reset, valid gating, and error signals.
- The legal-domain boundaries and known assumptions.
- The runtime-confirmed DUT defects and the exact failing procedures that
  reproduced them.
- The functional coverage model for the supported legal domain.
- The measured code coverage baseline and the waived or excluded logic.
- The fact that the project is verification-first and no RTL edits are allowed
  to close findings.

## 10. What a test-plan author must include

A test-plan writer should organize tests by behavior class:

- logic operations
- bit-manipulation and shift operations
- counts and sign-extension
- min/max and comparison logic
- PACK and GREV handling
- CSR read/write and conflict cases
- guard and invalid-control checks
- reset and timing behavior
- legal-random and corner-case stress

Every high-value test should map back to a spec rule and should include the
expected result, legal mode, and evidence path.

## 11. What a bug-document author must include

A bug document author should record:

- defect ID, severity, and functional area
- specification requirement violated
- reproducer and legal stimulus pattern used
- expected result and actual DUT result
- proof path from log and scoreboard output
- whether the issue is runtime confirmed, accepted risk, or withdrawn
- follow-up action and closure gate

## 12. Working rules

- Specification v1.2 is the behavior authority. Do not use RTL to create
  expected values.
- Do not test fields listed in Specification v1.2 Section 8 until they receive
  a written behavior definition.
- Keep comments short and useful.
- Use lowercase `bmu_` filenames and explicit class names.
- Keep files focused by responsibility.
- Preserve the existing spacing and section-banner style.
- Commit every meaningful file or fix independently.
- Push every commit immediately.
- Use short, lowercase, meaningful commit messages.
- Commit RTL and project-owned specification documents when they are approved
  for this repository and needed for verification.
- Do not commit confidential or restricted material, simulator databases, or
  generated reports unless they are explicitly approved and documented.
