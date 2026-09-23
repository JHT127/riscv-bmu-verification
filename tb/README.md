# UVM Testbench

## Components

- `bmu_sequence_item`: request controls, operands, CSR data, and sampled outputs.
- `bmu_driver`: drives requests on the falling edge through the interface clocking block.
- `bmu_monitor`: samples requests and post-update outputs on the rising edge.
- `bmu_reference_model`: specification expressions and stateful result hold/reset.
- `bmu_scoreboard` / `bmu_checker`: compare result/error, report complete mismatches, and check pending/no-stimulus conditions.
- `bmu_coverage`: stimulus-based functional bins and crosses.
- `bmu_protocol_assertions`: reset, hold, and guard properties bound to the DUT.

The package includes family sequences, systematic guard/boundary suites, random tests, isolated bug tests, and the predictor self-test. The [test plan](../docs/02_test_plan/BMU_Test_Plan.md) records supported behavior and executable scenarios.

The complete control struct remains driveable for guard testing. Standalone behavior is predicted only for specified operations. The delivered RTL is not used to derive expected values.
