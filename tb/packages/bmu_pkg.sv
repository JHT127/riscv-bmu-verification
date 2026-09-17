
// bmu package ===========================================


package bmu_pkg;

        import uvm_pkg::*;
        import bmu_types_package::*;
        `include "uvm_macros.svh"


        // sequence item ----------------------------------------
        `include "../env/agents/bmu_agent/bmu_sequence_item.sv"


        // sequencer + driver ----------------------------------------
        `include "../env/agents/bmu_agent/sequencer/bmu_sequencer.sv"
        `include "../env/agents/bmu_agent/driver/bmu_driver.sv"


        // monitor ----------------------------------------
        `include "../env/agents/bmu_agent/monitor/bmu_monitor.sv"


        // agent ----------------------------------------
        `include "../env/agents/bmu_agent/bmu_agent.sv"


        // reference model ----------------------------------------
        `include "../env/reference_model/bmu_reference_model.sv"


        // checker + scoreboard ----------------------------------------
        `include "../env/scoreboard/bmu_checker.sv"
        `include "../env/scoreboard/bmu_scoreboard.sv"


endpackage : bmu_pkg