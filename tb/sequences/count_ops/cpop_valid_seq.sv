
// bmu cpop valid sequence ===========================================


class bmu_cpop_valid_sequence extends bmu_count_base_sequence;

        `uvm_object_utils(bmu_cpop_valid_sequence)

        function new(string name = "bmu_cpop_valid_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'hF0F0_F00F;
                req.ap.cpop = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_cpop_valid_sequence