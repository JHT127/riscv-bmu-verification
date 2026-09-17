
// bmu xor invert sequence ===========================================


class bmu_xor_invert_sequence extends bmu_logic_base_sequence;

        `uvm_object_utils(bmu_xor_invert_sequence)

        function new(string name = "bmu_xor_invert_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'hAAAA_AAAA;
                req.b_in = 32'h5555_5555;
                req.ap.lxor = 1'b1;
                req.ap.zbb = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_xor_invert_sequence