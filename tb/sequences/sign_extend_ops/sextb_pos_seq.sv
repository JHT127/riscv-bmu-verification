
// bmu sextb positive sequence ===========================================


class bmu_sextb_pos_sequence extends bmu_sign_extend_base_sequence;

        `uvm_object_utils(bmu_sextb_pos_sequence)

        function new(string name = "bmu_sextb_pos_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'h0000_007F;
                req.ap.siext_b = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_sextb_pos_sequence