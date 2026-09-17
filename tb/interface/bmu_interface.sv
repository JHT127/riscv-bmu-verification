
// bmu dut interface ===========================================


interface bmu_interface (input logic clk);

        import bmu_types_package::*;


        // Declaring ------------------------------
                // bmu inputs
                logic        rst_l;
                logic        scan_mode;
                logic        valid_in;
                logic [31:0] a_in;
                logic [31:0] b_in;
                bmu_ctrl_t   ap;
                logic        csr_ren_in;
                logic [31:0] csr_rddata_in;

                // bmu outputs
                logic [31:0] result_ff;
                logic        error;



        // clocking blocks ----------------------------------------


                // -----driver clocking block------
                clocking cb_drv @(negedge clk);

                        default input #1 output #0;

                        // outputs driven by the driver
                        output rst_l;
                        output scan_mode;
                        output valid_in;
                        output a_in;
                        output b_in;
                        output ap;
                        output csr_ren_in;
                        output csr_rddata_in;

                endclocking : cb_drv



                // -------monitor clocking block---------------
                clocking cb_mon @(posedge clk);

                        default input #0 output #1;

                        // inputs sampled by the monitor
                        input rst_l;
                        input scan_mode;
                        input valid_in;
                        input a_in;
                        input b_in;
                        input ap;
                        input csr_ren_in;
                        input csr_rddata_in;
                        input result_ff;
                        input error;

                endclocking : cb_mon



        // modports ----------------------------------------
        modport dut (
                input clk,
                input rst_l,
                input scan_mode,
                input valid_in,
                input a_in,
                input b_in,
                input ap,
                input csr_ren_in,
                input csr_rddata_in,
                output result_ff,
                output error
        );

        modport drv (clocking cb_drv, input clk);
        modport mon (clocking cb_mon, input clk);



endinterface : bmu_interface