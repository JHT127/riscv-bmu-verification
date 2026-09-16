# Changelog

All notable changes to this project are documented here.
Format loosely follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Initial professional repository scaffold: docs structure, UVM
  testbench directory layout, sim/regression/results/waveforms folders.
- Spec clarifications log (`docs/03_clarifications_log/`) seeded with
  the first five clarification items raised during spec review.
- `.gitignore` tuned for UVM/simulator artifacts and confidential
  spec/RTL exclusion.
- Issue templates for bug reports and TB feature requests.
- Markdown-lint CI workflow.

### Planned
- Verification plan (Excel) — `docs/01_verification_plan/`
- Test plan (Excel) — `docs/02_test_plan/`
- Reference model implementation — `tb/env/reference_model/`
- Directed sequences per operation family
- Functional coverage model
- First regression run + coverage report
- Bug log population
- Final presentation + sign-off report
