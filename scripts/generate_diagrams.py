#!/usr/bin/env python3
"""Generate architecture and coverage diagrams for the BMU DUT and UVM verification environment.

This script uses the Graphviz `dot` executable, which is already available in the repo environment.
It writes .dot source files and renders matching .png image outputs under docs/06_architecture_diagrams/.
"""

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "docs" / "06_architecture_diagrams"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def render_dot(dot_text: str, stem: str) -> Path:
    dot_path = OUT_DIR / f"{stem}.dot"
    png_path = OUT_DIR / f"{stem}.png"
    dot_path.write_text(dot_text, encoding="utf-8")
    subprocess.run([
        "dot",
        "-Tpng",
        str(dot_path),
        "-o",
        str(png_path),
    ], check=True)
    print(f"generated: {png_path.relative_to(ROOT)}")
    return png_path


def dut_diagram() -> str:
    return """
    digraph BMU_DUT {
        graph [
            rankdir=LR,
            splines=ortho,
            nodesep=0.6,
            ranksep=1.0,
            bgcolor="white",
            pad=0.25,
            fontname="Helvetica"
        ];
        node [shape=box, style="filled,rounded", fillcolor="#eaf3ff", color="#2d5d8a", fontname="Helvetica", margin="0.15,0.08"];
        edge [color="#2d5d8a", arrowsize=0.8];

        subgraph cluster_inputs {
            label="DUT inputs";
            color="#8db7d9";
            valid_in [label="valid_in"];
            rst_l [label="rst_l"];
            scan_mode [label="scan_mode"];
            ap [label="ap\ncontrol decode\n(ZBB/ZBS/ZBP/ZBA)"];
            a_in [label="a_in\n[31:0]"];
            b_in [label="b_in\n[31:0]"];
            csr_ren_in [label="csr_ren_in"];
            csr_rddata_in [label="csr_rddata_in\n[31:0]"];
        }

        subgraph cluster_core {
            label="BitManip execution core";
            color="#9ec4a8";
            decoder [label="control decode\n+ operation selection"];
            zbb [label="ZBB\nclz/ctz/cpop/..." ];
            zbs [label="ZBS\nbset/bclr/binv/bext"];
            zbp [label="ZBP\npack/packh/grev"];
            zba [label="ZBA\nsh1add/sh2add/sh3add"];
            result [label="result mux\n+ shift/logic/add/sub"];
            err [label="error flag\ninvalid/illegal op"];
        }

        subgraph cluster_outputs {
            label="DUT outputs";
            color="#d9b37d";
            result_ff [label="result_ff\n[31:0]"];
            error_out [label="error"];
        }

        valid_in -> decoder;
        rst_l -> decoder;
        scan_mode -> decoder;
        ap -> decoder;
        a_in -> result;
        b_in -> result;
        csr_ren_in -> decoder;
        csr_rddata_in -> result;

        decoder -> zbb;
        decoder -> zbs;
        decoder -> zbp;
        decoder -> zba;
        zbb -> result;
        zbs -> result;
        zbp -> result;
        zba -> result;
        result -> result_ff;
        result -> err;
        err -> error_out;
    }
    """


def uvm_env_diagram() -> str:
    return """
    digraph BMU_UVM_ENV {
        graph [
            rankdir=TB,
            nodesep=0.7,
            ranksep=1.1,
            bgcolor="white",
            pad=0.2,
            fontname="Helvetica"
        ];
        node [shape=box, style="filled,rounded", fillcolor="#f7f3ff", color="#6c5b9b", fontname="Helvetica", margin="0.12,0.08"];
        edge [color="#4b3d7a", arrowsize=0.8];

        subgraph cluster_test {
            label="UVM test";
            color="#c7b8e8";
            test [label="bmu_*_test\nselects sequence"];
            seq [label="sequence\nlegal/random/direct"];
        }

        subgraph cluster_env {
            label="Testbench environment";
            color="#cfe8ff";
            env [label="bmu_environment"];
            agent [label="bmu_agent\n(driver + monitor + sequencer)"];
            ref [label="bmu_reference_model\nexpected results"];
            sb [label="bmu_scoreboard\nactual vs expected"];
            cov [label="bmu_coverage\nfunctional coverage"];
        }

        subgraph cluster_dut {
            label="DUT bridge";
            color="#d9f2d9";
            vif [label="bmu_interface\nclocking blocks + modports"];
            dut [label="Bit_Manipulation_Unit\nRTL DUT"];
        }

        test -> seq;
        seq -> agent;
        agent -> vif;
        vif -> dut;
        dut -> vif;
        vif -> agent;

        agent -> ref [label="monitor txn"];
        agent -> sb [label="actual txn"];
        ref -> sb [label="expected txn"];
        agent -> cov [label="sample"];
        sb -> report [label="pass/fail"];
        cov -> report [label="coverage bins"];

        report [label="simulation log\n+ coverage DB"];
    }
    """


def coverage_diagram() -> str:
    return """
    digraph BMU_COVERAGE {
        graph [
            rankdir=TB,
            nodesep=0.7,
            ranksep=1.0,
            bgcolor="white",
            pad=0.25,
            fontname="Helvetica"
        ];
        node [shape=box, style="filled,rounded", fillcolor="#eefaf2", color="#2f7d5b", fontname="Helvetica", margin="0.12,0.08"];
        edge [color="#2f7d5b", arrowsize=0.8];

        tests [label="tests / sequences\nlegal_random / coverage_closure / max_coverage", shape=box3d, fillcolor="#edf7ff"];
        op [label="cp_operation\noperation family coverage"];
        patt [label="cp_operand_pattern\noperand shape coverage"];
        shift [label="cp_shift_amount\nshift amount bins"];
        error [label="cp_error\nclean vs rejected"];
        valid [label="cp_valid / cp_reset / cp_scan\ntransaction context"];
        cross [label="cross coverage\noperation x valid\noperation x error"];
        db [label="coverage database\nIMC/Xcelium"];
        report [label="coverage summary\npass/fail closure"];

        tests -> op;
        tests -> patt;
        tests -> shift;
        tests -> error;
        tests -> valid;
        tests -> cross;

        op -> db;
        patt -> db;
        shift -> db;
        error -> db;
        valid -> db;
        cross -> db;
        db -> report;
    }
    """


def main() -> None:
    print(f"rendering diagrams into: {OUT_DIR.relative_to(ROOT)}")
    render_dot(dut_diagram(), "bmu_dut_block_diagram")
    render_dot(uvm_env_diagram(), "bmu_uvm_environment")
    render_dot(coverage_diagram(), "bmu_coverage_overview")
    print("\nAll diagrams generated successfully.")


if __name__ == "__main__":
    main()
