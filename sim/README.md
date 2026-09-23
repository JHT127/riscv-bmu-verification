# Simulation

The default flow compiles the delivered DUT and UVM testbench with Xcelium. Run commands from the repository root:

```bash
make -C sim compile
make -C sim run TEST=bmu_model_self_test SEED=1
make -C sim run TEST=bmu_or_valid_test SEED=1 VERBOSITY=UVM_HIGH
make -C sim regression
make -C sim regression CONFIG=../regression/configs/bugs.cfg
make -C sim waves TEST=bmu_or_valid_test SEED=1
imc -exec sim/scripts/report_coverage.tcl
```

`sim/filelists/xcelium.f` controls source order. `TOP=bmu_tb_top` prevents unused library modules from becoming extra roots. Xcelium receives `-svseed`; `TIMEOUT` defaults to 1,000,000 ns through UVM's timeout plusarg.

Single tests fail on UVM errors/fatals, native simulator/assertion errors, missing completion, or unmatched/no-stimulus scoreboard activity. The full regression continues collecting failures and exits nonzero if any test fails. Known DUT bugs are never demoted to passes.

Raw logs and per-test/seed coverage databases are generated under `results/logs/` and `results/coverage/`. Repeating the same test/seed replaces its log and current seeded run data. Retain or copy evidence before comparing revisions. The full regression regenerates the summary CSV, source/log manifest, and isolated bug extracts.

Waveform capture creates `waveforms/<test>_<seed>.shm`. It uses the same result checking as a normal run, so a bug reproducer still returns failure after saving its waveform.

The separate `xcelium_fix.f` and fixed top are exploratory and are not used in submission results. VCS and Questa are not supported by this Makefile.
