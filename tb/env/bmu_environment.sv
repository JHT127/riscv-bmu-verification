
// bmu environment ===========================================


class bmu_environment extends uvm_env;


        // Declaring ------------------------------
                bmu_agent            agent;
                bmu_reference_model  reference_model;
                bmu_scoreboard       scoreboard;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_environment)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                agent = bmu_agent::type_id::create("agent", this);
                reference_model = bmu_reference_model::type_id::create("reference_model", this);
                scoreboard = bmu_scoreboard::type_id::create("scoreboard", this);

        endfunction : build_phase



        // connect phase ----------------------------------------
        function void connect_phase(uvm_phase phase);

                super.connect_phase(phase);
                agent.monitor.port.connect(reference_model.input_port);
                agent.monitor.port.connect(scoreboard.actual_port);
                reference_model.expected_port.connect(scoreboard.expected_port);

        endfunction : connect_phase



endclass : bmu_environment