# Verification Plan

**File to add here:** `BMU_Verification_Plan.xlsx`

## Recommended sheet structure

| Sheet | Contents |
|---|---|
| `Overview` | DUT summary, verification scope, methodology, entry/exit criteria |
| `Features` | Every feature to verify (one row per operation + per cross-cutting concern: reset, valid_in gating, error conditions, CSR bypass), each mapped to a verification technique (directed / constrained-random / assertion) |
| `Env Architecture` | Agents, reference model, scoreboard, coverage model summary |
| `Risk Areas` | Items from the clarifications log that carry verification risk until resolved (e.g. CLARIF-004, CLARIF-005) |
| `Coverage Plan` | Functional coverage groups/crosses per feature |
| `Schedule` | Milestones mapped against the test plan |

> Keep this plan a **superset** of the test plan — the verification
> plan says *what* needs confidence and *how* (coverage-driven), the
> test plan says *which specific tests* deliver that confidence.
