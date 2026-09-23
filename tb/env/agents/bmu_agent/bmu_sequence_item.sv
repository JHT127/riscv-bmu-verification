
// bmu sequence item ===========================================


class bmu_sequence_item extends uvm_sequence_item;


  // Declaring ------------------------------
    // control and request signals applied to the DUT
    rand logic        rst_l;
    rand logic        scan_mode;
    rand logic        valid_in;
    rand logic        csr_ren_in;

    // operand data and packed BMU control packet
    rand logic [31:0] a_in;
    rand logic [31:0] b_in;
    rand bmu_ctrl_t   ap;
    rand logic [31:0] csr_rddata_in;

    // observed DUT response captured on the active clock edge
    logic [31:0] result_ff;
    logic        error;



  // utility and field macros ----------------------------------------
    `uvm_object_utils_begin(bmu_sequence_item)
      `uvm_field_int(rst_l,          UVM_ALL_ON)
      `uvm_field_int(scan_mode,      UVM_ALL_ON)
      `uvm_field_int(valid_in,       UVM_ALL_ON)
      `uvm_field_int(csr_ren_in,     UVM_ALL_ON)
      `uvm_field_int(a_in,           UVM_ALL_ON)
      `uvm_field_int(b_in,           UVM_ALL_ON)
      `uvm_field_int(ap,             UVM_ALL_ON)
      `uvm_field_int(csr_rddata_in,  UVM_ALL_ON)
      `uvm_field_int(result_ff,      UVM_ALL_ON)
      `uvm_field_int(error,          UVM_ALL_ON)
    `uvm_object_utils_end



  // constructor ----------------------------------------
  function new(string name = "bmu_sequence_item");
    super.new(name);
  endfunction : new

  // helper for readable debug output when this item is printed
  virtual function string convert2string();
    return $sformatf(
      "rst_l=%0b scan_mode=%0b valid_in=%0b csr_ren_in=%0b a_in=%0h b_in=%0h ap=%p csr_rddata_in=%0h result_ff=%0h error=%0b",
      rst_l,
      scan_mode,
      valid_in,
      csr_ren_in,
      a_in,
      b_in,
      ap,
      csr_rddata_in,
      result_ff,
      error
    );
  endfunction : convert2string


endclass : bmu_sequence_item