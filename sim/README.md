# Simulation

This folder holds the Xcelium entry points used to compile and run the UVM
environment against the delivered DUT RTL in [`../rtl/`](../rtl/).

## Layout

```text
sim/
├── Makefile              Top-level entry point (compile / run / regress)
├── filelists/             Per-simulator .f filelists (rtl + tb sources)
└── scripts/
    ├── run_test.sh        Run a single UVM test
    └── run_regression.sh  Run the full regression suite from regression/configs/
```

## Usage

```bash
# Compile the RTL and UVM environment
make compile

# Run the concrete smoke test
make TEST=bmu_or_valid_test SEED=1 VERBOSITY=UVM_HIGH

# Full regression
make regression

# Clean sim artifacts
make clean
```

The checked-in configuration supports Cadence Xcelium `xrun(64) 25.03-s006`.
The default simulator is `xcelium`, and the source order is controlled by
[`filelists/xcelium.f`](filelists/xcelium.f). VCS and Questa are not configured
in this baseline and fail with an explicit Makefile error rather than running
placeholder commands.

Compile and run logs are written under `../results/logs/`. The smoke test must
show a scoreboard `result and error match` message at `UVM_HIGH`; a zero-exit
simulator process without a scoreboard comparison is not sufficient evidence.
