
// bmu sequence item ===========================================


class bmu_sequence_item extends uvm_sequence_item;


  // Declaring ------------------------------
    // control signals
    rand logic        rst_l;
    rand logic        scan_mode;
    rand logic        valid_in;
    rand logic        csr_ren_in;

    // operands and control fields
    rand logic [31:0] a_in;
    rand logic [31:0] b_in;
    rand bmu_ctrl_t   ap;
    rand logic [31:0] csr_rddata_in;

    // dut outputs
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


endclass : bmu_sequence_item