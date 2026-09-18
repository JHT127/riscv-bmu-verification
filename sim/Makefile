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
WAVES_DIR   := ../waveforms
XRUN        ?= xrun

ifeq ($(SIMULATOR),xcelium)
XRUN_BASE   := $(XRUN) -64bit -uvm -sv -f $(FILELIST)
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

compile:
	@mkdir -p $(RESULTS_DIR)
	@echo "[compile] SIMULATOR=$(SIMULATOR) FILELIST=$(FILELIST)"
	$(XRUN_BASE) -compile -l $(RESULTS_DIR)/compile_$(SIMULATOR).log

run: compile
	@mkdir -p $(RESULTS_DIR)
	@echo "[run] TEST=$(TEST) SEED=$(SEED) VERBOSITY=$(VERBOSITY)"
	$(XRUN_BASE) +UVM_TESTNAME=$(TEST) +ntb_random_seed=$(SEED) \
		+UVM_VERBOSITY=$(VERBOSITY) -l $(RESULTS_DIR)/$(TEST)_$(SEED).log
	@if grep -Eq 'UVM_(ERROR|FATAL) :[[:space:]]+[1-9]' $(RESULTS_DIR)/$(TEST)_$(SEED).log; then \
		echo "[run] FAIL: UVM errors or fatals recorded" >&2; \
		exit 1; \
	fi

waves: compile
	@mkdir -p $(WAVES_DIR)
	@echo "[waves] TEST=$(TEST) -> enabling Xcelium waveform access"
	$(XRUN_BASE) +UVM_TESTNAME=$(TEST) +ntb_random_seed=$(SEED) \
		+UVM_VERBOSITY=$(VERBOSITY) -access +rwc \
		-l $(RESULTS_DIR)/$(TEST)_$(SEED)_waves.log

regression:
	@echo "[regression] delegating to scripts/run_regression.sh"
	@bash scripts/run_regression.sh

clean:
	@echo "[clean] removing simulator artifacts"
	@rm -rf csrc simv* *.daidir *.vdb *.log ucli.key DVEfiles *.shm *.shm.db work \
		xcelium.d INCA_libs .simvision
