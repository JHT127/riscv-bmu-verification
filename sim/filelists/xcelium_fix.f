# Fixed-RTL Xcelium filelist for the bug-fixed BMU variant.
# The original RTL under ../rtl remains untouched.

+incdir+../rtl
+incdir+../rtl/library

../rtl/rtl_defines.sv
../rtl/rtl_pdef.sv
../rtl/rtl_def.sv
../rtl/rtl_lib_fix_v1.sv
../rtl/Bit_Manipulation_Unit_fix_v1.sv

../tb/assertions/bmu_protocol_assertions_fix_v1.sv
+incdir+../tb/include
+incdir+../tb/packages
+incdir+../tb/interface
../tb/packages/bmu_types_package.sv
../tb/packages/bmu_pkg.sv
../tb/interface/bmu_interface.sv
../tb/top/bmu_tb_top_fix_v1.sv
