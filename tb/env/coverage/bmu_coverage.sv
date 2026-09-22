// bmu functional coverage ===========================================

class bmu_coverage extends uvm_subscriber #(bmu_sequence_item);

        `uvm_component_utils(bmu_coverage)

        int unsigned sample_count;

        covergroup bmu_covergroup with function sample(bmu_sequence_item item);
                option.per_instance = 1;

                cp_operation: coverpoint bmu_operation_code(item.ap, item.csr_ren_in)
                        iff (legal_operation(item) && item.valid_in) {
                        bins operations[] = {[BMU_OR:BMU_CSR_READ]};
                }
                cp_request: coverpoint bmu_operation_code(item.ap, item.csr_ren_in) iff (item.rst_l) {
                        bins operations[] = {[BMU_OR:BMU_CSR_READ]};
                        bins invalid = {BMU_INVALID};
                }
                cp_error: coverpoint expected_error(item) iff (item.rst_l) {
                        bins clean = {0};
                        bins rejected = {1};
                }
                request_x_error: cross cp_request, cp_error {
                        ignore_bins read_error = binsof(cp_request) intersect {BMU_CSR_READ} && binsof(cp_error.rejected);
                        ignore_bins invalid_clean = binsof(cp_request.invalid) && binsof(cp_error.clean);
                }
                cp_valid: coverpoint item.valid_in iff (item.rst_l) {
                        bins idle = {0};
                        bins valid = {1};
                }
                request_x_valid: cross cp_request, cp_valid;
                cp_reset: coverpoint item.rst_l {
                        bins reset = {0};
                        bins active = {1};
                        bins asserted = (1 => 0);
                        bins released = (0 => 1);
                }
                cp_zbb: coverpoint item.ap.zbb iff
                        (legal_operation(item) && item.valid_in && (item.ap.lor || item.ap.lxor)) {
                        bins disabled = {0};
                        bins enabled = {1};
                }
                cp_logic_operation: coverpoint bmu_operation_code(item.ap, item.csr_ren_in) iff
                        (legal_operation(item) && item.valid_in && (item.ap.lor || item.ap.lxor)) {
                        bins operations[] = {BMU_OR, BMU_XOR};
                }
                logic_x_zbb: cross cp_logic_operation, cp_zbb;
                cp_shift_operation: coverpoint bmu_operation_code(item.ap, item.csr_ren_in) iff
                        (legal_operation(item) && item.valid_in && (item.ap.srl || item.ap.sra || item.ap.ror || item.ap.binv)) {
                        bins operations[] = {BMU_SRL, BMU_SRA, BMU_ROR, BMU_BINV};
                }
                cp_shift_amount: coverpoint item.b_in[4:0] iff
                        (legal_operation(item) && item.valid_in && (item.ap.srl || item.ap.sra || item.ap.ror || item.ap.binv)) {
                        bins amounts[] = {[0:31]};
                }
                shift_x_amount: cross cp_shift_operation, cp_shift_amount;
                cp_binv_value: coverpoint item.a_in[item.b_in[4:0]] iff
                        (legal_operation(item) && item.valid_in && item.ap.binv) {
                        bins clear = {0};
                        bins set = {1};
                }
                cp_count_operation: coverpoint bmu_operation_code(item.ap, item.csr_ren_in) iff
                        (legal_operation(item) && item.valid_in && (item.ap.ctz || item.ap.cpop)) {
                        bins operations[] = {BMU_CTZ, BMU_CPOP};
                }
                cp_count_result: coverpoint expected_count(item) iff
                        (legal_operation(item) && item.valid_in && (item.ap.ctz || item.ap.cpop)) {
                        bins counts[] = {[0:32]};
                }
                count_x_result: cross cp_count_operation, cp_count_result;
                cp_operand_pattern: coverpoint operand_pattern(item.a_in) iff
                        (legal_operation(item) && item.valid_in) {
                        bins patterns[] = {[0:6]};
                }
                operation_x_pattern: cross cp_operation, cp_operand_pattern;
                cp_compare_signs: coverpoint {item.a_in[31], item.b_in[31]} iff
                        (legal_operation(item) && item.valid_in && (item.ap.slt || item.ap.max)) {
                        bins signs[] = {[0:3]};
                }
                cp_compare_relation: coverpoint comparison_relation(item) iff
                        (legal_operation(item) && item.valid_in && (item.ap.slt || item.ap.max)) {
                        bins less = {0};
                        bins equal = {1};
                        bins greater = {2};
                }
                cp_slt_unsigned: coverpoint item.ap.unsign iff
                        (legal_operation(item) && item.valid_in && item.ap.slt) {
                        bins signed_mode = {0};
                        bins unsigned_mode = {1};
                }
                cp_sext_signs: coverpoint {item.a_in[31], item.a_in[7]} iff
                        (legal_operation(item) && item.valid_in && item.ap.siext_b) {
                        bins signs[] = {[0:3]};
                }
                cp_grev_encoding: coverpoint item.b_in[4:0] iff
                        (item.rst_l && item.valid_in && item.ap.grev) {
                        bins valid = {24};
                        bins invalid[] = {[0:23], [25:31]};
                }
                cp_csr_mode: coverpoint csr_mode(item) iff
                        (legal_operation(item) && item.valid_in && (item.csr_ren_in || item.ap.csr_write)) {
                        bins bypass = {0};
                        bins write_reg = {1};
                        bins write_imm = {2};
                }
        endgroup

        function new(string name, uvm_component parent);
                super.new(name, parent);
                sample_count = 0;
                bmu_covergroup = new();
        endfunction : new

        function void write(bmu_sequence_item t);
                sample_count++;
                bmu_covergroup.sample(t);
        endfunction : write

        function bit legal_operation(bmu_sequence_item item);
                return item.rst_l && bmu_legal_controls(item.ap, item.csr_ren_in, item.b_in[4:0]);
        endfunction : legal_operation

        function bit expected_error(bmu_sequence_item item);
                return item.rst_l && !bmu_legal_controls(item.ap, item.csr_ren_in, item.b_in[4:0]);
        endfunction : expected_error

        function int csr_mode(bmu_sequence_item item);
                if (item.csr_ren_in) return 0;
                return item.ap.csr_imm ? 2 : 1;
        endfunction : csr_mode

        function int expected_count(bmu_sequence_item item);
                if (item.ap.ctz) begin
                        for (int index = 0; index < 32; index++)
                                if (item.a_in[index]) return index;
                        return 32;
                end
                return $countones(item.a_in);
        endfunction : expected_count

        function int operand_pattern(logic [31:0] value);
                if (value == 0) return 0;
                if (value == 32'hFFFFFFFF) return 1;
                if (value == 32'h80000000) return 2;
                if (value == 1) return 3;
                if (value == 32'hAAAAAAAA || value == 32'h55555555) return 4;
                if ($onehot(value)) return 5;
                return 6;
        endfunction : operand_pattern

        function int comparison_relation(bmu_sequence_item item);
                if (item.a_in == item.b_in) return 1;
                if (item.ap.slt && item.ap.unsign)
                        return item.a_in < item.b_in ? 0 : 2;
                return $signed(item.a_in) < $signed(item.b_in) ? 0 : 2;
        endfunction : comparison_relation

        function void report_phase(uvm_phase phase);
                super.report_phase(phase);
                `uvm_info(get_type_name(), $sformatf(
                        "functional coverage=%0.2f%% samples=%0d",
                        bmu_covergroup.get_inst_coverage(), sample_count), UVM_LOW)
        endfunction : report_phase

endclass : bmu_coverage
