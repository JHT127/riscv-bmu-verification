
// bmu sh2add valid sequence ===========================================


class bmu_sh2add_valid_sequence extends bmu_zba_base_sequence;

        `uvm_object_utils(bmu_sh2add_valid_sequence)

        function new(string name = "bmu_sh2add_valid_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'd4;
                req.b_in = 32'd7;
                req.ap.sh2add = 1'b1;
                req.ap.zba = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_sh2add_valid_sequence