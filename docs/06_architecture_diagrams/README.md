# Architecture Diagrams

This folder holds the generated architecture visuals for the BMU DUT and the verification environment. These assets are intentionally reproducible: they are created from the repository's actual RTL and UVM structure rather than being hand-maintained static pictures.

## Regenerate the assets

Run:

```bash
cd BMU-verification
python3 scripts/generate_diagrams.py
```

This produces PNG exports in this folder and the generator source remains in `scripts/generate_diagrams.py` so future updates stay traceable.

## Current generated assets

- `bmu_dut_block_diagram.png` — top-level BMU DUT block diagram showing the interface signals, core operation groups, and result/error output path.
- `bmu_uvm_environment.png` — UVM environment architecture showing the agent, monitor, reference model, scoreboard, and coverage collector connected to the DUT interface.
- `bmu_coverage_overview.png` — coverage model summary showing the major functional coverage groups and reporting flow.

## Notes

- The current set focuses on the repo-relevant architecture and coverage view that is needed for engineering handoff and review.
- If a new DUT block or environment feature is added, update the generator script and regenerate the PNGs rather than editing the binaries directly.
- Additional timing-diagram views can be added later if the project needs cycle-accurate waveform annotation.
