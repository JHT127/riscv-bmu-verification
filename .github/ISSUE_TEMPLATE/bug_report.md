---
name: DUT Bug Report
about: Report a discrepancy between DUT behavior and the reference model / spec
title: "[BUG] "
labels: bug
assignees: ''
---

## Summary

<!-- One-sentence description of the discrepancy -->

## Operation / Instruction

<!-- e.g. CTZ, GREV, SH2ADD, CSR bypass read -->

## Severity

- [ ] Critical (functional failure, blocks sign-off)
- [ ] Major (incorrect result under specific conditions)
- [ ] Minor (cosmetic / edge case with low functional impact)
- [ ] Spec ambiguity (not clearly a bug — needs clarification first)

## Steps to Reproduce

```text
// Stimulus (control fields + operands)
a_in       =
b_in       =
ap.<field> =
csr_ren_in =
valid_in   =
```

## Expected Result (per reference model / spec)

```text
result =
error  =
```

## Actual Result (from RTL simulation)

```text
result =
error  =
```

## Waveform / Log Reference

<!-- Path under waveforms/ or results/logs/, plus sim time -->

## Additional Notes

<!-- Related clarification log entry (CLARIF-XXX) if applicable -->
