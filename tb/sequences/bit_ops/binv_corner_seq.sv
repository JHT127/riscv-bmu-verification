
// bmu binv corner sequence ===========================================


class bmu_binv_corner_sequence extends bmu_bit_ops_base_sequence;

        `uvm_object_utils(bmu_binv_corner_sequence)

        function new(string name = "bmu_binv_corner_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("bit_zero");
                initialize_item(req);
                req.a_in = 32'hFFFF_FFFF;
                req.b_in = 32'd0;
                req.ap.binv = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("bit_max");
                initialize_item(req);
                req.a_in = 32'h0000_0000;
                req.b_in = 32'd31;
                req.ap.binv = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_binv_corner_sequence