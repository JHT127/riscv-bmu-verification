
// bmu types package ===========================================


package bmu_types_package;

        // decoded operation controls from Specification v1.2
        typedef struct packed {
                logic lor;
                logic lxor;
                logic zbb;
                logic srl;
                logic sra;
                logic ror;
                logic binv;
                logic sh2add;
                logic zba;
                logic sub;
                logic slt;
                logic unsign;
                logic ctz;
                logic cpop;
                logic siext_b;
                logic max;
                logic pack;
                logic grev;
                logic csr_write;
                logic csr_imm;
        } bmu_ctrl_t;


endpackage : bmu_types_package