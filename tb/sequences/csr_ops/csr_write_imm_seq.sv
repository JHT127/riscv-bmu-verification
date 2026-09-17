
// bmu csr write immediate sequence ===========================================


class bmu_csr_write_imm_sequence extends bmu_csr_base_sequence;

        `uvm_object_utils(bmu_csr_write_imm_sequence)

        function new(string name = "bmu_csr_write_imm_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.b_in = 32'h1111_2222;
                req.ap.csr_write = 1'b1;
                req.ap.csr_imm = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_csr_write_imm_sequence