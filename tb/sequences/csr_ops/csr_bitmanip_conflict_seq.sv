
// bmu csr bitmanip conflict sequence ===========================================


class bmu_csr_bitmanip_conflict_sequence extends bmu_csr_base_sequence;

        `uvm_object_utils(bmu_csr_bitmanip_conflict_sequence)

        function new(string name = "bmu_csr_bitmanip_conflict_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.ap.lor = 1'b1;
                req.csr_ren_in = 1'b1;
                req.csr_rddata_in = 32'hABCD_1234;
                send_item(req);
        endtask : body

endclass : bmu_csr_bitmanip_conflict_sequence