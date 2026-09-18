
// bmu random error sequence ===========================================


class bmu_random_error_sequence extends bmu_error_injection_base_sequence;

        int unsigned scenario_count = 100;
        `uvm_object_utils(bmu_random_error_sequence)

        function new(string name = "bmu_random_error_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                int unsigned violation;

                reset_dut();
                repeat (scenario_count) begin
                        req = bmu_sequence_item::type_id::create("req");
                        if (!req.randomize() with { rst_l == 1'b1; valid_in == 1'b1; scan_mode == 1'b0; })
                                `uvm_fatal(get_type_name(), "error randomization failed")
                        req.ap = '0;
                        req.csr_ren_in = 1'b0;
                        violation = $urandom_range(0, 9);
                        case (violation)
                                0: begin req.ap.lor = 1'b1; req.ap.lxor = 1'b1; end
                                1: begin req.ap.srl = 1'b1; req.ap.sra = 1'b1; end
                                2: begin req.ap.pack = 1'b1; req.csr_ren_in = 1'b1; end
                                3: begin req.ap.sub = 1'b1; req.ap.zba = 1'b1; end
                                4: begin req.ap.zbb = 1'b1; end
                                5: begin req.ap.csr_imm = 1'b1; end
                                6: begin req.ap.zba = 1'b1; end
                                7: begin req.ap.slt = 1'b1; end
                                8: begin req.ap.max = 1'b1; end
                                default: begin req.ap.grev = 1'b1; req.b_in[4:0] = 5'd5; end
                        endcase
                        send_item(req);
                end
        endtask : body

endclass : bmu_random_error_sequence