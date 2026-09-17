
// bmu checker ===========================================


class bmu_checker extends uvm_object;


        // utility macro ----------------------------------------
                `uvm_object_utils(bmu_checker)



        // constructor ----------------------------------------
        function new(string name = "bmu_checker");
                super.new(name);
        endfunction : new



        // compare function ----------------------------------------
        function bit compare(
                bmu_sequence_item actual_item,
                bmu_sequence_item expected_item,
                output string message
        );
                if ((actual_item.result_ff === expected_item.result_ff) &&
                        (actual_item.error === expected_item.error)) begin
                        message = "result and error match";
                        return 1'b1;
                end

                message = $sformatf(
                        "expected result_ff=%h error=%0b, got result_ff=%h error=%0b",
                        expected_item.result_ff,
                        expected_item.error,
                        actual_item.result_ff,
                        actual_item.error
                );
                return 1'b0;
        endfunction : compare


endclass : bmu_checker