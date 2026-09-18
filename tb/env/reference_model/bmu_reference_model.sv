
// bmu reference model ===========================================


class bmu_reference_model extends uvm_component;


        // Declaring ------------------------------
                uvm_analysis_imp #(bmu_sequence_item, bmu_reference_model) input_port;
                uvm_analysis_port #(bmu_sequence_item) expected_port;
                logic [31:0] expected_result_ff;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_reference_model)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                input_port = new("input_port", this);
                expected_port = new("expected_port", this);
                expected_result_ff = '0;

        endfunction : build_phase



        // write method ----------------------------------------
        function void write(bmu_sequence_item item);
                bmu_sequence_item expected_item;
                logic [31:0] combinational_result;
                logic        combinational_error;

                expected_item = bmu_sequence_item::type_id::create("expected_item");
                calculate(item, combinational_result, combinational_error);

                if (!item.rst_l)
                        expected_result_ff = '0;
                else if (item.valid_in)
                        expected_result_ff = combinational_result;

                expected_item.copy(item);
                expected_item.result_ff = expected_result_ff;
                expected_item.error = combinational_error;

                expected_port.write(expected_item);
        endfunction : write



        // calculate function ----------------------------------------
        function automatic void calculate(
                bmu_sequence_item item,
                output logic [31:0] result,
                output logic        error
        );
                int unsigned shift_amount;
                int unsigned count;
                int unsigned index;

                result = '0;
                error = 1'b0;
                shift_amount = item.b_in[4:0];

                if (!item.rst_l) begin
                        return;
                end

                if (item.csr_ren_in && (|item.ap)) begin
                        error = 1'b1;
                        return;
                end

                if (item.csr_ren_in && !(|item.ap)) begin
                        result = item.csr_rddata_in;
                        return;
                end

                if (operation_count(item.ap) != 1) begin
                        error = 1'b1;
                        return;
                end

                if (item.ap.lor) begin
                        if (!only_zbb(item.ap) && !item.ap.land) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in | (item.ap.zbb ? ~item.b_in : item.b_in);
                end
                else if (item.ap.lxor) begin
                        if (!only_zbb(item.ap) && !item.ap.land) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in ^ (item.ap.zbb ? ~item.b_in : item.b_in);
                end
                else if (item.ap.land) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in & item.b_in;
                end
                else if (item.ap.sll) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in << shift_amount;
                end
                else if (item.ap.srl) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in >> shift_amount;
                end
                else if (item.ap.sra) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = $signed(item.a_in) >>> shift_amount;
                end
                else if (item.ap.ror) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = (item.a_in >> shift_amount) |
                                 (item.a_in << ((32 - shift_amount) & 5'h1f));
                end
                else if (item.ap.bset) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in | (32'b1 << shift_amount);
                end
                else if (item.ap.bclr) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in & ~(32'b1 << shift_amount);
                end
                else if (item.ap.binv) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in ^ (32'b1 << shift_amount);
                end
                else if (item.ap.bext) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = {{31{1'b0}}, item.a_in[shift_amount]};
                end
                else if (item.ap.sh1add) begin
                        if (!only_zba(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = (item.a_in << 1) + item.b_in;
                end
                else if (item.ap.sh2add) begin
                        if (!only_zba(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = (item.a_in << 2) + item.b_in;
                end
                else if (item.ap.sh3add) begin
                        if (!only_zba(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = (item.a_in << 3) + item.b_in;
                end
                else if (item.ap.slt && item.ap.sub) begin
                        if (!only_unsign(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.ap.unsign ?
                                 ((item.a_in < item.b_in) ? 32'd1 : 32'd0) :
                                 (($signed(item.a_in) < $signed(item.b_in)) ? 32'd1 : 32'd0);
                end
                else if (item.ap.sub && !item.ap.slt && !item.ap.max) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.a_in - item.b_in;
                end
                else if (item.ap.ctz) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        count = 32;
                        for (index = 0; index < 32; index++) begin
                                if (item.a_in[index]) begin
                                        count = index;
                                        break;
                                end
                        end
                        result = count;
                end
                else if (item.ap.cpop) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        count = 0;
                        for (index = 0; index < 32; index++)
                                count += item.a_in[index];
                        result = count;
                end
                else if (item.ap.siext_b) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = {{24{item.a_in[7]}}, item.a_in[7:0]};
                end
                else if (item.ap.max && item.ap.sub) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = ($signed(item.a_in) > $signed(item.b_in)) ?
                                 item.a_in : item.b_in;
                end
                else if (item.ap.pack) begin
                        if (!no_modes(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = {item.b_in[15:0], item.a_in[15:0]};
                end
                else if (item.ap.grev) begin
                        if (!no_modes(item.ap) || shift_amount != 24) begin
                                error = 1'b1;
                                return;
                        end
                        result = {item.a_in[7:0], item.a_in[15:8],
                                  item.a_in[23:16], item.a_in[31:24]};
                end
                else if (item.ap.csr_write) begin
                        if (!only_csr_imm(item.ap)) begin
                                error = 1'b1;
                                return;
                        end
                        result = item.ap.csr_imm ? item.b_in : item.a_in;
                end
                else begin
                        error = 1'b1;
                end
        endfunction : calculate



        // control helpers ----------------------------------------
        function automatic int unsigned operation_count(bmu_ctrl_t ap);
                operation_count = ap.lor + ap.lxor + ap.land + ap.sll + ap.srl + ap.sra + ap.ror +
                                   ap.bset + ap.bclr + ap.binv + ap.bext + ap.sh1add + ap.sh2add + ap.sh3add +
                                   ap.slt + ap.ctz + ap.cpop + ap.siext_b + ap.max + ap.pack + ap.grev +
                                   ap.csr_write + (ap.sub && !ap.slt && !ap.max) + ap.zba + ap.zbb + ap.packu + ap.packh;
        endfunction : operation_count


        function automatic bit no_modes(bmu_ctrl_t ap);
                no_modes = !ap.zbb && !ap.zba && !ap.unsign && !ap.csr_imm;
        endfunction : no_modes


        function automatic bit only_zbb(bmu_ctrl_t ap);
                only_zbb = !ap.zba && !ap.unsign && !ap.csr_imm;
        endfunction : only_zbb


        function automatic bit only_zba(bmu_ctrl_t ap);
                only_zba = ap.zba && !ap.zbb && !ap.unsign && !ap.csr_imm;
        endfunction : only_zba


        function automatic bit only_unsign(bmu_ctrl_t ap);
                only_unsign = !ap.zbb && !ap.zba && !ap.csr_imm;
        endfunction : only_unsign


        function automatic bit only_csr_imm(bmu_ctrl_t ap);
                only_csr_imm = !ap.zbb && !ap.zba && !ap.unsign;
        endfunction : only_csr_imm


endclass : bmu_reference_model