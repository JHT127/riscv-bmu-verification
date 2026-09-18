
// bmu dut interface ===========================================


interface bmu_interface (input logic clk);

        import bmu_types_package::*;
        import rtl_pkg::*;


        // Declaring ------------------------------
                // bmu inputs
                logic        rst_l;
                logic        scan_mode;
                logic        valid_in;
                logic [31:0] a_in;
                logic [31:0] b_in;
                bmu_ctrl_t   ap;
                rtl_alu_pkt_t dut_ap;
                logic        csr_ren_in;
                logic [31:0] csr_rddata_in;

                // bmu outputs
                logic [31:0] result_ff;
                logic        error;



        // rtl control adapter ----------------------------------------
                always_comb begin
                        dut_ap = '0;
                        dut_ap.ctz = ap.ctz;
                        dut_ap.cpop = ap.cpop;
                        dut_ap.siext_b = ap.siext_b;
                        dut_ap.max = ap.max;
                        dut_ap.pack = ap.pack;
                        dut_ap.grev = ap.grev;
                        dut_ap.ror = ap.ror;
                        dut_ap.binv = ap.binv;
                        dut_ap.sh2add = ap.sh2add;
                        dut_ap.zba = ap.zba;
                        dut_ap.sub = ap.sub;
                        dut_ap.slt = ap.slt;
                        dut_ap.unsign = ap.unsign;
                        dut_ap.lor = ap.lor;
                        dut_ap.lxor = ap.lxor;
                        dut_ap.srl = ap.srl;
                        dut_ap.sra = ap.sra;
                        dut_ap.csr_write = ap.csr_write;
                        dut_ap.csr_imm = ap.csr_imm;
                end



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
                input dut_ap,
                input csr_ren_in,
                input csr_rddata_in,
                output result_ff,
                output error
        );

        modport drv (clocking cb_drv, input clk);
        modport mon (clocking cb_mon, input clk);



endinterface : bmu_interface