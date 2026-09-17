
// bmu monitor ===========================================


class bmu_monitor extends uvm_monitor;



        // Declaring ------------------------------
                virtual bmu_interface vif;
                uvm_analysis_port #(bmu_sequence_item) port;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_monitor)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                port = new("port", this);
                if (!uvm_config_db #(virtual bmu_interface)::get(this, "", "vif", vif))
                        `uvm_fatal(get_type_name(), "vif not set at top level")

        endfunction : build_phase



        // run phase ----------------------------------------
        task run_phase(uvm_phase phase);
                bmu_sequence_item item;

                `uvm_info(get_type_name(), "inside run_phase", UVM_HIGH)

                forever begin
                        item = bmu_sequence_item::type_id::create("item");

                        @(vif.cb_mon);

                        item.rst_l         = vif.cb_mon.rst_l;
                        item.scan_mode     = vif.cb_mon.scan_mode;
                        item.valid_in      = vif.cb_mon.valid_in;
                        item.a_in          = vif.cb_mon.a_in;
                        item.b_in          = vif.cb_mon.b_in;
                        item.ap            = vif.cb_mon.ap;
                        item.csr_ren_in    = vif.cb_mon.csr_ren_in;
                        item.csr_rddata_in = vif.cb_mon.csr_rddata_in;
                        item.result_ff     = vif.cb_mon.result_ff;
                        item.error         = vif.cb_mon.error;

                        port.write(item);
                end

        endtask : run_phase



endclass : bmu_monitor