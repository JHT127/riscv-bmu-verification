
// bmu sextb negative sequence ===========================================


class bmu_sextb_neg_sequence extends bmu_sign_extend_base_sequence;

        `uvm_object_utils(bmu_sextb_neg_sequence)

        function new(string name = "bmu_sextb_neg_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'h0000_00FF;
                req.ap.siext_b = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_sextb_neg_sequence