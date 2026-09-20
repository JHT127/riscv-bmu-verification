# Coverage Reports

This folder contains the human-readable interpretation, waiver record, and
summary narrative for the project’s coverage status. It is not the canonical
storage location for generated regression or coverage artifacts.

Canonical locations:
- `results/coverage/` — raw coverage databases and simulator-generated outputs
- `results/reports/` — generated, readable summary reports and regression snapshots
- `docs/07_coverage_reports/` — reviewable project documentation explaining the
  results, exclusions, and final interpretation

Do not duplicate the generated reports in this folder. If a result is produced by
Xcelium/IMC, it belongs in `results/` unless it is a deliberate source-controlled
summary document that explains the evidence. This keeps the repo from having two
places describing the same runtime evidence.
