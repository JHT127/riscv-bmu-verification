
// bmu random legal sequence ===========================================


class bmu_random_legal_sequence extends bmu_base_sequence;

        int unsigned scenario_count = 100;
        `uvm_object_utils(bmu_random_legal_sequence)

        function new(string name = "bmu_random_legal_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                int unsigned operation;

                reset_dut();
                repeat (scenario_count) begin
                        req = bmu_sequence_item::type_id::create("req");
                        if (!req.randomize() with { rst_l == 1'b1; valid_in == 1'b1; scan_mode == 1'b0; csr_ren_in == 1'b0; })
                                `uvm_fatal(get_type_name(), "legal randomization failed")
                        operation = $urandom_range(BMU_OR, BMU_CSR_READ);
                        select_operation(req, bmu_operation_t'(operation));
                        if (req.ap.lor || req.ap.lxor) req.ap.zbb = $urandom_range(0, 1);
                        if (req.ap.slt) req.ap.unsign = $urandom_range(0, 1);
                        if (req.ap.csr_write) req.ap.csr_imm = $urandom_range(0, 1);
                        send_item(req);
                end
        endtask : body

endclass : bmu_random_legal_sequence