
// bmu driver ===========================================


class bmu_driver extends uvm_driver #(bmu_sequence_item);


        // Declaring ------------------------------
                virtual bmu_interface vif;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_driver)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                if (!uvm_config_db #(virtual bmu_interface)::get(this, "", "vif", vif))
                        `uvm_fatal(get_type_name(), "vif not set at top level")

        endfunction : build_phase



        // run phase ----------------------------------------
        task run_phase(uvm_phase phase);

                bmu_sequence_item item;

                forever begin

                        seq_item_port.get_next_item(item);
                        drive(item);

                        `uvm_info(get_type_name(), $sformatf("driven to DUT: rst_l=%0b valid_in=%0b a_in=%h b_in=%h",
                                  item.rst_l, item.valid_in, item.a_in, item.b_in), UVM_HIGH)

                        seq_item_port.item_done();

                end

        endtask : run_phase



        // drive task ----------------------------------------
        task drive(bmu_sequence_item req);
                @(vif.cb_drv);
                vif.cb_drv.rst_l         <= req.rst_l;
                vif.cb_drv.scan_mode     <= req.scan_mode;
                vif.cb_drv.valid_in      <= req.valid_in;
                vif.cb_drv.a_in          <= req.a_in;
                vif.cb_drv.b_in          <= req.b_in;
                vif.cb_drv.ap            <= req.ap;
                vif.cb_drv.csr_ren_in    <= req.csr_ren_in;
                vif.cb_drv.csr_rddata_in <= req.csr_rddata_in;
        endtask : drive



endclass : bmu_driver