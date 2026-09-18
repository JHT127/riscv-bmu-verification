// bmu randomized tests ===========================================

class bmu_legal_random_test extends bmu_base_test;

        `uvm_component_utils(bmu_legal_random_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_random_legal_sequence random_sequence;
                phase.raise_objection(this);
                random_sequence = bmu_random_legal_sequence::type_id::create("random_sequence");
                random_sequence.scenario_count = 100;
                random_sequence.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_legal_random_test


class bmu_corner_random_test extends bmu_base_test;

        `uvm_component_utils(bmu_corner_random_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_random_corner_weighted_sequence random_sequence;
                phase.raise_objection(this);
                random_sequence = bmu_random_corner_weighted_sequence::type_id::create("random_sequence");
                random_sequence.scenario_count = 100;
                random_sequence.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_corner_random_test


class bmu_error_random_test extends bmu_base_test;

        `uvm_component_utils(bmu_error_random_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_random_error_sequence random_sequence;
                phase.raise_objection(this);
                random_sequence = bmu_random_error_sequence::type_id::create("random_sequence");
                random_sequence.scenario_count = 100;
                random_sequence.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_error_random_test
