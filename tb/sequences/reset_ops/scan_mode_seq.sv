
// bmu scan mode sequence ===========================================


class bmu_scan_mode_sequence extends bmu_reset_base_sequence;

        `uvm_object_utils(bmu_scan_mode_sequence)

        function new(string name = "bmu_scan_mode_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;

                req = bmu_sequence_item::type_id::create("scan_off");
                initialize_item(req);
                req.scan_mode = 1'b0;
                req.a_in = 32'hF0F0_F0F0;
                req.b_in = 32'h0F0F_0F0F;
                req.ap.lor = 1'b1;
                send_item(req);

                req = bmu_sequence_item::type_id::create("scan_on");
                initialize_item(req);
                req.scan_mode = 1'b1;
                req.a_in = 32'hF0F0_F0F0;
                req.b_in = 32'h0F0F_0F0F;
                req.ap.lor = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_scan_mode_sequence