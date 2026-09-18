// bmu explicit gap-plan tests ===========================================

class bmu_tc_binv_004_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_binv_004_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_binv_004_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_binv_004_test


class bmu_tc_shift_004_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_shift_004_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_shift_004_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_shift_004_test


class bmu_tc_cpop_004_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_cpop_004_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_cpop_004_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_cpop_004_test


class bmu_tc_ctz_005_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_ctz_005_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_ctz_005_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_ctz_005_test


class bmu_tc_guard_001_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_guard_001_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_guard_001_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_guard_001_test


class bmu_tc_guard_002_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_guard_002_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_guard_002_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_guard_002_test


class bmu_tc_guard_003_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_guard_003_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_guard_003_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_guard_003_test


class bmu_tc_guard_004_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_guard_004_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_guard_004_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_guard_004_test


class bmu_tc_slt_005_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_slt_005_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_slt_005_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_slt_005_test


class bmu_tc_max_005_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_max_005_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_max_005_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_max_005_test


class bmu_tc_csr_005_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_csr_005_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_csr_005_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_csr_005_test


class bmu_tc_time_004_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_time_004_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_time_004_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_time_004_test


class bmu_tc_reset_004_test extends bmu_base_test;

        `uvm_component_utils(bmu_tc_reset_004_test)

        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                bmu_tc_reset_004_sequence::type_id::create("sequence").start(environment.agent.sequencer);
                phase.phase_done.set_drain_time(this, 1ns);
                phase.drop_objection(this);
        endtask : run_phase

endclass : bmu_tc_reset_004_test
