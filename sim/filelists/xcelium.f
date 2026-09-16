# VCS filelist — RTL + UVM testbench sources
# Fill in once RTL is dropped into ../../rtl/ locally (not committed).

# ----- RTL (design team supplied, not modified) -----
-f ../../rtl/rtl_filelist.f

# ----- Include directories -----
+incdir+../../tb/include
+incdir+../../tb/interface

# ----- Packages (compile order matters) -----
../../tb/packages/dut_test_package.sv

# ----- Interface -----
../../tb/interface/Bit_Manipulation_intf.sv

# ----- Testbench top -----
../../tb/top/top_tb.sv
