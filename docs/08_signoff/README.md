# Training Verification Index

The project summary for this repository is kept in
[BMU_Signoff_Report.md](BMU_Signoff_Report.md).

## Training objective

This repository is intended to do the following:

- find and reproduce DUT bugs against the specification
- record the failure evidence in a clear and traceable way
- document the supported legal coverage model and the remaining known issues
- keep the delivered RTL in its original buggy state for training purposes

This is a training verification package, not a production release sign-off package.

## Current project status

At the current repository state, the DUT remains intentionally buggy and the project remains in the bug-discovery stage.
The repo contains verified runtime findings, coverage evidence, and a documented issue log. The dedicated coverage closure test reaches 100% functional coverage on the supported in-scope legal model, but the open failures are retained as formal training evidence rather than being fixed or waived.

## Summary table

| Metric | Training target | Current status |
|---|---|---|
| Functional coverage | Close the supported legal bug-finding model | Achieved by closure test |
| Bug reproduction | Confirm and document real failures | Achieved |
| Regression evidence | Record reproducible results | Achieved |
| RTL repair | Not required for this project | Intentionally not performed |
| Design sign-off | Not part of the training objective | Not applicable |
| Clarifications | Record assumptions and risk | Documented |

> This project is appropriate for a training bug-triage and verification package. It is not intended to become a final design sign-off claim or a corrected DUT handoff.
