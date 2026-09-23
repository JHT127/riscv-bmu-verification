# BMU Training Verification Report

## 1. Objective and scope

Find, reproduce, and document bugs in the delivered BMU using the supplied specification. The original DUT is unchanged; exploratory fixed sources are excluded from the default flow.

## 2. Submission result

The full regression completed 26 runs on 22 September 2026: three passing checks and 23 failing DUT tests, with zero UVM fatals. Passing checks are the 865-case predictor self-test, OR smoke, and timing/reset suite.

Nine DUT bugs have isolated reproducers and retained complete failing transactions. They cover CPOP, PACK, CSR write selection, GREV ordering, invalid controls, missing SUB co-requisites, invalid GREV encoding, CTZ, and MAX selection. See the [canonical bug log](../04_bug_reports/BMU_Bug_Log.md).

The corrected coverage model reaches 562/562 functional bins. DUT hierarchy block/expression coverage is 100% under current instrumentation; toggle coverage is 65.01%. These measurements demonstrate exercised scenarios, not DUT correctness. [Coverage details](../07_coverage_reports/final_coverage_summary.md).

## 3. Evidence

- [Executed test results](../../results/reports/regression_summary.csv)
- [Source/configuration and log hashes](../../results/reports/run_manifest.json)
- [Isolated bug evidence](../../results/bugs)
- [Test traceability](../02_test_plan/traceability_matrix.md)

## 4. Remaining risks

- All nine recorded DUT findings remain open on the delivered RTL.
- Timing/scan, GREV undefined encoding, and CSR conflict interpretations retain the documented project assumptions.
- Standalone undocumented operations and scan-chain behavior are outside scope.
- Uncovered toggles remain; no structural maximum or production sign-off is claimed.

The training submission demonstrates spec-driven testing, checker validation, systematic and random stimulus, measured coverage, and reproducible bug reporting. A design fix must be supplied and retested before any DUT defect is closed.
