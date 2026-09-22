// bmu isolated bug reproducers ===========================================

class bmu_bug_sequence extends bmu_base_sequence;

        int unsigned bug_number;
        `uvm_object_utils(bmu_bug_sequence)

        function new(string name = "bmu_bug_sequence");
                super.new(name);
        endfunction : new

        task body();
                bmu_sequence_item req;
                reset_dut();
                req = bmu_sequence_item::type_id::create("bug_request");
                initialize_item(req);
                case (bug_number)
                        1: begin req.ap.cpop = 1'b1; req.a_in = 32'hFFFF0000; end
                        2: begin req.ap.pack = 1'b1; req.a_in = 32'h00001234; req.b_in = 32'h00005678; end
                        3: begin
                                req.ap.csr_write = 1'b1; req.ap.csr_imm = 1'b1;
                                req.a_in = 32'h33334444; req.b_in = 32'h11112222;
                        end
                        5: begin req.ap.grev = 1'b1; req.a_in = 32'h12345678; req.b_in = 24; end
                        6: begin req.ap = '0; end
                        7: begin req.ap.slt = 1'b1; req.a_in = 32'hFFFFFFFF; req.b_in = 1; end
                        8: begin req.ap.grev = 1'b1; req.a_in = 32'h12345678; req.b_in = 5; end
                        9: begin req.ap.ctz = 1'b1; req.a_in = 1; end
                        10: begin req.ap.max = 1'b1; req.ap.sub = 1'b1; req.a_in = 10; req.b_in = 20; end
                        default: `uvm_fatal(get_type_name(), "unknown bug number")
                endcase
                `uvm_info(get_type_name(), $sformatf("reproducing BMU-BUG-%03d", bug_number), UVM_LOW)
                send_item(req);
                if (bug_number == 3) begin
                        req.ap.csr_imm = 1'b0;
                        send_item(req);
                end
                if (bug_number == 7) begin
                        req.ap = '0;
                        req.ap.max = 1'b1;
                        req.a_in = 10;
                        req.b_in = 20;
                        send_item(req);
                end
        endtask : body

endclass : bmu_bug_sequence
