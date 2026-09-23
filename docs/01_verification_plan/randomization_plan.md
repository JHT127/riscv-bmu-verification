# Randomization Plan

| Family | Stimulus | Full-regression seeds |
|---|---|---|
| Legal | All 17 specified operation classes; random operands, CSR data, ZBB, SLTU, and CSR write modes | 101, 102, 103 |
| Corner | Independently selected zero, ones, extrema, one, alternating patterns, and 31 for both operands | 201, 202, 203 |
| Invalid | Conflicting operations, CSR conflicts, stray modifiers, missing co-requisites, and unsupported GREV encoding | 301, 302, 303 |

Each run sends 100 generated transactions following reset. Legal generation selects the operation after operand randomization, supplies required fields, and restricts GREV to encoding 24. Directed sweeps and the guard matrix provide systematic coverage beyond random sampling.

Xcelium receives `-svseed`. The regression summary verifies that the effective simulator seed matches the requested seed. Repeated seed 901 produced identical stimulus traces; seed 902 produced a different trace. Preserve the effective seed and source hashes when reproducing a failure.
