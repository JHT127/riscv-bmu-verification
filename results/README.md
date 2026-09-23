# Verification Results

| Location | Contents |
|---|---|
| `bugs/BMU-BUG-NNN.txt` | One isolated evidence extract per active defect |
| `reports/regression_summary.csv` | Requested/effective seeds, status, comparisons, failures, and functional coverage |
| `reports/run_manifest.json` | Source commit, exact file hashes, run set, and log hashes |
| `reports/functional_coverage.txt` | IMC covered-bin count |
| `reports/functional_coverage_holes.txt` | IMC uncovered-bin report |
| `reports/dut_coverage.txt` | DUT hierarchy structural coverage |
| `reports/assertion_coverage.txt` | Detailed assertion counters |
| `logs/`, `coverage/` | Generated raw logs and simulator databases; ignored by Git |

Reproduce the retained results with `make -C sim regression`, followed by `imc -exec sim/scripts/report_coverage.tcl` from the repository root. The first command reports failure because the original DUT has open bugs; it still produces the result summary.

Raw logs are regenerated locally. The committed bug extracts retain complete inputs, expected/actual values, simulation timestamps, and the source-log hash. See the [bug log](../docs/04_bug_reports/BMU_Bug_Log.md) for specification references and disposition.
