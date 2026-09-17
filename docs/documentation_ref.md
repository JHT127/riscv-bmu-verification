# BMU Verification Project Reference

## 1. Purpose

This file is the main continuation guide for the BMU verification project.
Read it before adding RTL, UVM components, sequences, tests, or simulation
scripts.

The project verifies the BMU from the verification-ready functional
specification. The RTL is not included in this repository and must not be used
as the source of expected behavior.

The formal behavior source is Specification v1.2:

- `Bit Manipulation Unit (BMU) Functional Specification — Verification-Ready Edition`
- Sections 1 through 6 define the documented behavior.
- Section 7 contains adopted assumptions pending design-team confirmation.
- Section 8 lists fields that are outside the current documented scope.

The verification plan and test plan provide traceability and test ownership.
This document explains how the repository is organized and how to continue the
implementation.

## 2. Current Status

Completed:

- BMU control type package.
- BMU interface with driver and monitor clocking blocks.
- Sequence item, sequencer, driver, monitor, and agent.
- Independent specification-based reference model.
- Separate checker and scoreboard.
- UVM environment connections.
- Common sequence base and family sequence bases.
- All 61 concrete sequences listed in the test plan.
- Package include order for all current UVM components and sequences.
- Compile-safe top-level testbench shell.
- Reusable base UVM test.

Not completed:

- Actual DUT binding in the top-level testbench.
- Concrete UVM test classes that start the sequences.
- Subscriber and functional coverage.
- Simulator-specific compile and run targets.
- Regression execution and coverage reports.
- Bug reports and final sign-off.

The current source package compiles with Cadence Xcelium with zero errors.
The unused include-directory warning is expected while the top-level and RTL
filelist are not connected.

## 3. Specification Contract

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

### 3.2 Timing and Reset

- The BMU has one-cycle registered result behavior.
- `result_ff` captures the calculated result when `valid_in=1`.
- `result_ff` holds its previous value when `valid_in=0`.
- `error` is live and combinational; it does not hold when `valid_in=0`.
- `rst_l=0` is a synchronous reset that clears `result_ff` and `error`.
- `scan_mode` has no functional effect and is normally driven low.

### 3.3 Documented Operations

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

### 3.4 Guard Rules

Each operation must have exactly one valid primary operation selection.
Conflicting operation fields force `result=0` and `error=1`.

The following are also errors:

- A bit-manipulation operation combined with `csr_ren_in=1`.
- `SH2ADD` without `ap.zba=1`.
- Plain `SUB` with `ap.zba=1`.
- `SLT` or `MAX` without the required `ap.sub` co-requisite.
- A GREV request with an encoding other than 24.
- Any unsupported or invalid control combination.

CSR bypass read is a valid independent mode when `csr_ren_in=1` and all
`ap` fields are clear.

## 4. Adopted Assumptions

These are from Specification v1.2 Section 7 and must remain visibly separate
from confirmed behavior:

- GREV with `b_in[4:0] != 24` returns zero and asserts `error`.
- CSR conflict logic is scoped to an active operation. A CSR read with no
  active BMU operation remains valid.

If the design/spec owner changes either assumption, update the clarification
log, reference model, affected sequences, and test-plan traceability together.

## 5. UVM Architecture

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

The monitor publishes one transaction per clock. Repeated transactions must
not be suppressed because hold behavior, back-to-back operations, reset, and
live `error` are all meaningful.

The reference model calculates expected behavior from the specification only.
It does not import, call, inspect, or copy RTL behavior.

The scoreboard aligns actual and expected streams. The checker compares
`result_ff` and `error`. Keep these responsibilities separate.

## 6. Important Files

| File or folder | Responsibility |
|---|---|
| `tb/packages/bmu_types_package.sv` | Specification-owned `bmu_ctrl_t`. |
| `tb/interface/bmu_interface.sv` | DUT pins and clocking blocks. |
| `tb/packages/bmu_pkg.sv` | UVM package and include order. |
| `tb/env/agents/bmu_agent/` | Sequence item, sequencer, driver, monitor, agent. |
| `tb/env/reference_model/` | Independent expected-value model. |
| `tb/env/scoreboard/` | Stream alignment and output checker. |
| `tb/env/bmu_environment.sv` | Component construction and connections. |
| `tb/sequences/base/` | Common base and plan-level base sequences. |
| `tb/sequences/*/` | Concrete sequences grouped by operation family. |
| `tb/tests/` | Base test and future concrete UVM tests. |
| `tb/top/` | Clock, interface, UVM startup, and future DUT binding. |
| `sim/filelists/` | Simulator source ordering. |

## 7. Sequence Inventory

There are 61 concrete sequences. They are grouped in these folders:

- `base/` — SUB, SLT, and random sequences.
- `logic_ops/` — OR and XOR.
- `shift_ops/` — SRL, SRA, and ROR.
- `bit_ops/` — BINV.
- `count_ops/` — CTZ and CPOP.
- `sign_extend_ops/` — SEXT.B.
- `minmax_ops/` — MAX.
- `pack_ops/` — PACK and GREV.
- `csr_ops/` — CSR read, CSR write, and CSR conflict.
- `zba_ops/` — SH2ADD.
- `error_injection/` — guard and conflict violations.
- `reset_ops/` — latency, valid gating, reset, and scan behavior.

New sequences must extend the correct family base, use the sequence-item
helpers, and map to a test-plan ID.

## 8. Compile Check

Run this from the repository root:

```bash
rm -rf xcelium.d INCA_libs
xrun -64bit -uvm -sv -compile \
  -incdir tb/include \
  -incdir tb/interface \
  tb/packages/bmu_types_package.sv \
  tb/interface/bmu_interface.sv \
  tb/packages/bmu_pkg.sv
```

This checks the complete package and all current sequences. It does not run a
test because the DUT top-level binding and UVM tests are not implemented yet.

## 9. Next Implementation Steps

1. Confirm the design-team DUT module name and port connection from the actual
  integration environment. Do not infer them from RTL source.
2. Add the DUT instance to `tb/top/bmu_tb_top.sv` after that interface is
  confirmed.
3. Add the first concrete UVM test in `tb/tests/` and start one directed OR
  sequence from the base test.
4. Add test classes that map the 61 sequences to the test-plan IDs.
5. Add the subscriber and functional coverage only after transactions run.
6. Complete simulator-specific commands in `sim/Makefile` and filelists.
7. Run directed, corner, error, timing, reset, CSR, and random regressions.
8. Record failures in `docs/04_bug_reports/` and track clarification changes.
9. Close coverage and complete the sign-off documents.

## 10. Working Rules

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
- Do not commit RTL, confidential specifications, simulator databases, or
  generated reports unless the project documentation explicitly requires it.