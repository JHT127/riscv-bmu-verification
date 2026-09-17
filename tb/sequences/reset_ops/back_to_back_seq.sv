
// bmu back to back sequence ===========================================


class bmu_back_to_back_sequence extends bmu_reset_base_sequence;

        `uvm_object_utils(bmu_back_to_back_sequence)

        function new(string name = "bmu_back_to_back_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                reset_dut();

                req = bmu_sequence_item::type_id::create("or_item");
                initialize_item(req);
                req.a_in = 32'hF0F0_F0F0;
                req.b_in = 32'h0F0F_0F0F;
                req.ap.lor = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("xor_item");
                initialize_item(req);
                req.a_in = 32'hAAAA_AAAA;
                req.b_in = 32'h5555_5555;
                req.ap.lxor = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("srl_item");
                initialize_item(req);
                req.a_in = 32'hF000_0000;
                req.b_in = 32'd4;
                req.ap.srl = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_back_to_back_sequence