
// bmu grev csr conflict sequence ===========================================


class bmu_grev_csr_conflict_sequence extends bmu_error_injection_base_sequence;

        `uvm_object_utils(bmu_grev_csr_conflict_sequence)

        function new(string name = "bmu_grev_csr_conflict_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.b_in = 32'd24;
                req.ap.grev = 1'b1;
                req.csr_ren_in = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_grev_csr_conflict_sequence