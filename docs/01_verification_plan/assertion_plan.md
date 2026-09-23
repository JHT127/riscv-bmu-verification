# Assertion Plan

Assertions are bound to the DUT through the Xcelium filelist.

| Property | Requirement |
|---|---|
| `reset_suppresses_error` | Error is zero under reset |
| `reset_clears_result` | Reset clears the registered result |
| `result_holds_when_invalid` | Result remains stable while valid is low |
| `valid_result_is_registered` | A valid capture produces a known result |
| `one_primary_operation` | Conflicting primary controls assert error |
| `empty_valid_request` | An empty valid request asserts error |
| `live_error_when_invalid` | Invalid controls update error even while valid is low |
| `csr_conflict` | CSR read plus any control field asserts error |
| `sh2add_requires_zba` | SH2ADD requires ZBA |
| `sub_rejects_zba` | SUB with ZBA is invalid |
| `slt_requires_sub` | SLT requires SUB |
| `max_requires_sub` | MAX requires SUB |
| `grev_encoding` | Non-24 GREV encoding is invalid under CLARIF-004 |

SUB is counted independently only when SLT/MAX are absent. Mode bits are not additional primary operations. Exact data and full forbidden-field masks are checked by the predictor/scoreboard.

The latency sequence separately checks that the result does not change before the capture edge. The “registered” assertion alone only checks for known data.

Native assertion errors fail the runner even if the UVM error count is zero. [Retained assertion evidence](../../results/reports/assertion_coverage.txt) reports tool counters; a coverage grade is not an assertion pass rate.
