# BMU Bug Documentation

## 1. Purpose

This document is the expert bug register for the BMU verification project. It is intended as a spreadsheet-style defect ledger with traceability to specification, reproducer, evidence logs, and closure state.

The records below are based on specification-driven runtime evidence. A bug is not closed by a code review or by a local patch; it must be reproduced, compared against the independent reference model, and retested against the revised DUT or formally accepted.

## 2. Definitions

- Severity: Critical, Major, Minor
- Status: Open, Withdrawn, Accepted, Fixed
- Evidence: scoreboard output, log file, waveform, or test-case run
- Closure gate: requires reproducer, expected value, actual result, and retest evidence

## 3. Defect register

| Bug ID | Severity | Area | Spec Rule / Requirement | Reproducer | Expected Result | Actual Result | Evidence | Status | Closure Gate |
|---|---|---|---|---|---|---|---|---|---|
| BMU-BUG-001 | Major | CPOP | Count all 32 bits of a_in | TC_CPOP_004 with a_in=0xFFFF0000 | result=32, error=0 | partial or wrong count | log + scoreboard | Open | reproducer + retest |
| BMU-BUG-002 | Major | PACK | result = {b_in[15:0], a_in[15:0]} | ap.pack=1; a_in=0x12345678; b_in=0x9ABCDEF0 | 0xDEF01234 or equivalent spec-defined ordering | reversed order | log + scoreboard | Open | reproducer + retest |
| BMU-BUG-003 | Major | CSR write source | csr_imm selects b_in, else a_in | ap.csr_write=1, ap.csr_imm=1, a_in=0x33334444, b_in=0x11112222 | result=b_in | result=a_in or wrong path | log + scoreboard | Open | reproducer + retest |
| BMU-BUG-005 | Major | GREV | GREV byte ordering for b_in[4:0]=24 | ap.grev=1, b_in=24, a_in=0x12345678 | byte-reversed output | byte ordering incorrect | log + scoreboard | Open | reproducer + retest |
| BMU-BUG-006 | Critical | Invalid controls | exactly one valid primary op; conflicts must error | empty request, stray zbb, stray zba, multi-op conflicts | result=0, error=1 | invalid paths accepted | log + assertion output | Open | reproducer + retest |
| BMU-BUG-007 | Major | SLT/MAX co-requisite | slt/max require ap.sub=1 | ap.slt=1, ap.sub=0 and ap.max=1, ap.sub=0 | result=0, error=1 | operation proceeds with no error | log + assertion output | Open | reproducer + retest |
| BMU-BUG-008 | Major | GREV invalid encoding | invalid GREV encodings must assert error | ap.grev=1, b_in[4:0]=5 | result=0, error=1 | undefined path not rejected | log + scoreboard | Open | reproducer + retest |
| BMU-BUG-009 | Major | CTZ | CTZ(0)=32; trailing-zero count across all bits | a_in=1 << n for n=0..31 | return n; zero returns 32 | mismatch at one-hot positions | log + scoreboard | Open | reproducer + retest |

## 4. Runtime evidence summary

| Run | Seed | Observed Result | Evidence Path | Notes |
|---|---:|---|---|---|
| bmu_gap_checks_test | 1 | 131 matches, 41 mismatches | results/logs/bmu_gap_checks_test_1.log | gap-target defects reproduced |
| bmu_nominal_directed_test | 1 | 7 mismatches | results/logs/bmu_nominal_directed_test_1.log | nominal valid mismatches |
| bmu_error_directed_test | 1 | 7 mismatches | results/logs/bmu_error_directed_test_1.log | invalid-control mismatches |
| bmu_legal_random_test | 101 | 45 mismatches | results/logs/bmu_legal_random_test_101.log | legal random mismatch burst |
| bmu_corner_random_test | 201 | 18 mismatches | results/logs/bmu_corner_random_test_201.log | boundary mismatches |
| bmu_error_random_test | 301 | 84 mismatches | results/logs/bmu_error_random_test_301.log | invalid guard mismatch burst |
| bmu_coverage_closure_test | 4 | functional coverage=100.00% | results/logs/bmu_coverage_closure_test_4.log | coverage success only for supported legal model |

## 5. Detailed bug rationale

### BMU-BUG-006: invalid and conflicting controls are accepted
- Root cause: guard logic does not reject empty or stray-control requests.
- Risk: unsafe operation may pass into the datapath.
- Required fix: enforce single-primary-op decode and co-requisite validation before result generation.

### BMU-BUG-007: SLT/MAX missing co-requisite guarding
- Root cause: comparison path does not enforce ap.sub before evaluating slt/max.
- Risk: legal comparison semantics are violated and invalid control combinations can pass.
- Required fix: assert error when ap.sub is not asserted for these operations.

### BMU-BUG-009: CTZ bit-position mismatch
- Root cause: target bit position is not mapped consistently for one-hot inputs.
- Risk: trailing-zero counts are incorrect for many legal operands.
- Required fix: resolve complete 32-bit trailing-zero logic and the CTZ(0)=32 rule.

## 6. Bug disposition rules

For every defect, the disposition record must include:
- bug ID
- status
- owner or responsible design team
- test-case reproducer
- expected and actual values
- bug-review decision
- retest on revised RTL or accepted-risk decision
- final closure signoff

If the design owner accepts the behavior as intentional, the bug is moved to Accepted or Accepted project risk and must be annotated with the exact source of approval.

## 7. Closure gate

The project is not ready for final sign-off while any of the following remain open:
- BMU-BUG-001
- BMU-BUG-002
- BMU-BUG-003
- BMU-BUG-005
- BMU-BUG-006
- BMU-BUG-007
- BMU-BUG-008
- BMU-BUG-009

The repository remains in a professional pre-closure state: the defects are reproduced and documented, but the RTL has not yet been fixed or accepted by the design authority.
