
// bmu sra conflict sequence ===========================================


class bmu_sra_conflict_sequence extends bmu_error_injection_base_sequence;

        `uvm_object_utils(bmu_sra_conflict_sequence)

        function new(string name = "bmu_sra_conflict_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.ap.sra = 1'b1;
                req.ap.ror = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_sra_conflict_sequence