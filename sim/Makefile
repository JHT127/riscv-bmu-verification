# ==============================================================================
# BMU Verification — Simulation Makefile
# Simulator-agnostic template. Fill in the tool-specific invocations for the
# simulator available to you (VCS / Questa / Xcelium).
# ==============================================================================

SIMULATOR   ?= vcs
TEST        ?= dut_base_test
SEED        ?= 1
VERBOSITY   ?= UVM_MEDIUM
FILELIST    := filelists/$(SIMULATOR).f
RESULTS_DIR := ../results/logs
WAVES_DIR   := ../waveforms

.PHONY: all compile run regression waves clean help

all: compile run

help:
	@echo "Targets:"
	@echo "  make compile              - compile RTL + UVM testbench"
	@echo "  make run TEST=<name>      - run a single UVM test"
	@echo "  make regression           - run the full regression suite"
	@echo "  make waves TEST=<name>    - run a test with waveform dumping enabled"
	@echo "  make clean                - remove simulator artifacts"
	@echo ""
	@echo "Variables: SIMULATOR (default: vcs), TEST, SEED, VERBOSITY"

compile:
	@echo "[compile] SIMULATOR=$(SIMULATOR) FILELIST=$(FILELIST)"
	@echo "TODO: invoke $(SIMULATOR) compile step using $(FILELIST)"

run: compile
	@mkdir -p $(RESULTS_DIR)
	@echo "[run] TEST=$(TEST) SEED=$(SEED) VERBOSITY=$(VERBOSITY)"
	@echo "TODO: invoke $(SIMULATOR) run step, e.g.:"
	@echo "  simv +UVM_TESTNAME=$(TEST) +ntb_random_seed=$(SEED) +UVM_VERBOSITY=$(VERBOSITY) \\"
	@echo "       -l $(RESULTS_DIR)/$(TEST)_$(SEED).log"

waves: compile
	@mkdir -p $(WAVES_DIR)
	@echo "[waves] TEST=$(TEST) -> dumping to $(WAVES_DIR)/$(TEST).fsdb (or .vcd)"
	@echo "TODO: invoke run step with waveform dumping enabled"

regression:
	@echo "[regression] delegating to scripts/run_regression.sh"
	@bash scripts/run_regression.sh

clean:
	@echo "[clean] removing simulator artifacts"
	@rm -rf csrc simv* *.daidir *.vdb *.log ucli.key DVEfiles *.shm *.shm.db work \
	        xcelium.d xrun.* .simvision
