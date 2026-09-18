# Training Verification Workflow

## Goal and scope

This document defines the professional verification workflow for this BMU training project. The project is not a real sign-off exercise and must not be represented as final design sign-off. The objective is to execute a DV-quality workflow, maintain traceability, and stop at a professional pre-closure assessment with documented residual risk.

## Step 1: Confirm scope and requirements

- Confirm the specification scope and list the in-scope BMU operations.
- Exclude unsupported Section 8 behavior from the verification scope.
- Record the supported legal domain separately from unsupported or assumption-dependent behavior.

Acceptance:
- A written list of in-scope features exists.
- Unsupported features are explicitly marked out of scope.

## Step 2: Build the traceability matrix

- Map each requirement or plan row to a test, stimulus, and evidence item.
- Record test ID, requirement, sequence, seed, log path, coverage bin, and bug status.
- Do not treat a broad smoke run as equivalent to a plan row execution.

Acceptance:
- Every requirement is traceable to either a test or a documented waiver.

## Step 3: Implement executable tests for the plan rows

- Convert every plan row into a concrete UVM test or sequence class.
- Use direct sequence classes for single-purpose checks and keep them named by their ID.
- Preserve the plan row identity in the test class and log text.

Acceptance:
- Each mandatory plan row has a concrete executable test or an explicit reason for exclusion.

## Step 4: Separate directed, boundary, and error checks

- Directed-valid checks prove successful operation under legal combinations.
- Directed-boundary checks exercise min/max, zero, all-one, and one-hot corner values.
- Directed-error checks prove invalid control combinations assert `error` and clear `result`.

Acceptance:
- The suite is readable to a reviewer and is grouped by behavior class.

## Step 5: Add seeded randomized verification

- Run legal, corner, and invalid random tests with fixed seeds.
- Preserve the same seed and log path for reproducibility.
- Treat random runs as a supplement to directed bugs and coverage, not a substitute.

Acceptance:
- Each random regression has a fixed seed and a stored result log.

## Step 6: Add coverage collection and report evidence

- Run each relevant suite with coverage enabled.
- Store coverage databases under `results/coverage/`.
- Do not create a final coverage claim without a raw database and a documented report.

Acceptance:
- Coverage evidence exists for each run and is traceable to the executed test.

## Step 7: Record bug evidence and avoid silent model changes

- Log each mismatch as a bug or assumption issue.
- Retain the seed, test, log, expected value, and actual value.
- Do not silently change the reference model to match the DUT.

Acceptance:
- Every mismatch has a bug or risk record with evidence.

## Step 8: Document exclusions and assumptions

- Record unsupported features, Section 8 gaps, and scan-only behavior.
- Tag assumption-dependent behavior explicitly.
- Treat project-risk acceptance as a documented risk, not as design approval.

Acceptance:
- All non-scope or assumption-dependent items are listed in a waiver or clarification document.

## Step 9: Stop at pre-closure, not final sign-off

- Produce a pre-closure package with traceability, evidence, open findings, and residual risk.
- Present the status honestly.
- Do not claim final sign-off unless the design owner formally accepts the risk and relevant fixes are complete.

Acceptance:
- The project outcome is clearly labeled as pre-closure or verification-ready, not sign-off complete.

## Current project training status

This repository currently has:

- aggregate smoke and regression tests,
- directed and random suites,
- coverage-enabled runs,
- bug and waiver documents,
- a pre-closure status package.

It does not yet have a complete, plan-row-by-plan-row executable matrix for every single original plan ID. That is the current training backlog and should be tracked as such.
