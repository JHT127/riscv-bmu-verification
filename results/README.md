# Results

This directory is the canonical place for generated runtime artifacts created by
simulation, regression, and coverage runs.

- `logs/` — raw simulation run logs (gitignored)
- `coverage/` — coverage databases and merged database directories
  (gitignored — binary, tool-specific)
- `reports/` — generated, human-readable summaries (regression pass/fail
  tables, coverage % snapshots, merged coverage summaries) — **these are
  versioned**, since they are small, readable, and tell the project's progress
  story over time
- `bugs/` — extracted defect evidence summaries and context generated from the
  failing log stream

The `docs/` tree should not duplicate these generated outputs. Instead, the docs
explain the meaning of these results and record project interpretation.
