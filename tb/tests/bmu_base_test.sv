
// bmu base test ===========================================


class bmu_base_test extends uvm_test;


        // Declaring ------------------------------
                bmu_environment environment;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_base_test)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                uvm_config_db #(uvm_active_passive_enum)::set(
                        this,
                        "environment.agent",
                        "is_active",
                        UVM_ACTIVE
                );
                environment = bmu_environment::type_id::create("environment", this);

        endfunction : build_phase


endclass : bmu_base_test