// bmu functional coverage ===========================================

class bmu_coverage extends uvm_subscriber #(bmu_sequence_item);

        `uvm_component_utils(bmu_coverage)

        int unsigned sample_count;

        covergroup bmu_covergroup with function sample(bmu_sequence_item item);
                option.per_instance = 1;
                cp_operation: coverpoint operation_code(item) {
                        bins lor = {0};
                        bins lxor = {1};
                        bins srl = {2};
                        bins sra = {3};
                        bins ror = {4};
                        bins binv = {5};
                        bins sh2add = {6};
                        bins sub = {7};
                        bins slt = {8};
                        bins ctz = {9};
                        bins cpop = {10};
                        bins siext_b = {11};
                        bins max = {12};
                        bins pack = {13};
                        bins grev = {14};
                        bins csr_write = {15};
                        bins csr_read = {16};
                        bins invalid = {17};
                }
                cp_zbb: coverpoint item.ap.zbb iff (item.ap.lor || item.ap.lxor) {
                        bins disabled = {0};
                        bins enabled = {1};
                }
                cp_shift_amount: coverpoint item.b_in[4:0] iff
                        (item.ap.srl || item.ap.sra || item.ap.ror) {
                        bins all[] = {[0:31]};
                }
                cp_binv_position: coverpoint item.b_in[4:0] iff item.ap.binv {
                        bins all[] = {[0:31]};
                }
                cp_count_result: coverpoint expected_count(item) iff
                        (item.ap.ctz || item.ap.cpop) {
                        bins all[] = {[0:32]};
                }
                cp_operand_sign: coverpoint item.a_in[31] iff
                        (item.ap.siext_b || item.ap.slt || item.ap.max) {
                        bins positive = {0};
                        bins negative = {1};
                }
                cp_slt_unsigned: coverpoint item.ap.unsign iff item.ap.slt {
                        bins signed_mode = {0};
                        bins unsigned_mode = {1};
                }
                cp_grev_encoding: coverpoint item.b_in[4:0] iff item.ap.grev {
                        bins valid = {24};
                        bins invalid = default;
                }
                cp_csr_mode: coverpoint csr_mode(item) {
                        bins bypass = {0};
                        bins write_imm = {1};
                        bins write_reg = {2};
                        bins conflict = {3};
                }
                cp_valid: coverpoint item.valid_in {
                        bins idle = {0};
                        bins valid = {1};
                }
                cp_reset: coverpoint item.rst_l {
                        bins reset = {0};
                        bins active = {1};
                }
                cp_scan: coverpoint item.scan_mode {
                        bins functional = {0};
                        bins scan = {1};
                }
                cp_error: coverpoint expected_error(item) {
                        bins clean = {0};
                        bins rejected = {1};
                }
                operation_x_error: cross cp_operation, cp_error {
                        ignore_bins csr_read = binsof(cp_operation.csr_read);
                        ignore_bins invalid = binsof(cp_operation.invalid);
                }
                operation_x_valid: cross cp_operation, cp_valid;
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

        function int operation_code(bmu_sequence_item item);
                if (item.csr_ren_in && item.ap == '0)
                        return 16;
                if (item.ap.csr_write)
                        return 15;
                if (item.ap.lor)
                        return 0;
                if (item.ap.lxor)
                        return 1;
                if (item.ap.srl)
                        return 2;
                if (item.ap.sra)
                        return 3;
                if (item.ap.ror)
                        return 4;
                if (item.ap.binv)
                        return 5;
                if (item.ap.sh2add)
                        return 6;
                if (item.ap.slt)
                        return 8;
                if (item.ap.sub)
                        return 7;
                if (item.ap.ctz)
                        return 9;
                if (item.ap.cpop)
                        return 10;
                if (item.ap.siext_b)
                        return 11;
                if (item.ap.max)
                        return 12;
                if (item.ap.pack)
                        return 13;
                if (item.ap.grev)
                        return 14;
                return 17;
        endfunction : operation_code

        function int csr_mode(bmu_sequence_item item);
                if (item.csr_ren_in && item.ap != '0)
                        return 3;
                if (item.csr_ren_in)
                        return 0;
                if (item.ap.csr_write && item.ap.csr_imm)
                        return 1;
                if (item.ap.csr_write)
                        return 2;
                return 0;
        endfunction : csr_mode

        function int expected_count(bmu_sequence_item item);
                int index;

                if (item.ap.ctz) begin
                        expected_count = 32;
                        for (index = 0; index < 32; index++) begin
                                if (item.a_in[index]) begin
                                        expected_count = index;
                                        break;
                                end
                        end
                end
                else begin
                        expected_count = 0;
                        for (index = 0; index < 32; index++)
                                expected_count += item.a_in[index];
                end
        endfunction : expected_count

        function bit expected_error(bmu_sequence_item item);
                expected_error = 1'b0;
                if (item.csr_ren_in && (|item.ap))
                        expected_error = 1'b1;
                else if (!item.csr_ren_in && (operation_code(item) == 17))
                        expected_error = 1'b1;
                else if (!item.csr_ren_in && (primary_count(item.ap) != 1))
                        expected_error = 1'b1;
        endfunction : expected_error

        function int primary_count(bmu_ctrl_t ap);
                primary_count = ap.lor + ap.lxor + ap.srl + ap.sra + ap.ror +
                                ap.binv + ap.sh2add + ap.slt + ap.ctz + ap.cpop +
                                ap.siext_b + ap.max + ap.pack + ap.grev +
                                ap.csr_write + (ap.sub && !ap.slt && !ap.max);
        endfunction : primary_count

        function void report_phase(uvm_phase phase);
                super.report_phase(phase);
                `uvm_info(get_type_name(), $sformatf(
                        "functional coverage=%0.2f%% samples=%0d",
                        bmu_covergroup.get_coverage(), sample_count), UVM_LOW)
        endfunction : report_phase

endclass : bmu_coverage
