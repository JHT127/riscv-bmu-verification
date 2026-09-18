
// bmu random corner weighted sequence ===========================================


class bmu_random_corner_weighted_sequence extends bmu_base_sequence;

        int unsigned scenario_count = 100;
        `uvm_object_utils(bmu_random_corner_weighted_sequence)

        function new(string name = "bmu_random_corner_weighted_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                int unsigned corner;
                int unsigned operation;

                reset_dut();
                repeat (scenario_count) begin
                        req = bmu_sequence_item::type_id::create("req");
                        if (!req.randomize() with { rst_l == 1'b1; valid_in == 1'b1; scan_mode == 1'b0; csr_ren_in == 1'b0; })
                                `uvm_fatal(get_type_name(), "corner randomization failed")
                        corner = $urandom_range(0, 3);
                        case (corner)
                                0: begin req.a_in = 32'h0000_0000; req.b_in = 32'h0000_0000; end
                                1: begin req.a_in = 32'hFFFF_FFFF; req.b_in = 32'hFFFF_FFFF; end
                                2: begin req.a_in = 32'h8000_0000; req.b_in = 32'd31; end
                                default: begin req.a_in = 32'h7FFF_FFFF; req.b_in = 32'h0000_0001; end
                        endcase
                        req.ap = '0;
                        operation = $urandom_range(0, 15);
                        case (operation)
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
                                14: begin req.ap.csr_write = 1'b1; req.ap.csr_imm = $urandom_range(0, 1); end
                                default: begin req.ap.grev = 1'b1; req.b_in[4:0] = 5'd24; end
                        endcase
                        send_item(req);
                end
        endtask : body

endclass : bmu_random_corner_weighted_sequence