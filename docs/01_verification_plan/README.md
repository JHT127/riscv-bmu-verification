# Verification Plan

The supplied [BMU Verification Plan](BMU_Verification_Plan.pdf) is the original planning baseline. The implemented flow follows the same spec-driven UVM approach.

## Strategy

| Area | Verification method |
|---|---|
| Expected values | Specification expressions; predictor self-test with 865 checks |
| Legal behavior | Directed examples, boundary sweeps, legal and corner random sequences |
| Invalid controls | Per-operation forbidden-bit matrix, missing co-requisites, CSR conflicts |
| Timing and reset | Back-to-back operations, hold, capture-edge check, reset and recovery |
| Protocol | Bound assertions; see [assertion plan](assertion_plan.md) |
| Random exploration | Multiple effective seeds; see [randomization plan](randomization_plan.md) |
| Completion | Test traceability, measured bins, isolated bug evidence, explicit remaining risks |

The monitor sends sampled requests/results to the predictor, scoreboard, and coverage collector. The predictor does not read DUT internals. A scoreboard mismatch requires triage against the specification before being recorded as a DUT bug.

The [test plan](../02_test_plan/BMU_Test_Plan.md) identifies executable scenarios. The [final report](../08_signoff/BMU_Signoff_Report.md) records the submission result. Open DUT bugs are expected for this training exercise and remain visible.
