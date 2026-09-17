
// bmu agent ===========================================


class bmu_agent extends uvm_agent;


        // Declaring ------------------------------
                bmu_driver    driver;
                bmu_sequencer sequencer;
                bmu_monitor   monitor;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_agent)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);

                if (get_is_active() == UVM_ACTIVE) begin
                        sequencer = bmu_sequencer::type_id::create("sequencer", this);
                        driver    = bmu_driver::type_id::create("driver", this);
                end

                monitor = bmu_monitor::type_id::create("monitor", this);

        endfunction : build_phase



        // connect phase ----------------------------------------
        function void connect_phase(uvm_phase phase);

                super.connect_phase(phase);

                if (get_is_active() == UVM_ACTIVE) begin
                        driver.seq_item_port.connect(sequencer.seq_item_export);
                end

        endfunction : connect_phase



endclass : bmu_agent