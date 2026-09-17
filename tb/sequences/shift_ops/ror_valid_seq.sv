
// bmu ror valid sequence ===========================================


class bmu_ror_valid_sequence extends bmu_shift_base_sequence;

        `uvm_object_utils(bmu_ror_valid_sequence)

        function new(string name = "bmu_ror_valid_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'h89AB_CDEF;
                req.b_in = 32'd4;
                req.ap.ror = 1'b1;
                send_item(req);
        endtask : body

endclass : bmu_ror_valid_sequence