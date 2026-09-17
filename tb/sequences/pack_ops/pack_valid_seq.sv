
// bmu pack valid sequence ===========================================


class bmu_pack_valid_sequence extends bmu_pack_base_sequence;

        `uvm_object_utils(bmu_pack_valid_sequence)

        function new(string name = "bmu_pack_valid_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'h0000_1234;
                req.b_in = 32'h0000_5678;
                req.ap.pack = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_pack_valid_sequence