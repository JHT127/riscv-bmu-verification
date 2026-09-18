# Bug Reports (Local Log)

The current specification-based DUT review is documented in
[`bug_report_review.md`](bug_report_review.md). Findings remain open until
runtime reproduction, disposition, and retest evidence are recorded.

The implementation-ready Markdown handoff is
[`BMU_Bug_Log.md`](BMU_Bug_Log.md). It contains the nine tracked findings,
the withdrawn CSR-bypass claim, the CTZ finding, reproducers, and closure
evidence requirements.

The team tracks bugs officially in ClickUp. This folder is a personal,
versioned mirror kept alongside the code — useful for the final report,
for showing bug-finding trends over time, and so the repository is
self-contained without needing ClickUp access to understand project
history.

**File to add here:** `BMU_Bug_Log.md` (or `.xlsx`, your call)

## Suggested fields (same shape as the GitHub issue template)

| Bug ID | Operation | Severity | Summary | Status | ClickUp Link | Date Found | Date Resolved |
|---|---|---|---|---|---|---|---|

## Severity definitions

- **Critical** — functional failure, blocks sign-off
- **Major** — incorrect result under specific, plausible conditions
- **Minor** — cosmetic or very low-impact edge case
- **Spec ambiguity** — not confirmed as a bug; tracked in
  [`../03_clarifications_log/`](../03_clarifications_log) until resolved,
  only promoted here if the resolution confirms an actual RTL defect
