
// bmu ctz ones sequence ===========================================


class bmu_ctz_ones_sequence extends bmu_count_base_sequence;

        `uvm_object_utils(bmu_ctz_ones_sequence)

        function new(string name = "bmu_ctz_ones_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'hFFFF_FFFF;
                req.ap.ctz = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_ctz_ones_sequence