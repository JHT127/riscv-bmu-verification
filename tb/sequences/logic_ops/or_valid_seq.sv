
// bmu or valid sequence ===========================================


class bmu_or_valid_sequence extends bmu_logic_base_sequence;

        `uvm_object_utils(bmu_or_valid_sequence)

        function new(string name = "bmu_or_valid_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'hF0F0_F0F0;
                req.b_in = 32'h0F0F_0F0F;
                req.ap.lor = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_or_valid_sequence