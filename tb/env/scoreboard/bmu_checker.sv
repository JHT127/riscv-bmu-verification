
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
                        "op=%s rst_l=%b valid_in=%b scan_mode=%b ap=%h a_in=%h b_in=%h csr_ren=%b csr_data=%h expected result_ff=%h error=%0b, got result_ff=%h error=%0b",
                        bmu_operation_code(actual_item.ap, actual_item.csr_ren_in).name(),
                        actual_item.rst_l, actual_item.valid_in, actual_item.scan_mode,
                        actual_item.ap, actual_item.a_in, actual_item.b_in,
                        actual_item.csr_ren_in, actual_item.csr_rddata_in,
                        expected_item.result_ff,
                        expected_item.error,
                        actual_item.result_ff,
                        actual_item.error
                );
                return 1'b0;
        endfunction : compare


endclass : bmu_checker