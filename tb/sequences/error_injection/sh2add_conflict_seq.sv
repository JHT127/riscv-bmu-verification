
// bmu sh2add conflict sequence ===========================================


class bmu_sh2add_conflict_sequence extends bmu_error_injection_base_sequence;

        `uvm_object_utils(bmu_sh2add_conflict_sequence)

        function new(string name = "bmu_sh2add_conflict_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.ap.sh2add = 1'b1;
                req.ap.zba = 1'b1;
                req.ap.lor = 1'b1;
                req.csr_ren_in = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_sh2add_conflict_sequence