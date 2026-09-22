
// bmu random corner weighted sequence ===========================================


class bmu_random_corner_weighted_sequence extends bmu_base_sequence;

        int unsigned scenario_count = 100;
        `uvm_object_utils(bmu_random_corner_weighted_sequence)

        function new(string name = "bmu_random_corner_weighted_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                int unsigned operation;

                reset_dut();
                repeat (scenario_count) begin
                        req = bmu_sequence_item::type_id::create("req");
                        if (!req.randomize() with { rst_l == 1'b1; valid_in == 1'b1; scan_mode == 1'b0; csr_ren_in == 1'b0; })
                                `uvm_fatal(get_type_name(), "corner randomization failed")
                        // Choose operands independently so sign combinations and equality vary.
                        req.a_in = corner_value($urandom_range(0, 7));
                        req.b_in = corner_value($urandom_range(0, 7));
                        operation = $urandom_range(BMU_OR, BMU_CSR_READ);
                        select_operation(req, bmu_operation_t'(operation));
                        if (req.ap.lor || req.ap.lxor) req.ap.zbb = $urandom_range(0, 1);
                        if (req.ap.slt) req.ap.unsign = $urandom_range(0, 1);
                        if (req.ap.csr_write) req.ap.csr_imm = $urandom_range(0, 1);
                        send_item(req);
                end
        endtask : body

        function logic [31:0] corner_value(int index);
                case (index)
                        0: return 32'h00000000;
                        1: return 32'hFFFFFFFF;
                        2: return 32'h80000000;
                        3: return 32'h7FFFFFFF;
                        4: return 32'h00000001;
                        5: return 32'hAAAAAAAA;
                        6: return 32'h55555555;
                        default: return 32'h0000001F;
                endcase
        endfunction : corner_value

endclass : bmu_random_corner_weighted_sequence