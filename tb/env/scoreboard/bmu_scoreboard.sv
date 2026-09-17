
// bmu scoreboard ===========================================


`uvm_analysis_imp_decl(_actual)
`uvm_analysis_imp_decl(_expected)


class bmu_scoreboard extends uvm_scoreboard;


        // Declaring ------------------------------
                uvm_analysis_imp_actual #(bmu_sequence_item, bmu_scoreboard) actual_port;
                uvm_analysis_imp_expected #(bmu_sequence_item, bmu_scoreboard) expected_port;
                bmu_sequence_item actual_queue[$];
                bmu_sequence_item expected_queue[$];
                bmu_checker result_checker;



        // utility macro ----------------------------------------
                `uvm_component_utils(bmu_scoreboard)



        // constructor ----------------------------------------
        function new(string name, uvm_component parent);
                super.new(name, parent);
        endfunction : new



        // build phase ----------------------------------------
        function void build_phase(uvm_phase phase);

                super.build_phase(phase);
                actual_port = new("actual_port", this);
                expected_port = new("expected_port", this);
                result_checker = bmu_checker::type_id::create("result_checker");

        endfunction : build_phase



        // actual write method ----------------------------------------
        function void write_actual(bmu_sequence_item item);
                actual_queue.push_back(item);
                compare_available();
        endfunction : write_actual



        // expected write method ----------------------------------------
        function void write_expected(bmu_sequence_item item);
                expected_queue.push_back(item);
                compare_available();
        endfunction : write_expected



        // compare task ----------------------------------------
        function void compare_available();
                bmu_sequence_item actual_item;
                bmu_sequence_item expected_item;
                string message;

                while ((actual_queue.size() != 0) && (expected_queue.size() != 0)) begin
                        actual_item = actual_queue.pop_front();
                        expected_item = expected_queue.pop_front();

                        if (result_checker.compare(actual_item, expected_item, message))
                                `uvm_info(get_type_name(), message, UVM_HIGH)
                        else
                                `uvm_error(get_type_name(), message)
                end
        endfunction : compare_available


endclass : bmu_scoreboard