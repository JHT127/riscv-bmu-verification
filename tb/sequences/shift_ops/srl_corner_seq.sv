
// bmu srl corner sequence ===========================================


class bmu_srl_corner_sequence extends bmu_shift_base_sequence;

        `uvm_object_utils(bmu_srl_corner_sequence)

        function new(string name = "bmu_srl_corner_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("shift_zero");
                initialize_item(req);
                req.a_in = 32'h8000_0001;
                req.b_in = 32'd0;
                req.ap.srl = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("shift_max");
                initialize_item(req);
                req.a_in = 32'h8000_0000;
                req.b_in = 32'd31;
                req.ap.srl = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_srl_corner_sequence