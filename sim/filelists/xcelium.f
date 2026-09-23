# Xcelium filelist — delivered RTL + UVM testbench sources

# ----- RTL (design team supplied, not modified) -----
-f ../rtl/rtl_filelist.f
../tb/assertions/bmu_protocol_assertions.sv

# ----- Include directories -----
+incdir+../tb/include
+incdir+../tb/packages
+incdir+../tb/interface

# ----- Packages (compile order matters) -----
../tb/packages/bmu_types_package.sv
../tb/packages/bmu_pkg.sv

# ----- Interface -----
../tb/interface/bmu_interface.sv

# ----- Testbench top -----
../tb/top/bmu_tb_top.sv
