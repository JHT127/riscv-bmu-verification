
// bmu valid in hold sequence ===========================================


class bmu_valid_in_hold_sequence extends bmu_reset_base_sequence;

        `uvm_object_utils(bmu_valid_in_hold_sequence)

        function new(string name = "bmu_valid_in_hold_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                reset_dut();
                req = bmu_sequence_item::type_id::create("valid_item");
                initialize_item(req);
                req.a_in = 32'h1234_5678;
                req.b_in = 32'h1111_1111;
                req.ap.lor = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("hold_item");
                initialize_item(req);
                req.valid_in = 1'b0;
                req.ap.lxor = 1'b1;
                req.a_in = 32'hFFFF_FFFF;
                req.b_in = 32'h0000_0000;
                send_item(req);
        endtask : body

endclass : bmu_valid_in_hold_sequence