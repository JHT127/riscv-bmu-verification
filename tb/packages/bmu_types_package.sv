
// bmu types package ===========================================


package bmu_types_package;

        // decoded operation controls from the RTL/control contract.
        // All fields remain driveable for guard checks. Only specification
        // v1.2 operations have defined standalone behavior in the predictor.
        typedef struct packed {
                logic clz;
                logic ctz;
                logic cpop;
                logic siext_b;
                logic siext_h;
                logic min;
                logic max;
                logic pack;
                logic packu;
                logic packh;
                logic rol;
                logic ror;
                logic grev;
                logic gorc;
                logic zbb;
                logic bset;
                logic bclr;
                logic binv;
                logic bext;
                logic sh1add;
                logic sh2add;
                logic sh3add;
                logic zba;
                logic land;
                logic lor;
                logic lxor;
                logic sll;
                logic srl;
                logic sra;
                logic beq;
                logic bne;
                logic blt;
                logic bge;
                logic add;
                logic sub;
                logic slt;
                logic unsign;
                logic jal;
                logic predict_t;
                logic predict_nt;
                logic csr_write;
                logic csr_imm;
        } bmu_ctrl_t;


        // specification operation selection ----------------------------------------
        typedef enum int {
                BMU_OR, BMU_XOR, BMU_SRL, BMU_SRA, BMU_ROR, BMU_BINV, BMU_SH2ADD, BMU_SUB, BMU_SLT, BMU_CTZ, BMU_CPOP, BMU_SEXTB, BMU_MAX, BMU_PACK, BMU_GREV, BMU_CSR_WRITE, BMU_CSR_READ, BMU_INVALID
        } bmu_operation_t;

        function automatic int bmu_primary_count(bmu_ctrl_t ap);
                return ap.lor + ap.lxor + ap.srl + ap.sra + ap.ror + ap.binv +
                       ap.sh2add + ap.slt + ap.ctz + ap.cpop + ap.siext_b +
                       ap.max + ap.pack + ap.grev + ap.csr_write +
                       (ap.sub && !ap.slt && !ap.max);
        endfunction : bmu_primary_count

        function automatic bmu_operation_t bmu_operation_code(bmu_ctrl_t ap, logic csr_ren);
                if ($isunknown({ap, csr_ren}))
                        return BMU_INVALID;
                if (csr_ren && ap == '0)
                        return BMU_CSR_READ;
                if (bmu_primary_count(ap) != 1)
                        return BMU_INVALID;
                if (ap.lor) return BMU_OR;
                if (ap.lxor) return BMU_XOR;
                if (ap.srl) return BMU_SRL;
                if (ap.sra) return BMU_SRA;
                if (ap.ror) return BMU_ROR;
                if (ap.binv) return BMU_BINV;
                if (ap.sh2add) return BMU_SH2ADD;
                if (ap.slt) return BMU_SLT;
                if (ap.max) return BMU_MAX;
                if (ap.sub) return BMU_SUB;
                if (ap.ctz) return BMU_CTZ;
                if (ap.cpop) return BMU_CPOP;
                if (ap.siext_b) return BMU_SEXTB;
                if (ap.pack) return BMU_PACK;
                if (ap.grev) return BMU_GREV;
                if (ap.csr_write) return BMU_CSR_WRITE;
                return BMU_INVALID;
        endfunction : bmu_operation_code

        function automatic bmu_ctrl_t bmu_allowed_controls(bmu_operation_t operation);
                bmu_ctrl_t allowed;
                allowed = '0;
                case (operation)
                        BMU_OR: begin allowed.lor = 1'b1; allowed.zbb = 1'b1; end
                        BMU_XOR: begin allowed.lxor = 1'b1; allowed.zbb = 1'b1; end
                        BMU_SRL: begin allowed.srl = 1'b1; end
                        BMU_SRA: begin allowed.sra = 1'b1; end
                        BMU_ROR: begin allowed.ror = 1'b1; end
                        BMU_BINV: begin allowed.binv = 1'b1; end
                        BMU_SH2ADD: begin allowed.sh2add = 1'b1; allowed.zba = 1'b1; end
                        BMU_SUB: begin allowed.sub = 1'b1; end
                        BMU_SLT: begin allowed.slt = 1'b1; allowed.sub = 1'b1; allowed.unsign = 1'b1; end
                        BMU_CTZ: begin allowed.ctz = 1'b1; end
                        BMU_CPOP: begin allowed.cpop = 1'b1; end
                        BMU_SEXTB: begin allowed.siext_b = 1'b1; end
                        BMU_MAX: begin allowed.max = 1'b1; allowed.sub = 1'b1; end
                        BMU_PACK: begin allowed.pack = 1'b1; end
                        BMU_GREV: begin allowed.grev = 1'b1; end
                        BMU_CSR_WRITE: begin allowed.csr_write = 1'b1; allowed.csr_imm = 1'b1; end
                        default: allowed = '0;
                endcase
                return allowed;
        endfunction : bmu_allowed_controls

        function automatic bit bmu_legal_controls(bmu_ctrl_t ap, logic csr_ren, logic [4:0] amount);
                bmu_operation_t operation;
                operation = bmu_operation_code(ap, csr_ren);
                if (operation == BMU_INVALID)
                        return 1'b0;
                if (operation == BMU_CSR_READ)
                        return 1'b1;
                if (csr_ren || (|(ap & ~bmu_allowed_controls(operation))))
                        return 1'b0;
                if (operation == BMU_SH2ADD && !ap.zba)
                        return 1'b0;
                if ((operation == BMU_SLT || operation == BMU_MAX) && !ap.sub)
                        return 1'b0;
                if (operation == BMU_GREV && amount !== 5'd24)
                        return 1'b0;
                return 1'b1;
        endfunction : bmu_legal_controls


endpackage : bmu_types_package