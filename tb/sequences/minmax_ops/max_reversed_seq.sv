
// bmu max reversed sequence ===========================================


class bmu_max_reversed_sequence extends bmu_minmax_base_sequence;

        `uvm_object_utils(bmu_max_reversed_sequence)

        function new(string name = "bmu_max_reversed_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'd20;
                req.b_in = 32'd10;
                req.ap.max = 1'b1;
                req.ap.sub = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_max_reversed_sequence