// bmu maximum-coverage stimulus sequence =================================

class bmu_coverage_max_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_coverage_max_sequence)

        function new(string name = "bmu_coverage_max_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                int unsigned op_index;
                logic [4:0] shift_amt;
                int unsigned mode_sel;

                reset_dut();

                for (op_index = 0; op_index < 64; op_index++) begin
                        req = bmu_sequence_item::type_id::create("req");
                        initialize_item(req);
                        req.valid_in = 1'b1;
                        req.rst_l = 1'b1;
                        req.scan_mode = 1'b0;
                        req.ap = '0;
                        req.csr_ren_in = 1'b0;
                        req.csr_rddata_in = '0;
                        shift_amt = op_index[4:0];
                        mode_sel = op_index % 2;

                        case (op_index % 24)
                                0: begin req.ap.lor = 1'b1; req.ap.zbb = 1'b1; req.a_in = 32'h12345678; req.b_in = 32'h0f0f0f0f; end
                                1: begin req.ap.lxor = 1'b1; req.ap.zbb = 1'b1; req.a_in = 32'habcdef01; req.b_in = 32'h0f0f0f0f; end
                                2: begin req.ap.land = 1'b1; req.a_in = 32'hf0f0f0f0; req.b_in = 32'h0f0f0f0f; end
                                3: begin req.ap.sll = 1'b1; req.a_in = 32'h00000001; req.b_in[4:0] = shift_amt; end
                                4: begin req.ap.srl = 1'b1; req.a_in = 32'h80000000; req.b_in[4:0] = shift_amt; end
                                5: begin req.ap.sra = 1'b1; req.a_in = 32'h80000000; req.b_in[4:0] = shift_amt; end
                                6: begin req.ap.ror = 1'b1; req.a_in = 32'h80000001; req.b_in[4:0] = shift_amt; end
                                7: begin req.ap.bset = 1'b1; req.a_in = 32'h00000000; req.b_in[4:0] = shift_amt; end
                                8: begin req.ap.bclr = 1'b1; req.a_in = 32'hffffffff; req.b_in[4:0] = shift_amt; end
                                9: begin req.ap.binv = 1'b1; req.a_in = 32'hffffffff; req.b_in[4:0] = shift_amt; end
                                10: begin req.ap.bext = 1'b1; req.a_in = 32'h00000010; req.b_in[4:0] = shift_amt; end
                                11: begin req.ap.sh1add = 1'b1; req.ap.zba = 1'b1; req.a_in = 32'h00000005; req.b_in = 32'h00000003; end
                                12: begin req.ap.sh2add = 1'b1; req.ap.zba = 1'b1; req.a_in = 32'h00000005; req.b_in = 32'h00000003; end
                                13: begin req.ap.sh3add = 1'b1; req.ap.zba = 1'b1; req.a_in = 32'h00000005; req.b_in = 32'h00000003; end
                                14: begin req.ap.sub = 1'b1; req.a_in = 32'h00000010; req.b_in = 32'h00000003; end
                                15: begin req.ap.slt = 1'b1; req.ap.sub = 1'b1; req.ap.unsign = mode_sel; req.a_in = 32'h80000000; req.b_in = 32'h7fffffff; end
                                16: begin req.ap.ctz = 1'b1; req.a_in = 32'h00000000 | ({32{1'b1}} << (op_index % 8)); end
                                17: begin req.ap.cpop = 1'b1; req.a_in = 32'hf0f0f0f0; end
                                18: begin req.ap.siext_b = 1'b1; req.a_in = 32'h000000ff; end
                                19: begin req.ap.max = 1'b1; req.ap.sub = 1'b1; req.ap.unsign = mode_sel; req.a_in = 32'h80000000; req.b_in = 32'h7fffffff; end
                                20: begin req.ap.pack = 1'b1; req.a_in = 32'h12345678; req.b_in = 32'h9abcdef0; end
                                21: begin req.ap.grev = 1'b1; req.a_in = 32'h01234567; req.b_in[4:0] = 5'd24; end
                                22: begin req.ap.csr_write = 1'b1; req.ap.csr_imm = 1'b1; req.b_in = 32'hdeadbeef; end
                                default: begin end
                        endcase

                        if (op_index % 24 == 22) begin
                                req.a_in = 32'h00000000;
                                req.b_in = 32'hdeadbeef;
                        end

                        send_item(req);
                end
        endtask : body

endclass : bmu_coverage_max_sequence
