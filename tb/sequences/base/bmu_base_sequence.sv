
// bmu base sequence ===========================================


class bmu_base_sequence extends uvm_sequence #(bmu_sequence_item);


        // Declaring ------------------------------
                virtual bmu_interface vif;



        // utility macro ----------------------------------------
                `uvm_object_utils(bmu_base_sequence)



        // constructor ----------------------------------------
        function new(string name = "bmu_base_sequence");
                super.new(name);
        endfunction : new



        // pre-body phase ----------------------------------------
        task pre_body();
                if (!uvm_config_db #(virtual bmu_interface)::get(null, "", "vif", vif))
                        `uvm_fatal(get_type_name(), "vif not set at top level")
        endtask : pre_body



        // body ----------------------------------------
        task body();
        endtask : body



        // initialize item task ----------------------------------------
        task initialize_item(bmu_sequence_item req);
                req.rst_l = 1'b1;
                req.scan_mode = 1'b0;
                req.valid_in = 1'b1;
                req.a_in = '0;
                req.b_in = '0;
                req.ap = '0;
                req.csr_ren_in = 1'b0;
                req.csr_rddata_in = '0;
        endtask : initialize_item



        // legal stimulus controls ----------------------------------------
        task select_operation(bmu_sequence_item req, bmu_operation_t operation);
                req.ap = '0;
                req.csr_ren_in = 1'b0;
                case (operation)
                        BMU_OR: req.ap.lor = 1'b1;
                        BMU_XOR: req.ap.lxor = 1'b1;
                        BMU_SRL: req.ap.srl = 1'b1;
                        BMU_SRA: req.ap.sra = 1'b1;
                        BMU_ROR: req.ap.ror = 1'b1;
                        BMU_BINV: req.ap.binv = 1'b1;
                        BMU_SH2ADD: begin req.ap.sh2add = 1'b1; req.ap.zba = 1'b1; end
                        BMU_SUB: req.ap.sub = 1'b1;
                        BMU_SLT: begin req.ap.slt = 1'b1; req.ap.sub = 1'b1; end
                        BMU_CTZ: req.ap.ctz = 1'b1;
                        BMU_CPOP: req.ap.cpop = 1'b1;
                        BMU_SEXTB: req.ap.siext_b = 1'b1;
                        BMU_MAX: begin req.ap.max = 1'b1; req.ap.sub = 1'b1; end
                        BMU_PACK: req.ap.pack = 1'b1;
                        BMU_GREV: begin req.ap.grev = 1'b1; req.b_in[4:0] = 5'd24; end
                        BMU_CSR_WRITE: req.ap.csr_write = 1'b1;
                        BMU_CSR_READ: req.csr_ren_in = 1'b1;
                        default: req.ap = '0;
                endcase
        endtask : select_operation



        // send item task ----------------------------------------
        task send_item(bmu_sequence_item req);
                start_item(req);
                finish_item(req);
                @(posedge vif.clk);
        endtask : send_item



        // reset dut task ----------------------------------------
        task reset_dut();
                bmu_sequence_item reset_item;

                reset_item = bmu_sequence_item::type_id::create("reset_item");
                initialize_item(reset_item);
                reset_item.rst_l = 1'b0;
                reset_item.valid_in = 1'b0;
                reset_item.ap = '0;
                send_item(reset_item);
        endtask : reset_dut


endclass : bmu_base_sequence