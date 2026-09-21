module Bit_Manipulation_Unit_fix_v1
  import rtl_pkg::*;
  #(`include "library/rtl_param.vh")
 (
    input logic clk,
    input logic rst_l,
    input logic scan_mode,
    input logic valid_in,
    input rtl_alu_pkt_t ap,
    input logic csr_ren_in,
    input logic [31:0] csr_rddata_in,
    input logic signed [31:0] a_in,
    input logic [31:0] b_in,
    output logic [31:0] result_ff,
    output logic error
);

  logic [31:0] corrected_result;
  logic corrected_error;
  logic [31:0] target_result;
  logic target_error;
  int unsigned shift_amount;
  int unsigned count;
  int unsigned index;

  function automatic int unsigned operation_count(input rtl_alu_pkt_t ctrl);
    begin
      operation_count = ctrl.lor + ctrl.lxor + ctrl.land + ctrl.sll + ctrl.srl + ctrl.sra + ctrl.ror +
                        ctrl.bset + ctrl.bclr + ctrl.binv + ctrl.bext + ctrl.sh1add + ctrl.sh2add + ctrl.sh3add +
                        ctrl.slt + ctrl.ctz + ctrl.cpop + ctrl.siext_b + ctrl.max + ctrl.pack + ctrl.grev +
                        ctrl.csr_write + (ctrl.sub && !ctrl.slt && !ctrl.max) + ctrl.zba + ctrl.zbb + ctrl.packu + ctrl.packh;
    end
  endfunction

  function automatic bit no_modes(input rtl_alu_pkt_t ctrl);
    begin
      no_modes = !ctrl.zbb && !ctrl.zba && !ctrl.unsign && !ctrl.csr_imm;
    end
  endfunction

  function automatic bit only_zbb(input rtl_alu_pkt_t ctrl);
    begin
      only_zbb = !ctrl.zba && !ctrl.unsign && !ctrl.csr_imm;
    end
  endfunction

  function automatic bit only_zba(input rtl_alu_pkt_t ctrl);
    begin
      only_zba = ctrl.zba && !ctrl.zbb && !ctrl.unsign && !ctrl.csr_imm;
    end
  endfunction

  function automatic bit only_unsign(input rtl_alu_pkt_t ctrl);
    begin
      only_unsign = !ctrl.zbb && !ctrl.zba && !ctrl.csr_imm;
    end
  endfunction

  function automatic bit only_csr_imm(input rtl_alu_pkt_t ctrl);
    begin
      only_csr_imm = !ctrl.zbb && !ctrl.zba && !ctrl.unsign;
    end
  endfunction

  always_comb begin
    corrected_result = '0;
    corrected_error = 1'b0;
    shift_amount = b_in[4:0];

    if (!rst_l) begin
      corrected_result = '0;
      corrected_error = 1'b0;
    end else if (csr_ren_in && (|ap)) begin
      corrected_error = 1'b1;
    end else if (csr_ren_in && !(|ap)) begin
      corrected_result = csr_rddata_in;
    end else if (operation_count(ap) != 1) begin
      corrected_error = 1'b1;
    end else if (ap.lor) begin
      if (!only_zbb(ap) && !ap.land) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in | (ap.zbb ? ~b_in : b_in);
      end
    end else if (ap.lxor) begin
      if (!only_zbb(ap) && !ap.land) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in ^ (ap.zbb ? ~b_in : b_in);
      end
    end else if (ap.land) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in & b_in;
      end
    end else if (ap.sll) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in << shift_amount;
      end
    end else if (ap.srl) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in >> shift_amount;
      end
    end else if (ap.sra) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = $signed(a_in) >>> shift_amount;
      end
    end else if (ap.ror) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = (a_in >> shift_amount) | (a_in << ((32 - shift_amount) & 5'h1f));
      end
    end else if (ap.bset) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in | (32'b1 << shift_amount);
      end
    end else if (ap.bclr) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in & ~(32'b1 << shift_amount);
      end
    end else if (ap.binv) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in ^ (32'b1 << shift_amount);
      end
    end else if (ap.bext) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = {{31{1'b0}}, a_in[shift_amount]};
      end
    end else if (ap.sh1add) begin
      if (!only_zba(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = (a_in << 1) + b_in;
      end
    end else if (ap.sh2add) begin
      if (!only_zba(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = (a_in << 2) + b_in;
      end
    end else if (ap.sh3add) begin
      if (!only_zba(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = (a_in << 3) + b_in;
      end
    end else if (ap.slt && ap.sub) begin
      if (!only_unsign(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = ap.unsign ? ((a_in < b_in) ? 32'd1 : 32'd0) : (($signed(a_in) < $signed(b_in)) ? 32'd1 : 32'd0);
      end
    end else if (ap.sub && !ap.slt && !ap.max) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = a_in - b_in;
      end
    end else if (ap.ctz) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        count = 32;
        for (index = 0; index < 32; index++) begin
          if (a_in[index]) begin
            count = index;
            break;
          end
        end
        corrected_result = count;
      end
    end else if (ap.cpop) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        count = 0;
        for (index = 0; index < 32; index++)
          count += a_in[index];
        corrected_result = count;
      end
    end else if (ap.siext_b) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = {{24{a_in[7]}}, a_in[7:0]};
      end
    end else if (ap.max && ap.sub) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = ($signed(a_in) > $signed(b_in)) ? a_in : b_in;
      end
    end else if (ap.pack) begin
      if (!no_modes(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = {b_in[15:0], a_in[15:0]};
      end
    end else if (ap.grev) begin
      if (!no_modes(ap) || shift_amount != 24) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = {a_in[7:0], a_in[15:8], a_in[23:16], a_in[31:24]};
      end
    end else if (ap.csr_write) begin
      if (!only_csr_imm(ap)) begin
        corrected_error = 1'b1;
      end else begin
        corrected_result = ap.csr_imm ? b_in : a_in;
      end
    end else begin
      corrected_error = 1'b1;
    end

    if (ap.slt && !ap.sub) begin
      corrected_error = 1'b1;
      corrected_result = '0;
    end
    if (ap.max && !ap.sub) begin
      corrected_error = 1'b1;
      corrected_result = '0;
    end
    if (ap.grev && b_in[4:0] != 5'd24) begin
      corrected_error = 1'b1;
      corrected_result = '0;
    end
    if (ap.zba && ap.sub) begin
      corrected_error = 1'b1;
      corrected_result = '0;
    end
  end

  always_ff @(posedge clk) begin
    if (!rst_l) begin
      result_ff <= '0;
      error <= 1'b0;
    end else if (valid_in) begin
      result_ff <= corrected_result;
      error <= corrected_error;
    end else begin
      result_ff <= result_ff;
      error <= error;
    end
  end

endmodule
