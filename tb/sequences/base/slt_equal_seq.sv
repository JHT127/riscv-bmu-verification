
// bmu slt equal sequence ===========================================


class bmu_slt_equal_sequence extends bmu_base_sequence;

        `uvm_object_utils(bmu_slt_equal_sequence)

        function new(string name = "bmu_slt_equal_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("signed_equal");
                initialize_item(req);
                req.a_in = 32'd5;
                req.b_in = 32'd5;
                req.ap.slt = 1'b1;
                req.ap.sub = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("unsigned_equal");
                initialize_item(req);
                req.a_in = 32'd5;
                req.b_in = 32'd5;
                req.ap.slt = 1'b1;
                req.ap.sub = 1'b1;
                req.ap.unsign = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_slt_equal_sequence