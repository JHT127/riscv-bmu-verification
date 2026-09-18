
// bmu package ===========================================


package bmu_pkg;

        import uvm_pkg::*;
        import bmu_types_package::*;
        `include "uvm_macros.svh"


        // sequence item ----------------------------------------
        `include "../env/agents/bmu_agent/bmu_sequence_item.sv"


        // sequencer + driver ----------------------------------------
        `include "../env/agents/bmu_agent/sequencer/bmu_sequencer.sv"
        `include "../env/agents/bmu_agent/driver/bmu_driver.sv"


        // monitor ----------------------------------------
        `include "../env/agents/bmu_agent/monitor/bmu_monitor.sv"


        // agent ----------------------------------------
        `include "../env/agents/bmu_agent/bmu_agent.sv"


        // reference model ----------------------------------------
        `include "../env/reference_model/bmu_reference_model.sv"


        // checker + scoreboard ----------------------------------------
        `include "../env/scoreboard/bmu_checker.sv"
        `include "../env/scoreboard/bmu_scoreboard.sv"


        // environment ----------------------------------------
        `include "../env/bmu_environment.sv"


        // base sequence ----------------------------------------
        `include "../sequences/base/bmu_base_sequence.sv"


        // family base sequences ----------------------------------------
        `include "../sequences/logic_ops/bmu_logic_base_sequence.sv"
        `include "../sequences/shift_ops/bmu_shift_base_sequence.sv"
        `include "../sequences/bit_ops/bmu_bit_ops_base_sequence.sv"
        `include "../sequences/count_ops/bmu_count_base_sequence.sv"
        `include "../sequences/sign_extend_ops/bmu_sign_extend_base_sequence.sv"
        `include "../sequences/minmax_ops/bmu_minmax_base_sequence.sv"
        `include "../sequences/pack_ops/bmu_pack_base_sequence.sv"
        `include "../sequences/csr_ops/bmu_csr_base_sequence.sv"
        `include "../sequences/zba_ops/bmu_zba_base_sequence.sv"
        `include "../sequences/error_injection/bmu_error_injection_base_sequence.sv"
        `include "../sequences/reset_ops/bmu_reset_base_sequence.sv"


        // logic sequences ----------------------------------------
        `include "../sequences/logic_ops/or_valid_seq.sv"
        `include "../sequences/logic_ops/or_invert_seq.sv"
        `include "../sequences/logic_ops/xor_valid_seq.sv"
        `include "../sequences/logic_ops/xor_invert_seq.sv"


        // shift sequences ----------------------------------------
        `include "../sequences/shift_ops/srl_valid_seq.sv"
        `include "../sequences/shift_ops/srl_corner_seq.sv"
        `include "../sequences/shift_ops/sra_valid_seq.sv"
        `include "../sequences/shift_ops/sra_corner_seq.sv"
        `include "../sequences/shift_ops/ror_valid_seq.sv"
        `include "../sequences/shift_ops/ror_corner_seq.sv"


        // bit operation sequences ----------------------------------------
        `include "../sequences/bit_ops/binv_valid_seq.sv"
        `include "../sequences/bit_ops/binv_corner_seq.sv"


        // arithmetic and comparison sequences ----------------------------------------
        `include "../sequences/base/sub_valid_seq.sv"
        `include "../sequences/base/sub_corner_seq.sv"
        `include "../sequences/base/slt_signed_seq.sv"
        `include "../sequences/base/slt_unsigned_seq.sv"
        `include "../sequences/base/slt_equal_seq.sv"


        // count sequences ----------------------------------------
        `include "../sequences/count_ops/ctz_valid_seq.sv"
        `include "../sequences/count_ops/ctz_zero_seq.sv"
        `include "../sequences/count_ops/ctz_ones_seq.sv"
        `include "../sequences/count_ops/cpop_valid_seq.sv"
        `include "../sequences/count_ops/cpop_corner_seq.sv"


        // sign extension sequences ----------------------------------------
        `include "../sequences/sign_extend_ops/sextb_pos_seq.sv"
        `include "../sequences/sign_extend_ops/sextb_neg_seq.sv"


        // minmax sequences ----------------------------------------
        `include "../sequences/minmax_ops/max_valid_seq.sv"
        `include "../sequences/minmax_ops/max_reversed_seq.sv"
        `include "../sequences/minmax_ops/max_signed_seq.sv"


        // pack sequences ----------------------------------------
        `include "../sequences/pack_ops/pack_valid_seq.sv"
        `include "../sequences/pack_ops/pack_corner_seq.sv"
        `include "../sequences/pack_ops/grev_valid_seq.sv"
        `include "../sequences/pack_ops/grev_undefined_seq.sv"


        // csr sequences ----------------------------------------
        `include "../sequences/csr_ops/csr_bypass_read_seq.sv"
        `include "../sequences/csr_ops/csr_write_imm_seq.sv"
        `include "../sequences/csr_ops/csr_write_reg_seq.sv"
        `include "../sequences/csr_ops/csr_bitmanip_conflict_seq.sv"


        // zba sequences ----------------------------------------
        `include "../sequences/zba_ops/sh2add_valid_seq.sv"
        `include "../sequences/zba_ops/sh2add_no_zba_seq.sv"


        // error injection sequences ----------------------------------------
        `include "../sequences/error_injection/or_conflict_seq.sv"
        `include "../sequences/error_injection/xor_csr_conflict_seq.sv"
        `include "../sequences/error_injection/srl_conflict_seq.sv"
        `include "../sequences/error_injection/sra_conflict_seq.sv"
        `include "../sequences/error_injection/ror_conflict_seq.sv"
        `include "../sequences/error_injection/binv_csr_conflict_seq.sv"
        `include "../sequences/error_injection/sh2add_conflict_seq.sv"
        `include "../sequences/error_injection/sub_zba_misuse_seq.sv"
        `include "../sequences/error_injection/slt_conflict_seq.sv"
        `include "../sequences/error_injection/ctz_csr_conflict_seq.sv"
        `include "../sequences/error_injection/cpop_conflict_seq.sv"
        `include "../sequences/error_injection/sextb_csr_conflict_seq.sv"
        `include "../sequences/error_injection/max_conflict_seq.sv"
        `include "../sequences/error_injection/pack_csr_conflict_seq.sv"
        `include "../sequences/error_injection/grev_csr_conflict_seq.sv"
        `include "../sequences/error_injection/random_error_seq.sv"


        // reset and timing sequences ----------------------------------------
        `include "../sequences/reset_ops/latency_check_seq.sv"
        `include "../sequences/reset_ops/valid_in_hold_seq.sv"
        `include "../sequences/reset_ops/back_to_back_seq.sv"
        `include "../sequences/reset_ops/reset_clear_seq.sv"
        `include "../sequences/reset_ops/reset_mid_op_seq.sv"
        `include "../sequences/reset_ops/scan_mode_seq.sv"


        // random sequences ----------------------------------------
        `include "../sequences/base/random_legal_seq.sv"
        `include "../sequences/base/random_corner_weighted_seq.sv"


        // tests ----------------------------------------
        `include "../tests/bmu_base_test.sv"
        `include "../tests/bmu_or_valid_test.sv"


endpackage : bmu_pkg