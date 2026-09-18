# RTL

The approved BMU RTL is included in this repository as the delivered DUT
snapshot. The verification team does not modify the DUT behavior.

This folder holds the RTL exactly as delivered by the design team. Any issue
found in the RTL is filed as a bug (see
[`docs/04_bug_reports/`](../docs/04_bug_reports)) rather than patched
locally, to keep DUT and verification environment cleanly separated.

## Expected contents (internal)

```text
rtl/
├── Bit_Manipulation_Unit.sv
├── rtl_defines.sv
├── rtl_param.sv
├── rtl_pdef.sv
├── rtl_def.sv
├── rtl_lib.sv
├── rtl_filelist.f
└── library/rtl_param.vh
```

`rtl_param.sv` is a parameter declaration fragment included through
`library/rtl_param.vh`, matching the delivered DUT include path. It is not
compiled as a standalone source file.
