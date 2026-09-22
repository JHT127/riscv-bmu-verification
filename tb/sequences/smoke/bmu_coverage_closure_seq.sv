// bmu functional coverage closure sequence =================================

class bmu_coverage_closure_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_coverage_closure_sequence)

        function new(string name = "bmu_coverage_closure_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                logic [31:0] edge_values[8];

                edge_values = '{32'h00000000, 32'hFFFFFFFF, 32'h80000000, 32'h00000001,
                                32'hAAAAAAAA, 32'h00000100, 32'h12345678, 32'h7FFFFFFF};
                bmu_nominal_directed_sequence::type_id::create("nominal").start(m_sequencer);
                bmu_timing_reset_sequence::type_id::create("timing_reset").start(m_sequencer);
                bmu_error_directed_sequence::type_id::create("errors").start(m_sequencer);
                bmu_gap_checks_sequence::type_id::create("gaps").start(m_sequencer);
                bmu_guard_matrix_sequence::type_id::create("guards").start(m_sequencer);

                // Every supported operation, operand class, and valid state.
                for (int operation = BMU_OR; operation <= BMU_CSR_READ; operation++) begin
                        foreach (edge_values[index]) begin
                                for (int valid_value = 0; valid_value < 2; valid_value++) begin
                                        req = bmu_sequence_item::type_id::create("operation_pattern");
                                        initialize_item(req);
                                        req.a_in = edge_values[index];
                                        req.b_in = ~edge_values[index];
                                        req.csr_rddata_in = edge_values[index];
                                        req.valid_in = valid_value;
                                        select_operation(req, bmu_operation_t'(operation));
                                        send_item(req);
                                        if (operation == BMU_OR || operation == BMU_XOR) begin
                                                req.ap.zbb = 1'b1;
                                                send_item(req);
                                        end
                                        if (operation == BMU_CSR_WRITE) begin
                                                req.ap.csr_imm = 1'b1;
                                                send_item(req);
                                        end
                                end
                        end
                end

                // All bit positions, both source-bit values, and ignored upper amount bits.
                for (int operation = BMU_SRL; operation <= BMU_BINV; operation++) begin
                        for (int amount = 0; amount < 32; amount++) begin
                                foreach (edge_values[index]) begin
                                        req = bmu_sequence_item::type_id::create("shift_position");
                                        initialize_item(req);
                                        req.a_in = edge_values[index];
                                        req.b_in = amount;
                                        select_operation(req, bmu_operation_t'(operation));
                                        send_item(req);
                                        req.b_in = 32'hA5A5FFE0 | amount;
                                        send_item(req);
                                end
                        end
                end

                // Each count with different spatial distributions of the set bits.
                for (int count = 0; count <= 32; count++) begin
                        req = bmu_sequence_item::type_id::create("count_pattern");
                        initialize_item(req);
                        select_operation(req, BMU_CPOP);
                        req.a_in = 32'hFFFFFFFF >> (32 - count);
                        send_item(req);
                        req.a_in = 32'hFFFFFFFF << (32 - count);
                        send_item(req);
                        select_operation(req, BMU_CTZ);
                        req.a_in = 32'b1 << count;
                        send_item(req);
                        req.a_in = 32'hFFFFFFFF << count;
                        send_item(req);
                end

                // Signed/unsigned ordering, equality, sign boundaries, borrow, and wraparound.
                foreach (edge_values[a_index]) begin
                        foreach (edge_values[b_index]) begin
                                for (int operation = 0; operation < 5; operation++) begin
                                        req = bmu_sequence_item::type_id::create("comparison_boundary");
                                        initialize_item(req);
                                        req.a_in = edge_values[a_index];
                                        req.b_in = edge_values[b_index];
                                        case (operation)
                                                0: select_operation(req, BMU_SLT);
                                                1: begin select_operation(req, BMU_SLT); req.ap.unsign = 1'b1; end
                                                2: select_operation(req, BMU_MAX);
                                                3: select_operation(req, BMU_SUB);
                                                4: select_operation(req, BMU_SH2ADD);
                                        endcase
                                        send_item(req);
                                end
                        end
                end

                // Byte sign is independent of the discarded upper bits.
                for (int byte_value = 0; byte_value < 256; byte_value++) begin
                        req = bmu_sequence_item::type_id::create("sext_byte");
                        initialize_item(req);
                        select_operation(req, BMU_SEXTB);
                        req.a_in = byte_value;
                        send_item(req);
                        req.a_in = 32'hFFFF0000 | byte_value;
                        send_item(req);
                end

                // All GREV encodings, including the adopted invalid-encoding rule.
                for (int amount = 0; amount < 32; amount++) begin
                        req = bmu_sequence_item::type_id::create("grev_encoding");
                        initialize_item(req);
                        select_operation(req, BMU_GREV);
                        req.a_in = 32'h12345678;
                        req.b_in = amount;
                        send_item(req);
                end
                reset_dut();
        endtask : body

endclass : bmu_coverage_closure_sequence
