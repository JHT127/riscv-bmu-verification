
// bmu sub zba misuse sequence ===========================================


class bmu_sub_zba_misuse_sequence extends bmu_error_injection_base_sequence;

        `uvm_object_utils(bmu_sub_zba_misuse_sequence)

        function new(string name = "bmu_sub_zba_misuse_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.ap.sub = 1'b1;
                req.ap.zba = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_sub_zba_misuse_sequence