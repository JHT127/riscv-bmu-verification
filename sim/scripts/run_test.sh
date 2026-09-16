#!/usr/bin/env bash
# Run a single UVM test and store the log under results/logs/.
#
# Usage: ./run_test.sh <test_name> [seed] [verbosity]

set -euo pipefail

TEST="${1:?Usage: run_test.sh <test_name> [seed] [verbosity]}"
SEED="${2:-1}"
VERBOSITY="${3:-UVM_MEDIUM}"

RESULTS_DIR="$(dirname "$0")/../../results/logs"
mkdir -p "$RESULTS_DIR"

echo "Running TEST=${TEST} SEED=${SEED} VERBOSITY=${VERBOSITY}"
make -C "$(dirname "$0")/.." run TEST="$TEST" SEED="$SEED" VERBOSITY="$VERBOSITY"

echo "Log: ${RESULTS_DIR}/${TEST}_${SEED}.log"
