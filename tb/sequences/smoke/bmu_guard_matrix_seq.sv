// bmu forbidden-control matrix ===========================================

class bmu_guard_matrix_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_guard_matrix_sequence)

        function new(string name = "bmu_guard_matrix_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                bmu_ctrl_t controls;
                bmu_ctrl_t allowed;

                reset_dut();
                for (int operation = BMU_OR; operation <= BMU_CSR_READ; operation++) begin
                        for (int valid_value = 0; valid_value < 2; valid_value++) begin
                                req = bmu_sequence_item::type_id::create("legal_request");
                                initialize_item(req);
                                req.valid_in = valid_value;
                                req.a_in = 32'h89ABCDEF;
                                req.b_in = 32'h12345678;
                                req.csr_rddata_in = 32'hDEADBEEF;
                                select_operation(req, bmu_operation_t'(operation));
                                controls = req.ap;
                                allowed = controls;
                                if (operation == BMU_OR || operation == BMU_XOR) allowed.zbb = 1'b1;
                                if (operation == BMU_SLT) allowed.unsign = 1'b1;
                                if (operation == BMU_CSR_WRITE) allowed.csr_imm = 1'b1;
                                // Adding SLT/MAX changes SUB into a legal comparison.
                                if (operation == BMU_SUB) begin allowed.slt = 1'b1; allowed.max = 1'b1; end
                                send_item(req);
                                for (int field_index = 0; field_index < $bits(bmu_ctrl_t); field_index++) begin
                                        if (!allowed[field_index]) begin
                                                req.ap = controls;
                                                req.ap[field_index] = 1'b1;
                                                `uvm_info(get_type_name(), $sformatf(
                                                        "guard operation=%0d forbidden_bit=%0d valid=%0d",
                                                        operation, field_index, valid_value), UVM_HIGH)
                                                send_item(req);
                                        end
                                end
                                req.ap = controls;
                                if (operation != BMU_CSR_READ) begin
                                        req.csr_ren_in = 1'b1;
                                        send_item(req);
                                        req.csr_ren_in = 1'b0;
                                end
                                if (operation == BMU_SH2ADD) begin
                                        req.ap.zba = 1'b0;
                                        send_item(req);
                                end
                                if (operation == BMU_SLT || operation == BMU_MAX) begin
                                        req.ap.sub = 1'b0;
                                        send_item(req);
                                end
                        end
                end
        endtask : body

endclass : bmu_guard_matrix_sequence
