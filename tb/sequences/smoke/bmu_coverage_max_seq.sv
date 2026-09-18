// bmu maximum-coverage stimulus sequence =================================

class bmu_coverage_max_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_coverage_max_sequence)

        function new(string name = "bmu_coverage_max_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                int unsigned op_index;

                reset_dut();
                for (op_index = 0; op_index < 32; op_index++) begin
                        req = bmu_sequence_item::type_id::create("req");
                        initialize_item(req);
                        req.ap = '0;
                        req.a_in = 32'h80000000 | (op_index * 17);
                        req.b_in = 32'h01020304 ^ ({32{1'b1}} << (op_index % 5));
                        req.valid_in = 1'b1;
                        req.rst_l = 1'b1;

                        case (op_index % 18)
                                0: req.ap.lor = 1'b1;
                                1: req.ap.lxor = 1'b1;
                                2: req.ap.srl = 1'b1;
                                3: req.ap.sra = 1'b1;
                                4: req.ap.ror = 1'b1;
                                5: req.ap.binv = 1'b1;
                                6: begin req.ap.sh2add = 1'b1; req.ap.zba = 1'b1; end
                                7: req.ap.sub = 1'b1;
                                8: begin req.ap.slt = 1'b1; req.ap.sub = 1'b1; end
                                9: req.ap.ctz = 1'b1;
                                10: req.ap.cpop = 1'b1;
                                11: req.ap.siext_b = 1'b1;
                                12: begin req.ap.max = 1'b1; req.ap.sub = 1'b1; end
                                13: req.ap.pack = 1'b1;
                                14: begin req.ap.grev = 1'b1; req.b_in[4:0] = 5'd24; end
                                15: begin req.ap.csr_write = 1'b1; req.ap.csr_imm = 1'b1; end
                                16: begin req.ap.lor = 1'b1; req.ap.zbb = 1'b1; end
                                default: begin req.ap.sub = 1'b1; req.ap.zba = 1'b1; end
                        endcase

                        send_item(req);
                end
        endtask : body

endclass : bmu_coverage_max_sequence
