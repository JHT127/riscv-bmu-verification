# BMU Test Plan

## 1. Purpose

This document is the executable verification matrix for the BMU DUT. It is written as a spreadsheet-style handoff for direct test authoring, regression tracking, and coverage traceability.

The test plan is based on the current specification, clarification log, and independent reference model. It is intentionally focused on legal in-scope behavior, guard conditions, reset/timing behavior, and bug reproduction coverage.

## 2. Scope and assumptions

### In-scope behavior
- OR, XOR, and ZBB-inverted modes
- SRL, SRA, and ROR
- BINV
- SH2ADD and ZBA gating
- SUB, SLT, SLTU, and MAX
- CTZ and CPOP
- SEXT.B
- PACK
- GREV with the supported encoding 24 only
- CSR bypass read and CSR write
- result latency, valid gating, reset, and scan behavior
- invalid/control-conflict detection

### Out of scope
- unsupported Section 8 fields: CLZ, ROL, PACKU, PACKH, BSET, BCLR, BEXT, GORC, etc.
- undocumented or unconfirmed legal cases outside the written specification

## 3. Test execution rules

- Every row must have a reproducible input vector, expected result, and log reference.
- Every failing row must be linked to a bug ID or accepted-risk note.
- Every test row must map to a coverage bin, sequence name, or regression bucket.
- No RTL change is allowed to close a bug; the DUT is evaluated as-is.

## 4. Test matrix

