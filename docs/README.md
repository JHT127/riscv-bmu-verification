# Documentation Index

| Folder | Purpose |
|---|---|
| [`00_spec/`](00_spec) | Approved BMU specification and related notes |
| [`01_verification_plan/`](01_verification_plan) | Verification strategy, environment architecture, and plan for the training project |
| [`02_test_plan/`](02_test_plan) | Test list, stimulus, expected results, and traceability across the bug-finding work |
| [`03_clarifications_log/`](03_clarifications_log) | Spec ambiguities raised during verification and the recorded project assumptions |
| [`04_bug_reports/`](04_bug_reports) | Bug log and supporting evidence for runtime-confirmed defects |
| [`05_presentation/`](05_presentation) | Project walkthrough, findings summary, and results presentation |
| [`06_architecture_diagrams/`](06_architecture_diagrams) | Block diagrams and verification architecture views |
| [`07_coverage_reports/`](07_coverage_reports) | Narrative coverage analysis, waivers, and summary interpretation for the training exercise |
| [`08_signoff/`](08_signoff) | Training verification summary and closure record, not a production sign-off package |

The numbered structure mirrors the working flow of the project: spec understanding
→ planning → execution → bug capture → coverage review → final training summary.

Important rule: the folders under `docs/` hold the reviewable project narrative and interpretation, while generated runtime evidence and machine-readable artifacts live under `results/` and are not duplicated in the documentation tree. For coverage specifically, the canonical generated outputs are in `results/coverage/` and `results/reports/`; the files in `docs/07_coverage_reports/` explain and interpret them.

This repository is intentionally structured for bug discovery and documentation. It is not a production RTL sign-off package, and it does not require a fixed DUT revision.
