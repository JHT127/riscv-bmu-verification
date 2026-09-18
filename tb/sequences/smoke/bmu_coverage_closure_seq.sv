// bmu functional coverage closure sequence =================================

class bmu_coverage_closure_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_coverage_closure_sequence)

        function new(string name = "bmu_coverage_closure_sequence");
                super.new(name);
        endfunction : new

        task body();
                int operation_index;

                bmu_nominal_directed_sequence::type_id::create("nominal").start(m_sequencer);
                bmu_timing_reset_sequence::type_id::create("timing_reset").start(m_sequencer);
                bmu_error_directed_sequence::type_id::create("errors").start(m_sequencer);
                bmu_gap_checks_sequence::type_id::create("gap_checks").start(m_sequencer);
                bmu_or_invert_sequence::type_id::create("or_invert").start(m_sequencer);
                bmu_xor_invert_sequence::type_id::create("xor_invert").start(m_sequencer);
                bmu_sextb_neg_sequence::type_id::create("sextb_negative").start(m_sequencer);
                bmu_max_signed_sequence::type_id::create("max_signed").start(m_sequencer);
                bmu_max_reversed_sequence::type_id::create("max_reversed").start(m_sequencer);
                bmu_ctz_zero_sequence::type_id::create("ctz_zero").start(m_sequencer);
                bmu_ctz_ones_sequence::type_id::create("ctz_ones").start(m_sequencer);
                bmu_cpop_corner_sequence::type_id::create("cpop_corner").start(m_sequencer);
                bmu_grev_undefined_sequence::type_id::create("grev_undefined").start(m_sequencer);
                bmu_sh2add_no_zba_sequence::type_id::create("sh2add_no_zba").start(m_sequencer);

                for (operation_index = 0; operation_index < 17; operation_index++) begin
                        send_operation_case(operation_index, 1'b0, 1'b0);
                        if (operation_index < 16)
                                send_operation_case(operation_index, 1'b1, 1'b1);
                end
        endtask : body

        task send_operation_case(int operation_index, bit valid_in, bit csr_ren_in);
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("coverage_cross");
                initialize_item(req);
                req.valid_in = valid_in;
                req.csr_ren_in = csr_ren_in;
                case (operation_index)
                        0: req.ap.lor = 1'b1;
                        1: req.ap.lxor = 1'b1;
                        2: req.ap.srl = 1'b1;
                        3: req.ap.sra = 1'b1;
                        4: req.ap.ror = 1'b1;
                        5: req.ap.binv = 1'b1;
                        6: req.ap.sh2add = 1'b1;
                        7: req.ap.sub = 1'b1;
                        8: begin req.ap.slt = 1'b1; req.ap.sub = 1'b1; end
                        9: req.ap.ctz = 1'b1;
                        10: req.ap.cpop = 1'b1;
                        11: req.ap.siext_b = 1'b1;
                        12: req.ap.max = 1'b1;
                        13: req.ap.pack = 1'b1;
                        14: req.ap.grev = 1'b1;
                        15: req.ap.csr_write = 1'b1;
                        16: req.csr_ren_in = 1'b0;
                endcase
                send_item(req);
        endtask : send_operation_case

endclass : bmu_coverage_closure_sequence