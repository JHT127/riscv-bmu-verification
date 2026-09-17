
// bmu reset clear sequence ===========================================


class bmu_reset_clear_sequence extends bmu_reset_base_sequence;

        `uvm_object_utils(bmu_reset_clear_sequence)

        function new(string name = "bmu_reset_clear_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("valid_item");
                initialize_item(req);
                req.a_in = 32'hFFFF_FFFF;
                req.b_in = 32'h0000_0001;
                req.ap.lor = 1'b1;
                send_item(req);
                reset_dut();
        endtask : body

endclass : bmu_reset_clear_sequence