
// bmu grev undefined sequence ===========================================


class bmu_grev_undefined_sequence extends bmu_pack_base_sequence;

        `uvm_object_utils(bmu_grev_undefined_sequence)

        function new(string name = "bmu_grev_undefined_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'h1234_5678;
                req.b_in = 32'd5;
                req.ap.grev = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_grev_undefined_sequence