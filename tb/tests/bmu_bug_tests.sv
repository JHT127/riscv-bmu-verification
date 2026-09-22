// bmu isolated bug tests ===========================================

class bmu_bug_001_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_001_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 1;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_001_test


class bmu_bug_002_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_002_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 2;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_002_test


class bmu_bug_003_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_003_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 3;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_003_test


class bmu_bug_005_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_005_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 5;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_005_test


class bmu_bug_006_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_006_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 6;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_006_test


class bmu_bug_007_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_007_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 7;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_007_test


class bmu_bug_008_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_008_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 8;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_008_test


class bmu_bug_009_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_009_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 9;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_009_test


class bmu_bug_010_test extends bmu_base_test;

        `uvm_component_utils(bmu_bug_010_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                bmu_bug_sequence sequence_inst;
                phase.raise_objection(this);
                sequence_inst = bmu_bug_sequence::type_id::create("sequence");
                sequence_inst.bug_number = 10;
                sequence_inst.start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_bug_010_test


