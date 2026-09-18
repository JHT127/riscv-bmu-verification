# Verification Sign-off Index

The final status report for this project is kept in
[BMU_Signoff_Report.md](BMU_Signoff_Report.md).

## Standard sign-off checklist

- [ ] All in-scope features have a mapping to at least one executable test
- [ ] All required functional coverage bins are closed, or explicitly waived with justification
- [ ] No open Critical/Major bugs remain without written disposition
- [ ] Clarifications are resolved or accepted as project risk with explicit rationale
- [ ] The full regression is run with reproducible seeds and recorded logs
- [ ] The reference model and expected values are reviewed against the specification understanding in the repository
- [ ] Final project status is captured in the signed report, not inferred from a partial run

## Current project status

At the current repository state, the project is not ready for final sign-off.
The repo contains real verified bug evidence and open runtime findings. The
dedicated coverage closure test reaches 100% functional coverage, but the DUT
still fails directed, random, and guard-based checks, so this is not an RTL
sign-off claim.

## Summary table

| Metric | Target | Current status |
|---|---|---|
| Functional coverage | 100% on supported in-scope legal behavior | Achieved by closure test |
| Code coverage | Maximize and document exclusions | Not yet closed |
| Regression pass rate | 100% | Not yet achieved |
| Critical/Major bugs open | 0 | Open DUT findings remain |
| Clarifications open | 0 or accepted project risk | Assumptions accepted with risk tags |

> This project is acceptable for a formal bug-triage and closure package, but not for a final sign-off claim until the open DUT findings are fixed or formally accepted by the responsible design authority.
