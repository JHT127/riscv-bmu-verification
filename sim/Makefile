# ==============================================================================
# BMU Verification — Simulation Makefile
# Xcelium execution entry point for the checked-in BMU verification baseline.
# VCS and Questa remain unsupported until simulator-specific commands are added.
# ==============================================================================

SIMULATOR   ?= xcelium
TEST        ?= bmu_or_valid_test
SEED        ?= 1
VERBOSITY   ?= UVM_MEDIUM
FILELIST    := filelists/$(SIMULATOR).f
RESULTS_DIR := ../results/logs
COVERAGE_DIR := ../results/coverage
WAVES_DIR   := ../waveforms
XRUN        ?= xrun
TOP         ?= bmu_tb_top
XRUN_EXTRA  ?=
TIMEOUT     ?= 1000000
CONFIG      ?= ../regression/configs/full.cfg

ifeq ($(SIMULATOR),xcelium)
XRUN_BASE   := $(XRUN) -64bit -uvm -sv -top $(TOP) -f $(FILELIST)
else
$(error Unsupported SIMULATOR=$(SIMULATOR); use SIMULATOR=xcelium)
endif

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
	@echo "Variables: SIMULATOR (default: xcelium), TEST, SEED, VERBOSITY"
	@echo "Waveform helper: ./scripts/run_waves.sh <test> [seed] [verbosity]"

compile:
	@mkdir -p $(RESULTS_DIR)
	@echo "[compile] SIMULATOR=$(SIMULATOR) FILELIST=$(FILELIST)"
	$(XRUN_BASE) -compile -l $(RESULTS_DIR)/compile_$(SIMULATOR).log

run: compile
	@mkdir -p $(RESULTS_DIR)
	@mkdir -p $(COVERAGE_DIR)/$(TEST)_$(SEED)
	@echo "[run] TEST=$(TEST) SEED=$(SEED) VERBOSITY=$(VERBOSITY)"
	$(XRUN_BASE) $(XRUN_EXTRA) -coverage all -covoverwrite \
		-covworkdir $(COVERAGE_DIR)/$(TEST)_$(SEED) \
		+UVM_TESTNAME=$(TEST) -svseed $(SEED) \
		+UVM_TIMEOUT=$(TIMEOUT),YES +UVM_VERBOSITY=$(VERBOSITY) -l $(RESULTS_DIR)/$(TEST)_$(SEED).log
	@python3 scripts/check_result.py $(RESULTS_DIR)/$(TEST)_$(SEED).log

waves:
	@bash scripts/run_waves.sh $(TEST) $(SEED) $(VERBOSITY)

regression:
	@echo "[regression] delegating to scripts/run_regression.sh"
	@bash scripts/run_regression.sh $(CONFIG)

clean:
	@echo "[clean] removing simulator artifacts"
	@rm -rf csrc simv* *.daidir *.vdb *.log ucli.key DVEfiles *.shm *.shm.db work \
		xcelium.d INCA_libs .simvision
