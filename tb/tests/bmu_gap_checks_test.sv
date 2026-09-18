// bmu missing test-plan checks ===========================================

class bmu_gap_checks_test extends bmu_base_test;

        `uvm_component_utils(bmu_gap_checks_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_gap_checks_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_gap_checks_test
