# Regression

- `configs/` — regression suite definitions consumed by
  `sim/scripts/run_regression.sh`. Add one config per suite (e.g.
  `nightly.cfg`, `smoke.cfg`, `full.cfg`).
- `logs/` — raw per-run logs (gitignored; summaries go to
  `results/reports/` instead, which *is* versioned).
