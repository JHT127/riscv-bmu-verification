// bmu protocol assertions ===========================================

module bmu_protocol_assertions
        import rtl_pkg::*;
        #(
        parameter int RESULT_WIDTH = 32
) (
        input logic clk,
        input logic rst_l,
        input logic valid_in,
        input logic csr_ren_in,
        input logic [31:0] b_in,
        input logic [RESULT_WIDTH-1:0] result_ff,
        input logic error,
        input rtl_alu_pkt_t ap
);

        function automatic int primary_count(input rtl_alu_pkt_t controls);
                return controls.lor + controls.lxor + controls.srl + controls.sra +
                       controls.ror + controls.binv + controls.sh2add + controls.sub +
                       controls.slt + controls.ctz + controls.cpop + controls.siext_b +
                       controls.max + controls.pack + controls.grev + controls.csr_write;
        endfunction

        property reset_suppresses_error;
                @(posedge clk) !rst_l |-> !error;
        endproperty
        assert property (reset_suppresses_error)
                else $error("BMU reset must suppress error");

        property reset_clears_result;
                @(posedge clk) !rst_l |=> result_ff == '0;
        endproperty
        assert property (reset_clears_result)
                else $error("BMU reset did not clear result_ff");

        property result_holds_when_invalid;
                @(posedge clk) disable iff (!rst_l) !valid_in |=> $stable(result_ff);
        endproperty
        assert property (result_holds_when_invalid)
                else $error("BMU result changed while valid_in was low");

        property valid_result_is_registered;
                @(posedge clk) disable iff (!rst_l) valid_in |=> !$isunknown(result_ff);
        endproperty
        assert property (valid_result_is_registered)
                else $error("BMU registered result is unknown after valid input");

        property one_primary_operation;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && primary_count(ap) > 1) |-> error;
        endproperty
        assert property (one_primary_operation)
                else $error("BMU conflicting primary controls were not rejected");

        property empty_valid_request;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && primary_count(ap) == 0 && !csr_ren_in) |-> error;
        endproperty
        assert property (empty_valid_request)
                else $error("BMU empty valid request was not rejected");

        property live_error_when_invalid;
                @(posedge clk) disable iff (!rst_l)
                (!valid_in && primary_count(ap) > 1) |-> error;
        endproperty
        assert property (live_error_when_invalid)
                else $error("BMU error did not update for an idle invalid request");

        property csr_conflict;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && csr_ren_in && primary_count(ap) != 0) |-> error;
        endproperty
        assert property (csr_conflict)
                else $error("BMU CSR and operation controls were not rejected");

        property sh2add_requires_zba;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && ap.sh2add && !ap.zba) |-> error;
        endproperty
        assert property (sh2add_requires_zba)
                else $error("BMU SH2ADD without ZBA was not rejected");

        property sub_rejects_zba;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && ap.sub && ap.zba) |-> error;
        endproperty
        assert property (sub_rejects_zba)
                else $error("BMU SUB with ZBA was not rejected");

        property slt_requires_sub;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && ap.slt && !ap.sub) |-> error;
        endproperty
        assert property (slt_requires_sub)
                else $error("BMU SLT without SUB was not rejected");

        property max_requires_sub;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && ap.max && !ap.sub) |-> error;
        endproperty
        assert property (max_requires_sub)
                else $error("BMU MAX without SUB was not rejected");

        property grev_encoding;
                @(posedge clk) disable iff (!rst_l)
                (valid_in && ap.grev && b_in[4:0] != 5'd24) |-> error;
        endproperty
        assert property (grev_encoding)
                else $error("BMU unsupported GREV encoding was not rejected");

endmodule

bind Bit_Manipulation_Unit bmu_protocol_assertions protocol_assertions_i (
        .clk       (clk),
        .rst_l     (rst_l),
        .valid_in  (valid_in),
        .csr_ren_in(csr_ren_in),
        .b_in      (b_in),
        .result_ff (result_ff),
        .error     (error),
        .ap        (ap)
);
