# Simulation

This folder holds everything needed to compile and run the UVM
environment against the DUT RTL (RTL itself lives outside this repo —
see [`../rtl/README.md`](../rtl/README.md)).

## Layout

```text
sim/
├── Makefile              Top-level entry point (compile / run / regress)
├── filelists/             Per-simulator .f filelists (rtl + tb sources)
└── scripts/
    ├── run_test.sh        Run a single UVM test
    └── run_regression.sh  Run the full regression suite from regression/configs/
```

## Usage (once a simulator is wired in)

```bash
# Single test
make TEST=dut_reg_test

# Full regression
make regression

# Clean sim artifacts
make clean
```

> **Note:** The `Makefile` here is written simulator-agnostic with
> placeholder variables (`SIMULATOR ?= vcs`). Fill in the actual
> compile/run invocation for whichever simulator you have access to
> (VCS / Questa / Xcelium). Keeping this abstraction means the rest of
> the repo (scripts, CI, docs) doesn't need to change if the simulator
> changes.
