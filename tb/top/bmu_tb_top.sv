
// bmu testbench top ===========================================


import uvm_pkg::*;
import bmu_pkg::*;


module bmu_tb_top;


        // Declaring ------------------------------
                logic clk;
                bmu_interface bmu_if(clk);



        // clock generation ----------------------------------------
        initial begin
                clk = 1'b0;
                forever #5 clk <= ~clk;
        end



        // default input values ----------------------------------------
        initial begin
                bmu_if.rst_l = 1'b0;
                bmu_if.scan_mode = 1'b0;
                bmu_if.valid_in = 1'b0;
                bmu_if.a_in = '0;
                bmu_if.b_in = '0;
                bmu_if.ap = '0;
                bmu_if.csr_ren_in = 1'b0;
                bmu_if.csr_rddata_in = '0;
        end



        // uvm configuration and run ----------------------------------------
        initial begin
                uvm_config_db #(virtual bmu_interface)::set(null, "*", "vif", bmu_if);
                run_test();
        end


endmodule : bmu_tb_top