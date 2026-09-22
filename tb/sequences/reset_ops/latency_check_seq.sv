
// bmu latency check sequence ===========================================


class bmu_latency_check_sequence extends bmu_reset_base_sequence;

        `uvm_object_utils(bmu_latency_check_sequence)

        function new(string name = "bmu_latency_check_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("req");
                initialize_item(req);
                req.a_in = 32'hF0F0_F0F0;
                req.b_in = 32'h0F0F_0F0F;
                req.ap.lor = 1'b1;
                fork
                        send_item(req);
                        begin
                                @(negedge vif.clk);
                                #1ns;
                                if (vif.result_ff !== 32'b0)
                                        `uvm_error(get_type_name(), "result changed before capture edge")
                        end
                join
                #1ns;
                if (vif.result_ff !== 32'hFFFFFFFF)
                        `uvm_error(get_type_name(), "result did not capture on the expected edge")
        endtask : body

endclass : bmu_latency_check_sequence