// bmu executable directed suite tests =======================================

class bmu_nominal_directed_test extends bmu_base_test;

        `uvm_component_utils(bmu_nominal_directed_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_nominal_directed_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_nominal_directed_test


class bmu_timing_reset_test extends bmu_base_test;

        `uvm_component_utils(bmu_timing_reset_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_timing_reset_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_timing_reset_test


class bmu_error_directed_test extends bmu_base_test;

        `uvm_component_utils(bmu_error_directed_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_error_directed_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_error_directed_test