| Test ID | Category | DUT Function | Stimulus Pattern | Input / Control Fields | Expected Result | Error Expectation | Coverage Target | Status | Evidence File |
|---|---|---|---|---|---|---|---|---|---|
| TP-001 | Directed-valid | OR | legal OR with no ZBB | a_in=0x12345678, b_in=0x0F0F0F0F, ap.lor=1 | result = a_in | 0 | OR bin | Planned | log TBD |
| TP-002 | Directed-valid | OR + ZBB invert | OR with inversion enabled | ap.lor=1, ap.zbb=1, b_in=~b_in | result = a_in | 0 | OR x ZBB | Planned | log TBD |
| TP-003 | Directed-valid | XOR | legal XOR | a_in, b_in random, ap.lxor=1 | result = a_in ^ b_in | 0 | XOR bin | Planned | log TBD |
| TP-004 | Directed-valid | XOR + ZBB invert | XOR with invert path | ap.lxor=1, ap.zbb=1 | correct inverted XOR | 0 | XOR x ZBB | Planned | log TBD |
| TP-005 | Directed-valid | SRL | shift right logical | a_in=0x80000000, b_in[4:0]=5 | result = 0x04000000 | 0 | shift amount bins | Planned | log TBD |
| TP-006 | Directed-valid | SRA | arithmetic shift right | a_in=0x80000000, b_in=5'd1 | result = 0xC0000000 | 0 | shift amount bins | Planned | log TBD |
| TP-007 | Directed-valid | ROR | rotate right | a_in=0x00000001, b_in=5'd1 | result=0x80000000 | 0 | rotate bins | Planned | log TBD |
| TP-008 | Directed-valid | BINV | invert a single selected bit | a_in=0xFFFFFFFF, b_in=5'd7 | result toggles bit 7 only | 0 | BINV 0..31 | Planned | log TBD |
| TP-009 | Directed-valid | SH2ADD | ZBA legal mode | ap.sh2add=1, ap.zba=1 | result = (a_in << 2) + b_in | 0 | ZBA legal bin | Planned | log TBD |
| TP-010 | Directed-valid | SUB | arithmetic subtract | a_in=0x00000010, b_in=0x00000003 | result = 13 | 0 | SUB bin | Planned | log TBD |
| TP-011 | Directed-valid | SLT signed | signed compare | a_in=0x80000000, b_in=0x7FFFFFFF, ap.slt=1, ap.sub=1 | signed compare result | 0 | SLT signed bin | Planned | log TBD |
| TP-012 | Directed-valid | SLTU unsigned | unsigned compare | ap.slt=1, ap.unsign=1 | correct unsigned ordering | 0 | SLT unsigned bin | Planned | log TBD |
| TP-013 | Directed-valid | MAX signed | signed max selection | ap.max=1, ap.sub=1 | max(a_in,b_in) | 0 | MAX signed bin | Planned | log TBD |
| TP-014 | Directed-valid | MAX unsigned | unsigned max selection | ap.max=1, ap.sub=1, ap.unsign=1 | max unsigned | 0 | MAX unsigned bin | Planned | log TBD |
| TP-015 | Directed-valid | CTZ | trailing zero count | a_in = 1 << bit_n | result = bit_n | 0 | CTZ 0..31 | Planned | log TBD |
| TP-016 | Directed-valid | CTZ zero case | zero operand | a_in=0 | result=32 | 0 | CTZ(0)=32 | Planned | log TBD |
| TP-017 | Directed-valid | CPOP | set-bit count | a_in=0xF0F0F0F0 | result=16 | 0 | CPOP bins | Planned | log TBD |
| TP-018 | Directed-valid | SEXT.B | sign extend byte | a_in=0x000000FF | result=0xFFFFFFFF | 0 | sign extension bin | Planned | log TBD |
| TP-019 | Directed-valid | PACK | half-word concatenation | a_in=0x12345678, b_in=0x9ABCDEF0 | result = {b_in[15:0],a_in[15:0]} | 0 | PACK half-word bin | Planned | log TBD |
| TP-020 | Directed-valid | GREV valid encoding | supported GREV byte reverse | b_in[4:0]=24 | byte-reversed result | 0 | GREV valid bin | Planned | log TBD |
| TP-021 | Directed-valid | CSR read | pure bypass read | csr_ren_in=1, ap=0 | result = csr_rddata_in | 0 | CSR bypass bin | Planned | log TBD |
| TP-022 | Directed-valid | CSR write immediate | write from b_in | ap.csr_write=1, ap.csr_imm=1 | result = b_in | 0 | CSR write imm bin | Planned | log TBD |
| TP-023 | Directed-valid | CSR write register | write from a_in | ap.csr_write=1, ap.csr_imm=0 | result = a_in | 0 | CSR write reg bin | Planned | log TBD |
| TP-024 | Directed-corner | Result hold when valid_in=0 | hold behavior | valid_in=0 after valid op | previous result remains | 0 | valid gating | Planned | log TBD |
| TP-025 | Directed-corner | Live error under hold | invalid mode while idle | valid_in=0, invalid ap | error reflects current controls | 0 or 1 as per mode | error live bin | Planned | log TBD |
| TP-026 | Directed-corner | Reset during valid | reset high priority | rst_l=0 while valid_in=1 | result cleared | 0 | reset bin | Planned | log TBD |
| TP-027 | Directed-corner | Scan mode idle | scan_mode=1 | functional inputs stable | no function of scan_mode | 0 | scan bin | Planned | log TBD |
| TP-028 | Directed-error | Empty request | no primary op set | ap=0, csr_ren_in=0 | result=0 | 1 | invalid op bin | Planned | log TBD |
| TP-029 | Directed-error | Stray ZBB mode | zbb without OR/XOR | ap.zbb=1, ap.lor=0, ap.lxor=0 | result=0 | 1 | guard bin | Planned | log TBD |
| TP-030 | Directed-error | Stray ZBA mode | zba without valid SHxADD | ap.zba=1 but no sh1/2/3add | result=0 | 1 | guard bin | Planned | log TBD |
| TP-031 | Directed-error | Invalid CSR mode | csr_ren_in with active ap | ap.csr_write + ap.lor | result=0 | 1 | CSR conflict bin | Planned | log TBD |
| TP-032 | Directed-error | SLT without SUB | slt and sub absent | ap.slt=1, ap.sub=0 | result=0 | 1 | SLT guard bin | Planned | log TBD |
| TP-033 | Directed-error | MAX without SUB | max and sub absent | ap.max=1, ap.sub=0 | result=0 | 1 | MAX guard bin | Planned | log TBD |
| TP-034 | Directed-error | GREV invalid encoding | b_in[4:0] != 24 | ap.grev=1, b_in=5'd5 | result=0 | 1 | invalid GREV encoding | Planned | log TBD |
| TP-035 | Directed-error | Multiple primary ops | conflicting ops asserted | ap.lor=1, ap.lxor=1 | result=0 | 1 | multi-op guard | Planned | log TBD |
| TP-036 | Random-legal | legal random sweep | constrained legal random | valid legal operation subset | result matches ref model | expected legal error state | random coverage | Planned | log TBD |
| TP-037 | Random-illegal | invalid random sweep | random invalid op combinations | guard and conflict patterns | result=0 with error=1 | always 1 | invalid-mode coverage | Planned | log TBD |
| TP-038 | Regression | full gap closure | closure run | all 13 required additions | all rows covered | all expected error states | closure coverage | Planned | log TBD |

## 5. Required addition list

The project currently identifies the following required additions to close the 77-case plan:

- TC_BINV_004
- TC_SHIFT_004
- TC_CPOP_004
- TC_CTZ_005
- TC_GUARD_001
- TC_GUARD_002
- TC_GUARD_003
- TC_GUARD_004
- TC_SLT_005
- TC_MAX_005
- TC_CSR_005
- TC_TIME_004
- TC_RESET_004

These are treated as mandatory coverage rows and must exist in either the final regression list or the traceability matrix.

## 6. Regression order

1. smoke / nominal valid
2. corner and boundary checks
3. guard and invalid conditions
4. CSR and timing checks
5. legal random regression
6. invalid random regression
7. closure and coverage review

## 7. Exit criteria

A test row is complete when all of the following are true:
- sequence or test class is present and executable
- seed is recorded
- actual result and error are compared to the reference model
- log file exists
- coverage or traceability entry is recorded
- bug disposition is added if the row fails

Final sign-off is not valid while any current runtime-confirmed bug is still open.
