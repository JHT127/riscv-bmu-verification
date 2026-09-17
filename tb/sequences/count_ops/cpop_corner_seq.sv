
// bmu cpop corner sequence ===========================================


class bmu_cpop_corner_sequence extends bmu_count_base_sequence;

        `uvm_object_utils(bmu_cpop_corner_sequence)

        function new(string name = "bmu_cpop_corner_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("count_zero");
                initialize_item(req);
                req.a_in = 32'h0000_0000;
                req.ap.cpop = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("count_all");
                initialize_item(req);
                req.a_in = 32'hFFFF_FFFF;
                req.ap.cpop = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_cpop_corner_sequence