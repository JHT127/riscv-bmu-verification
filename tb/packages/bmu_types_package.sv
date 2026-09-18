
// bmu types package ===========================================


package bmu_types_package;

        // decoded operation controls from the RTL/control contract.
        // This mirrors the exposed subset of rtl_alu_pkt_t so the TB can
        // actively drive the otherwise unreachable branches without editing DUT RTL.
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


endpackage : bmu_types_package