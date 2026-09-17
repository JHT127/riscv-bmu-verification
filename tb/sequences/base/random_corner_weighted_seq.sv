
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
                        req.ap.lor = 1'b1;
                        send_item(req);
                end
        endtask : body

endclass : bmu_random_corner_weighted_sequence