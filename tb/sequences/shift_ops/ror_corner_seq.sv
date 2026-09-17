
// bmu ror corner sequence ===========================================


class bmu_ror_corner_sequence extends bmu_shift_base_sequence;

        `uvm_object_utils(bmu_ror_corner_sequence)

        function new(string name = "bmu_ror_corner_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("rotate_zero");
                initialize_item(req);
                req.a_in = 32'h1234_5678;
                req.b_in = 32'd0;
                req.ap.ror = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("rotate_max");
                initialize_item(req);
                req.a_in = 32'h1234_5678;
                req.b_in = 32'd31;
                req.ap.ror = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_ror_corner_sequence