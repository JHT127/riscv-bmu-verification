
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

                if (!bmu_legal_controls(item.ap, item.csr_ren_in, item.b_in[4:0])) begin
                        error = 1'b1;
                        return;
                end

                case (bmu_operation_code(item.ap, item.csr_ren_in))
                        BMU_OR: result = item.a_in | (item.ap.zbb ? ~item.b_in : item.b_in);
                        BMU_XOR: result = item.a_in ^ (item.ap.zbb ? ~item.b_in : item.b_in);
                        BMU_SRL: result = item.a_in >> shift_amount;
                        BMU_SRA: result = $signed(item.a_in) >>> shift_amount;
                        BMU_ROR: result = (item.a_in >> shift_amount) |
                                         (item.a_in << ((32 - shift_amount) & 5'h1f));
                        BMU_BINV: result = item.a_in ^ (32'b1 << shift_amount);
                        BMU_SH2ADD: result = (item.a_in << 2) + item.b_in;
                        BMU_SUB: result = item.a_in - item.b_in;
                        BMU_SLT: result = item.ap.unsign ?
                                         ((item.a_in < item.b_in) ? 32'd1 : 32'd0) :
                                         (($signed(item.a_in) < $signed(item.b_in)) ? 32'd1 : 32'd0);
                        BMU_CTZ: begin
                                count = 32;
                                for (index = 0; index < 32; index++) begin
                                        if (item.a_in[index]) begin
                                                count = index;
                                                break;
                                        end
                                end
                                result = count;
                        end
                        BMU_CPOP: begin
                                count = 0;
                                for (index = 0; index < 32; index++)
                                        count += item.a_in[index];
                                result = count;
                        end
                        BMU_SEXTB: result = {{24{item.a_in[7]}}, item.a_in[7:0]};
                        BMU_MAX: result = ($signed(item.a_in) > $signed(item.b_in)) ?
                                         item.a_in : item.b_in;
                        BMU_PACK: result = {item.b_in[15:0], item.a_in[15:0]};
                        BMU_GREV: result = {item.a_in[7:0], item.a_in[15:8],
                                           item.a_in[23:16], item.a_in[31:24]};
                        BMU_CSR_WRITE: result = item.ap.csr_imm ? item.b_in : item.a_in;
                        BMU_CSR_READ: result = item.csr_rddata_in;
                        default: error = 1'b1;
                endcase
        endfunction : calculate



endclass : bmu_reference_model
