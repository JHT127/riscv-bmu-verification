# RTL — Not Included

The BMU RTL (`Bit_Manipulation_Unit.sv` and its supporting packages/
defines) is design-team-owned and confidential. It is **not included**
in this public repository.

Internally, this folder holds the RTL exactly as delivered by the
design team — **the verification team does not modify it**. Any issue
found in the RTL is filed as a bug (see
[`docs/04_bug_reports/`](../docs/04_bug_reports)) rather than patched
locally, to keep DUT and verification environment cleanly separated.

## Expected contents (internal)

```
rtl/
├── Bit_Manipulation_Unit.sv
├── rtl_defines.sv
├── rtl_param.sv
├── rtl_pdef.sv
├── rtl_def.sv
└── rtl_lib.sv
```
