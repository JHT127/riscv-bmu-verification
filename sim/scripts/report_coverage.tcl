# Run from the repository root after the full regression.
load -run results/coverage/bmu_coverage_closure_test_4/scope/test_sv4
report -summary -metrics all -both -cumulative on -inst bmu_tb_top.dut -out results/reports/dut_coverage.txt
report -detail -metrics covergroup -uncovered -inst *... -out results/reports/functional_coverage_holes.txt
report -summary -metrics covergroup -both -inst *... -out results/reports/functional_coverage.txt
report -detail -metrics assertion -both -allAssertionCounters -inst bmu_tb_top.dut.protocol_assertions_i -out results/reports/assertion_coverage.txt
