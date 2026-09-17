
// bmu reset mid operation sequence ===========================================


class bmu_reset_mid_op_sequence extends bmu_reset_base_sequence;

        `uvm_object_utils(bmu_reset_mid_op_sequence)

        function new(string name = "bmu_reset_mid_op_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("reset_item");
                initialize_item(req);
                req.rst_l = 1'b0;
                req.valid_in = 1'b1;
                req.a_in = 32'hAAAA_AAAA;
                req.b_in = 32'h5555_5555;
                req.ap.lor = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_reset_mid_op_sequence