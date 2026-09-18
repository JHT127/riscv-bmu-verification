# VCS filelist — RTL + UVM testbench sources
# Fill in once RTL is dropped into ../../rtl/ locally (not committed).

# ----- RTL (design team supplied, not modified) -----
-f ../rtl/rtl_filelist.f

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
