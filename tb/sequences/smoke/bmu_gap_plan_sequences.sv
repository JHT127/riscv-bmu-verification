// bmu explicit gap-plan sequences ===========================================

class bmu_gap_plan_base_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_gap_plan_base_sequence)

        function new(string name = "bmu_gap_plan_base_sequence");
                super.new(name);
        endfunction : new

        task execute_check(string check_id, bmu_sequence_item req);
                `uvm_info(get_type_name(), {"executing ", check_id}, UVM_LOW)
                send_item(req);
        endtask : execute_check

endclass : bmu_gap_plan_base_sequence


class bmu_tc_binv_004_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_binv_004_sequence)

        function new(string name = "bmu_tc_binv_004_sequence");
                super.new(name);
        endfunction : new

        task body();
                int bit_index;
                bmu_sequence_item req;

                reset_dut();
                for (bit_index = 0; bit_index < 32; bit_index++) begin
                        req = bmu_sequence_item::type_id::create("binv_req");
                        initialize_item(req);
                        req.a_in = 32'h0000_0000;
                        req.b_in = bit_index[31:0];
                        req.ap.binv = 1'b1;
                        execute_check("TC_BINV_004", req);
                end
        endtask : body

endclass : bmu_tc_binv_004_sequence


class bmu_tc_shift_004_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_shift_004_sequence)

        function new(string name = "bmu_tc_shift_004_sequence");
                super.new(name);
        endfunction : new

        task body();
                int shift_index;
                bmu_sequence_item req;

                reset_dut();
                for (shift_index = 0; shift_index < 32; shift_index++) begin
                        req = bmu_sequence_item::type_id::create("srl_req");
                        initialize_item(req);
                        req.a_in = 32'h8000_0001;
                        req.b_in = shift_index[31:0];
                        req.ap.srl = 1'b1;
                        execute_check("TC_SHIFT_004_SRL", req);

                        req = bmu_sequence_item::type_id::create("sra_req");
                        initialize_item(req);
                        req.a_in = 32'h8000_0001;
                        req.b_in = shift_index[31:0];
                        req.ap.sra = 1'b1;
                        execute_check("TC_SHIFT_004_SRA", req);

                        req = bmu_sequence_item::type_id::create("ror_req");
                        initialize_item(req);
                        req.a_in = 32'h8000_0001;
                        req.b_in = shift_index[31:0];
                        req.ap.ror = 1'b1;
                        execute_check("TC_SHIFT_004_ROR", req);
                end
        endtask : body

endclass : bmu_tc_shift_004_sequence


class bmu_tc_cpop_004_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_cpop_004_sequence)

        function new(string name = "bmu_tc_cpop_004_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                reset_dut();

                req = bmu_sequence_item::type_id::create("cpop_low");
                initialize_item(req);
                req.a_in = 32'h0000_FFFF;
                req.ap.cpop = 1'b1;
                execute_check("TC_CPOP_004_LOW", req);

                req = bmu_sequence_item::type_id::create("cpop_high");
                initialize_item(req);
                req.a_in = 32'hFFFF_0000;
                req.ap.cpop = 1'b1;
                execute_check("TC_CPOP_004_HIGH", req);
        endtask : body

endclass : bmu_tc_cpop_004_sequence


class bmu_tc_ctz_005_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_ctz_005_sequence)

        function new(string name = "bmu_tc_ctz_005_sequence");
                super.new(name);
        endfunction : new

        task body();
                int bit_index;
                bmu_sequence_item req;

                reset_dut();
                for (bit_index = 0; bit_index < 32; bit_index++) begin
                        req = bmu_sequence_item::type_id::create("ctz_req");
                        initialize_item(req);
                        req.a_in = 32'(1 << bit_index);
                        req.ap.ctz = 1'b1;
                        execute_check("TC_CTZ_005", req);
                end
        endtask : body

endclass : bmu_tc_ctz_005_sequence


class bmu_tc_guard_001_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_guard_001_sequence)

        function new(string name = "bmu_tc_guard_001_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("guard_empty");
                initialize_item(req);
                req.ap = '0;
                req.valid_in = 1'b1;
                execute_check("TC_GUARD_001", req);
        endtask : body

endclass : bmu_tc_guard_001_sequence


class bmu_tc_guard_002_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_guard_002_sequence)

        function new(string name = "bmu_tc_guard_002_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("guard_zbb");
                initialize_item(req);
                req.ap.zbb = 1'b1;
                req.valid_in = 1'b1;
                execute_check("TC_GUARD_002", req);
        endtask : body

endclass : bmu_tc_guard_002_sequence


class bmu_tc_guard_003_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_guard_003_sequence)

        function new(string name = "bmu_tc_guard_003_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("guard_csr_imm");
                initialize_item(req);
                req.ap.csr_imm = 1'b1;
                req.valid_in = 1'b1;
                execute_check("TC_GUARD_003", req);
        endtask : body

endclass : bmu_tc_guard_003_sequence


class bmu_tc_guard_004_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_guard_004_sequence)

        function new(string name = "bmu_tc_guard_004_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("guard_zba");
                initialize_item(req);
                req.ap.zba = 1'b1;
                req.valid_in = 1'b1;
                execute_check("TC_GUARD_004", req);
        endtask : body

endclass : bmu_tc_guard_004_sequence


class bmu_tc_slt_005_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_slt_005_sequence)

        function new(string name = "bmu_tc_slt_005_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("slt_without_sub");
                initialize_item(req);
                req.a_in = 32'hFFFF_FFFF;
                req.b_in = 32'h0000_0001;
                req.ap.slt = 1'b1;
                req.valid_in = 1'b1;
                execute_check("TC_SLT_005", req);
        endtask : body

endclass : bmu_tc_slt_005_sequence


class bmu_tc_max_005_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_max_005_sequence)

        function new(string name = "bmu_tc_max_005_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("max_without_sub");
                initialize_item(req);
                req.a_in = 32'd10;
                req.b_in = 32'd20;
                req.ap.max = 1'b1;
                req.valid_in = 1'b1;
                execute_check("TC_MAX_005", req);
        endtask : body

endclass : bmu_tc_max_005_sequence


class bmu_tc_csr_005_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_csr_005_sequence)

        function new(string name = "bmu_tc_csr_005_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("csr_idle");
                initialize_item(req);
                req.valid_in = 1'b0;
                req.csr_ren_in = 1'b1;
                req.csr_rddata_in = 32'hABCD_1234;
                execute_check("TC_CSR_005", req);
        endtask : body

endclass : bmu_tc_csr_005_sequence


class bmu_tc_time_004_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_time_004_sequence)

        function new(string name = "bmu_tc_time_004_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("invalid_idle");
                initialize_item(req);
                req.valid_in = 1'b0;
                req.ap.lor = 1'b1;
                req.ap.lxor = 1'b1;
                execute_check("TC_TIME_004", req);
        endtask : body

endclass : bmu_tc_time_004_sequence


class bmu_tc_reset_004_sequence extends bmu_gap_plan_base_sequence;

        `uvm_object_utils(bmu_tc_reset_004_sequence)

        function new(string name = "bmu_tc_reset_004_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("reset_conflict");
                initialize_item(req);
                req.rst_l = 1'b0;
                req.valid_in = 1'b1;
                req.ap.lor = 1'b1;
                req.ap.lxor = 1'b1;
                execute_check("TC_RESET_004", req);
        endtask : body

endclass : bmu_tc_reset_004_sequence
