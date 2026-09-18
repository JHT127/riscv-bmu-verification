
// bmu or valid test ===========================================


class bmu_or_valid_test extends bmu_base_test;


        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_or_valid_test)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // run phase ----------------------------------------
        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_or_valid_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase


endclass : bmu_or_valid_test
