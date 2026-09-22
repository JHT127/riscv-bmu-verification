// bmu reference model self test ===========================================

class bmu_model_self_test extends uvm_test;

        bmu_reference_model model;
        uvm_tlm_analysis_fifo #(bmu_sequence_item) expected_fifo;
        int unsigned checks;
        `uvm_component_utils(bmu_model_self_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                model = bmu_reference_model::type_id::create("model", this);
                expected_fifo = new("expected_fifo", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
                model.expected_port.connect(expected_fifo.analysis_export);
        endfunction : connect_phase

        function void check_value(string check_id, bmu_sequence_item req,
                                  logic [31:0] wanted_result, logic wanted_error);
                logic [31:0] result;
                logic error;
                model.calculate(req, result, error);
                checks++;
                if (result !== wanted_result || error !== wanted_error)
                        `uvm_error(get_type_name(), $sformatf(
                                "%s: expected=%h/%b actual=%h/%b", check_id,
                                wanted_result, wanted_error, result, error))
        endfunction : check_value

        function void check_state(string check_id, bmu_sequence_item req,
                                  logic [31:0] wanted_result, logic wanted_error);
                bmu_sequence_item expected;
                model.write(req);
                checks++;
                if (!expected_fifo.try_get(expected))
                        `uvm_fatal(get_type_name(), "missing prediction")
                if (expected.result_ff !== wanted_result || expected.error !== wanted_error)
                        `uvm_error(get_type_name(), {check_id, ": state prediction mismatch"})
        endfunction : check_state

        task run_phase(uvm_phase phase);
                bmu_sequence_item req;
                bmu_ctrl_t controls;
                bmu_ctrl_t allowed;
                logic [31:0] wanted;

                phase.raise_objection(this);
                req = bmu_sequence_item::type_id::create("req");
                req.rst_l = 1'b1;
                req.valid_in = 1'b1;
                req.scan_mode = 1'b0;
                req.csr_rddata_in = 32'hABCD1234;

                // Spec examples and an independent forbidden-bit matrix.
                for (int operation = 0; operation < 17; operation++) begin
                        req.ap = '0;
                        req.csr_ren_in = 1'b0;
                        case (operation)
                                0: begin
                                        req.ap.lor = 1'b1;
                                        req.a_in = 32'hF0F0F0F0; req.b_in = 32'h0F0F0F0F; wanted = 32'hFFFFFFFF;
                                end
                                1: begin
                                        req.ap.lxor = 1'b1;
                                        req.a_in = 32'hAAAAAAAA; req.b_in = 32'h55555555; wanted = 32'hFFFFFFFF;
                                end
                                2: begin
                                        req.ap.srl = 1'b1;
                                        req.a_in = 32'hF0000000; req.b_in = 32'h00000004; wanted = 32'h0F000000;
                                end
                                3: begin
                                        req.ap.sra = 1'b1;
                                        req.a_in = 32'hF0000000; req.b_in = 32'h00000004; wanted = 32'hFF000000;
                                end
                                4: begin
                                        req.ap.ror = 1'b1;
                                        req.a_in = 32'h89ABCDEF; req.b_in = 32'h00000004; wanted = 32'hF89ABCDE;
                                end
                                5: begin
                                        req.ap.binv = 1'b1;
                                        req.a_in = 32'hFFFFFFFF; req.b_in = 32'h00000002; wanted = 32'hFFFFFFFB;
                                end
                                6: begin
                                        req.ap.sh2add = 1'b1;
                                        req.ap.zba = 1'b1;
                                        req.a_in = 32'h00000004; req.b_in = 32'h00000007; wanted = 32'h00000017;
                                end
                                7: begin
                                        req.ap.sub = 1'b1;
                                        req.a_in = 32'h00000014; req.b_in = 32'h00000007; wanted = 32'h0000000D;
                                end
                                8: begin
                                        req.ap.slt = 1'b1;
                                        req.ap.sub = 1'b1;
                                        req.a_in = 32'hFFFFFFFE; req.b_in = 32'h00000001; wanted = 32'h00000001;
                                end
                                9: begin
                                        req.ap.ctz = 1'b1;
                                        req.a_in = 32'h00000100; req.b_in = 32'h00000000; wanted = 32'h00000008;
                                end
                                10: begin
                                        req.ap.cpop = 1'b1;
                                        req.a_in = 32'hFFFF0000; req.b_in = 32'h00000000; wanted = 32'h00000010;
                                end
                                11: begin
                                        req.ap.siext_b = 1'b1;
                                        req.a_in = 32'h12345680; req.b_in = 32'h00000000; wanted = 32'hFFFFFF80;
                                end
                                12: begin
                                        req.ap.max = 1'b1;
                                        req.ap.sub = 1'b1;
                                        req.a_in = 32'h0000000A; req.b_in = 32'h00000014; wanted = 32'h00000014;
                                end
                                13: begin
                                        req.ap.pack = 1'b1;
                                        req.a_in = 32'h00001234; req.b_in = 32'h00005678; wanted = 32'h56781234;
                                end
                                14: begin
                                        req.ap.grev = 1'b1;
                                        req.a_in = 32'h12345678; req.b_in = 32'h00000018; wanted = 32'h78563412;
                                end
                                15: begin
                                        req.ap.csr_write = 1'b1;
                                        req.a_in = 32'h33334444; req.b_in = 32'h11112222; wanted = 32'h33334444;
                                end
                                16: begin
                                        req.csr_ren_in = 1'b1;
                                        req.a_in = 32'h00000000; req.b_in = 32'h00000000; wanted = 32'hABCD1234;
                                end
                        endcase
                        check_value($sformatf("spec example %0d", operation), req, wanted, 0);
                        controls = req.ap;
                        allowed = controls;
                        if (operation == 0 || operation == 1) allowed.zbb = 1'b1;
                        // SUB becomes a legal comparison when SLT or MAX is added.
                        if (operation == 7) begin allowed.slt = 1'b1; allowed.max = 1'b1; end
                        if (operation == 8) allowed.unsign = 1'b1;
                        if (operation == 15) allowed.csr_imm = 1'b1;
                        for (int field_index = 0; field_index < $bits(bmu_ctrl_t); field_index++) begin
                                if (!allowed[field_index]) begin
                                        req.ap = controls;
                                        req.ap[field_index] = 1'b1;
                                        check_value($sformatf("op %0d forbidden bit %0d", operation, field_index), req, 0, 1);
                                end
                        end
                        req.ap = controls;
                        if (operation != 16) begin
                                req.csr_ren_in = 1'b1;
                                check_value("csr conflict", req, 0, 1);
                                req.csr_ren_in = 1'b0;
                        end
                        if (operation == 0 || operation == 1) begin
                                req.ap.zbb = 1'b1;
                                check_value("zbb inversion", req,
                                            operation == 0 ? 32'hF0F0F0F0 : 32'h00000000, 0);
                        end
                        if (operation == 6) begin
                                req.ap.zba = 1'b0;
                                check_value("missing zba", req, 0, 1);
                        end
                        if (operation == 8 || operation == 12) begin
                                req.ap.sub = 1'b0;
                                check_value("missing sub", req, 0, 1);
                        end
                        if (operation == 8) begin
                                req.ap.sub = 1'b1;
                                req.ap.unsign = 1'b1;
                                check_value("unsigned comparison", req, 0, 0);
                        end
                        if (operation == 14) begin
                                for (int amount = 0; amount < 32; amount++) begin
                                        req.b_in = amount;
                                        check_value("grev encodings", req,
                                                    amount == 24 ? 32'h78563412 : 0, amount != 24);
                                end
                        end
                        if (operation == 15) begin
                                req.ap.csr_imm = 1'b1;
                                check_value("csr immediate", req, 32'h11112222, 0);
                        end
                end

                req.csr_ren_in = 1'b0;
                req.ap = '0;
                check_value("empty request", req, 0, 1);
                req.ap.ctz = 1'b1;
                req.a_in = 0;
                check_value("ctz zero", req, 32, 0);
                for (int position = 0; position < 32; position++) begin
                        req.a_in = 32'b1 << position;
                        check_value("ctz one hot", req, position, 0);
                end
                req.ap = '0;
                req.ap.cpop = 1'b1;
                for (int count = 0; count <= 32; count++) begin
                        req.a_in = 32'hFFFFFFFF >> (32 - count);
                        check_value("cpop lower pattern", req, count, 0);
                        req.a_in = 32'hFFFFFFFF << (32 - count);
                        check_value("cpop upper pattern", req, count, 0);
                end

                req.rst_l = 1'b0;
                check_state("reset", req, 0, 0);
                req.rst_l = 1'b1;
                req.ap = '0;
                req.ap.lor = 1'b1;
                req.a_in = 32'h12345678;
                req.b_in = 0;
                check_state("capture", req, 32'h12345678, 0);
                req.valid_in = 1'b0;
                req.ap.lxor = 1'b1;
                check_state("hold with live error", req, 32'h12345678, 1);
                req.rst_l = 1'b0;
                check_state("reset while idle", req, 0, 0);
                `uvm_info(get_type_name(), $sformatf("model checks=%0d", checks), UVM_LOW)
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_model_self_test
