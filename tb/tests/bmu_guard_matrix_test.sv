// bmu guard matrix test ===========================================

class bmu_guard_matrix_test extends bmu_base_test;

        `uvm_component_utils(bmu_guard_matrix_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_guard_matrix_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_guard_matrix_test
