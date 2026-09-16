# Testbench (`tb/`)

UVM class-based verification environment. See
[`../docs/06_architecture_diagrams/`](../docs/06_architecture_diagrams)
for the full architecture diagram once added.

| Folder | Role |
|---|---|
| `top/` | Top-level TB module: clock/reset generation, DUT + interface instantiation, UVM run |
| `interface/` | SystemVerilog interface(s) connecting the TB to DUT ports |
| `include/` | Global macros/defines (`uvm_def.sv`, etc.) |
| `packages/` | UVM package(s) — import order and compile glue |
| `env/agents/bmu_agent/` | Driver, monitor, sequencer for the BMU pin-level interface |
| `env/reference_model/` | Independent, spec-driven golden model (see repo root README — built from spec, not RTL) |
| `env/scoreboard/` | Compares DUT transactions against the reference model |
| `env/coverage/` | Functional coverage collector(s) |
| `sequences/*` | One folder per operation family — keeps directed + randomized stimulus organized the same way the spec is organized |
| `tests/` | Top-level UVM test classes (assemble env + sequences + config) |

## Adding a new sequence

1. Create it under the matching `sequences/<family>/` folder.
2. Extend the base sequence in `sequences/base/`.
3. Reference it from a test in `tests/`.
4. Add its coverage goal to the test plan
   (`docs/02_test_plan/`) and, if it closes a new bin, note it in
   `env/coverage/`.
