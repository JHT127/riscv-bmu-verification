// bmu max coverage test ===============================================

class bmu_coverage_max_test extends bmu_base_test;

        `uvm_component_utils(bmu_coverage_max_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_coverage_max_sequence max_seq;
                phase.raise_objection(this);
                max_seq = bmu_coverage_max_sequence::type_id::create("max_seq");
                max_seq.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_coverage_max_test
