
// bmu sequencer ===========================================


class bmu_sequencer extends uvm_sequencer #(bmu_sequence_item);


        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_sequencer)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new


endclass : bmu_sequencer