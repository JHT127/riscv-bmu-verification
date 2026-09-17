
// bmu reset base sequence ===========================================


class bmu_reset_base_sequence extends bmu_base_sequence;


        // utility macro ----------------------------------------
                `uvm_object_utils(bmu_reset_base_sequence)



        // constructor ----------------------------------------
        function new(string name = "bmu_reset_base_sequence");
                super.new(name);
        endfunction : new


endclass : bmu_reset_base_sequence