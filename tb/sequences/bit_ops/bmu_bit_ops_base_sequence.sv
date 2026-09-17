
// bmu bit operations base sequence ===========================================


class bmu_bit_ops_base_sequence extends bmu_base_sequence;


        // utility macro ----------------------------------------
                `uvm_object_utils(bmu_bit_ops_base_sequence)



        // constructor ----------------------------------------
        function new(string name = "bmu_bit_ops_base_sequence");
                super.new(name);
        endfunction : new


endclass : bmu_bit_ops_base_sequence