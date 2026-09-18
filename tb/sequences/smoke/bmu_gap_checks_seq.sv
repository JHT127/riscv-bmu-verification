// bmu missing test-plan checks ===========================================

class bmu_gap_checks_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_gap_checks_sequence)

        function new(string name = "bmu_gap_checks_sequence");
                super.new(name);
        endfunction : new

        task send_check(string check_id, bmu_sequence_item req);
                `uvm_info(get_type_name(), {"executing ", check_id}, UVM_LOW)
                send_item(req);
        endtask : send_check

        task body();
                bmu_sequence_item req;
                int bit_index;

                reset_dut();

                for (bit_index = 0; bit_index < 32; bit_index++) begin
                        req = bmu_sequence_item::type_id::create("binv_sweep");
                        initialize_item(req);
                        req.a_in = 32'h0000_0000;
                        req.b_in = bit_index;
                        req.ap.binv = 1'b1;
                        send_check("TC_BINV_004", req);
                end

                for (bit_index = 0; bit_index < 32; bit_index++) begin
                        req = bmu_sequence_item::type_id::create("srl_sweep");
                        initialize_item(req);
                        req.a_in = 32'h8000_0001;
                        req.b_in = bit_index;
                        req.ap.srl = 1'b1;
                        send_check("TC_SHIFT_004_SRL", req);

                        req = bmu_sequence_item::type_id::create("sra_sweep");
                        initialize_item(req);
                        req.a_in = 32'h8000_0001;
                        req.b_in = bit_index;
                        req.ap.sra = 1'b1;
                        send_check("TC_SHIFT_004_SRA", req);

                        req = bmu_sequence_item::type_id::create("ror_sweep");
                        initialize_item(req);
                        req.a_in = 32'h8000_0001;
                        req.b_in = bit_index;
                        req.ap.ror = 1'b1;
                        send_check("TC_SHIFT_004_ROR", req);
                end

                req = bmu_sequence_item::type_id::create("cpop_low");
                initialize_item(req);
                req.a_in = 32'h0000_FFFF;
                req.ap.cpop = 1'b1;
                send_check("TC_CPOP_004_LOW", req);

                req = bmu_sequence_item::type_id::create("cpop_high");
                initialize_item(req);
                req.a_in = 32'hFFFF_0000;
                req.ap.cpop = 1'b1;
                send_check("TC_CPOP_004_HIGH", req);

                for (bit_index = 0; bit_index < 32; bit_index++) begin
                        req = bmu_sequence_item::type_id::create("ctz_one_hot");
                        initialize_item(req);
                        req.a_in = 32'(1 << bit_index);
                        req.ap.ctz = 1'b1;
                        send_check("TC_CTZ_005", req);
                end

                req = bmu_sequence_item::type_id::create("guard_empty");
                initialize_item(req);
                req.ap = '0;
                send_check("TC_GUARD_001", req);

                req = bmu_sequence_item::type_id::create("guard_zbb");
                initialize_item(req);
                req.ap.zbb = 1'b1;
                send_check("TC_GUARD_002", req);

                req = bmu_sequence_item::type_id::create("guard_csr_imm");
                initialize_item(req);
                req.ap.csr_imm = 1'b1;
                send_check("TC_GUARD_003", req);

                req = bmu_sequence_item::type_id::create("guard_zba");
                initialize_item(req);
                req.ap.zba = 1'b1;
                send_check("TC_GUARD_004", req);

                req = bmu_sequence_item::type_id::create("slt_without_sub");
                initialize_item(req);
                req.a_in = 32'hFFFF_FFFF;
                req.b_in = 32'h0000_0001;
                req.ap.slt = 1'b1;
                send_check("TC_SLT_005", req);

                req = bmu_sequence_item::type_id::create("max_without_sub");
                initialize_item(req);
                req.a_in = 32'd10;
                req.b_in = 32'd20;
                req.ap.max = 1'b1;
                send_check("TC_MAX_005", req);

                req = bmu_sequence_item::type_id::create("csr_idle");
                initialize_item(req);
                req.valid_in = 1'b0;
                req.csr_ren_in = 1'b1;
                req.csr_rddata_in = 32'hABCD_1234;
                send_check("TC_CSR_005", req);

                req = bmu_sequence_item::type_id::create("invalid_idle");
                initialize_item(req);
                req.valid_in = 1'b0;
                req.ap.lor = 1'b1;
                req.ap.lxor = 1'b1;
                send_check("TC_TIME_004", req);

                req = bmu_sequence_item::type_id::create("reset_conflict");
                initialize_item(req);
                req.rst_l = 1'b0;
                req.ap.lor = 1'b1;
                req.ap.lxor = 1'b1;
                send_check("TC_RESET_004", req);
        endtask : body

endclass : bmu_gap_checks_sequence
