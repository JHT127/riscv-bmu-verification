# Regression

- `configs/` — regression suite definitions consumed by
  `sim/scripts/run_regression.sh`. Add one config per suite (e.g.
  `nightly.cfg`, `directed.cfg`, `gaps.cfg`, `legal_random.cfg`,
  `corner_random.cfg`, `error_random.cfg`, and `full.cfg`).
- `logs/` — raw per-run logs (gitignored; summaries go to
  `results/reports/` instead, which *is* versioned).

The current nightly configuration contains only the concrete smoke test,
`bmu_or_valid_test`, at two seeds. The regression wrapper is structurally
ready, but it is blocked until `sim/Makefile` has real simulator compile/run
commands. The single-test wrapper rejects the current TODO placeholders so a
dry run cannot be recorded as a passing regression.
