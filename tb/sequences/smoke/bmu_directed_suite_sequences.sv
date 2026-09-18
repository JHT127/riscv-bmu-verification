// bmu executable directed suite sequences ===================================

class bmu_nominal_directed_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_nominal_directed_sequence)

        function new(string name = "bmu_nominal_directed_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_or_valid_sequence::type_id::create("or_valid").start(m_sequencer);
                bmu_xor_valid_sequence::type_id::create("xor_valid").start(m_sequencer);
                bmu_srl_valid_sequence::type_id::create("srl_valid").start(m_sequencer);
                bmu_sra_valid_sequence::type_id::create("sra_valid").start(m_sequencer);
                bmu_ror_valid_sequence::type_id::create("ror_valid").start(m_sequencer);
                bmu_binv_valid_sequence::type_id::create("binv_valid").start(m_sequencer);
                bmu_sub_valid_sequence::type_id::create("sub_valid").start(m_sequencer);
                bmu_slt_signed_sequence::type_id::create("slt_signed").start(m_sequencer);
                bmu_slt_unsigned_sequence::type_id::create("slt_unsigned").start(m_sequencer);
                bmu_ctz_valid_sequence::type_id::create("ctz_valid").start(m_sequencer);
                bmu_cpop_valid_sequence::type_id::create("cpop_valid").start(m_sequencer);
                bmu_sextb_pos_sequence::type_id::create("sextb_pos").start(m_sequencer);
                bmu_max_valid_sequence::type_id::create("max_valid").start(m_sequencer);
                bmu_pack_valid_sequence::type_id::create("pack_valid").start(m_sequencer);
                bmu_grev_valid_sequence::type_id::create("grev_valid").start(m_sequencer);
                bmu_csr_bypass_read_sequence::type_id::create("csr_bypass").start(m_sequencer);
                bmu_csr_write_imm_sequence::type_id::create("csr_write_imm").start(m_sequencer);
                bmu_csr_write_reg_sequence::type_id::create("csr_write_reg").start(m_sequencer);
                bmu_sh2add_valid_sequence::type_id::create("sh2add_valid").start(m_sequencer);
        endtask : body

endclass : bmu_nominal_directed_sequence


class bmu_timing_reset_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_timing_reset_sequence)

        function new(string name = "bmu_timing_reset_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_back_to_back_sequence::type_id::create("back_to_back").start(m_sequencer);
                bmu_latency_check_sequence::type_id::create("latency").start(m_sequencer);
                bmu_valid_in_hold_sequence::type_id::create("valid_hold").start(m_sequencer);
                bmu_reset_clear_sequence::type_id::create("reset_clear").start(m_sequencer);
                bmu_reset_mid_op_sequence::type_id::create("reset_mid_op").start(m_sequencer);
                bmu_scan_mode_sequence::type_id::create("scan_mode").start(m_sequencer);
        endtask : body

endclass : bmu_timing_reset_sequence


class bmu_error_directed_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_error_directed_sequence)

        function new(string name = "bmu_error_directed_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_or_conflict_sequence::type_id::create("or_conflict").start(m_sequencer);
                bmu_xor_csr_conflict_sequence::type_id::create("xor_csr").start(m_sequencer);
                bmu_srl_conflict_sequence::type_id::create("srl_conflict").start(m_sequencer);
                bmu_sra_conflict_sequence::type_id::create("sra_conflict").start(m_sequencer);
                bmu_ror_conflict_sequence::type_id::create("ror_conflict").start(m_sequencer);
                bmu_binv_csr_conflict_sequence::type_id::create("binv_csr").start(m_sequencer);
                bmu_slt_conflict_sequence::type_id::create("slt_conflict").start(m_sequencer);
                bmu_max_conflict_sequence::type_id::create("max_conflict").start(m_sequencer);
                bmu_sh2add_conflict_sequence::type_id::create("sh2add_conflict").start(m_sequencer);
                bmu_sub_zba_misuse_sequence::type_id::create("sub_zba").start(m_sequencer);
                bmu_csr_bitmanip_conflict_sequence::type_id::create("csr_conflict").start(m_sequencer);
                bmu_grev_undefined_sequence::type_id::create("grev_undefined").start(m_sequencer);
        endtask : body

endclass : bmu_error_directed_sequence
