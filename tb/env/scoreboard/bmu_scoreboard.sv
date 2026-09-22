
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
                int unsigned compared_count;
                int unsigned mismatch_count;
                int unsigned stimulus_count;



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
                if (item.valid_in === 1'b1 || item.rst_l === 1'b1)
                        stimulus_count++;
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

                        compared_count++;
                        if (result_checker.compare(actual_item, expected_item, message))
                                `uvm_info(get_type_name(), message, UVM_HIGH)
                        else begin
                                mismatch_count++;
                                `uvm_error(get_type_name(), message)
                        end
                end
        endfunction : compare_available


        // check_phase ----------------------------------------
        function void check_phase(uvm_phase phase);
                super.check_phase(phase);
                compare_available();
                if (stimulus_count == 0)
                        `uvm_error(get_type_name(), "no active stimulus observed")
                if ((actual_queue.size() != 0) || (expected_queue.size() != 0)) begin
                        `uvm_error(get_type_name(), $sformatf(
                                "unmatched transactions: actual=%0d expected=%0d",
                                actual_queue.size(), expected_queue.size()))
                end
        endfunction : check_phase


        function void report_phase(uvm_phase phase);
                super.report_phase(phase);
                `uvm_info(get_type_name(), $sformatf(
                        "compared=%0d matched=%0d mismatched=%0d",
                        compared_count, compared_count - mismatch_count, mismatch_count), UVM_LOW)
        endfunction : report_phase


endclass : bmu_scoreboard
