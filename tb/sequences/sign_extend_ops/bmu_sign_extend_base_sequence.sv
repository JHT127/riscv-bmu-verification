
// bmu sign extend base sequence ===========================================


class bmu_sign_extend_base_sequence extends bmu_base_sequence;


        // utility macro ----------------------------------------
                `uvm_object_utils(bmu_sign_extend_base_sequence)



        // constructor ----------------------------------------
        function new(string name = "bmu_sign_extend_base_sequence");
                super.new(name);
        endfunction : new


endclass : bmu_sign_extend_base_sequence