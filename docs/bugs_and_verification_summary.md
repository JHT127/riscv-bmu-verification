# bug and verification summary

## project status

The repository is a UVM BMU verification project with a partially implemented directed suite and a larger planned gap list. The first runtime pass shows that the delivered DUT still violates the current specification assumptions.

## confirmed findings from runtime execution

The following issues were reproduced on the delivered RTL with the provided Xcelium toolchain:

- multi-primary conflict rejection is not enforced
- CPOP width mismatch for top-half bits was observed
- PACK ordering mismatch was observed
- CSR write source mismatch was observed
- GREV byte ordering mismatch was observed
- SLT without SUB and MAX without SUB were not rejected
- empty or stray invalid requests are not rejected consistently
- CTZ root cause for one-hot inputs remains open

These are consistent with the documented bug log and are still open in the project.

## what was added

- explicit dedicated gap-plan sequence classes for each planned ID in `tb/sequences/smoke/bmu_gap_plan_sequences.sv`
- explicit test wrappers for each gap-plan sequence in `tb/tests/bmu_gap_plan_tests.sv`
- package inclusion updates in `tb/packages/bmu_pkg.sv`

## verification command evidence

The project is not passing cleanly on the current DUT. The proving command was:

```bash
cd /home/Trainee11/bmu-project/BMU-verification/sim && make run TEST=bmu_nominal_directed_test SEED=1 VERBOSITY=UVM_HIGH
```

This produced 7 UVM scoreboard errors and 3 assertion failures, with the summary ending in a non-zero exit.

## conclusion

This is a pre-closure DV state, not a final sign-off state. The repository includes the verification infrastructure and runtime evidence, but the delivered RTL still has open findings that must be fixed or formally accepted before sign-off.
