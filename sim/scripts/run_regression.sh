#!/usr/bin/env bash
# Run every test listed in a regression config and summarize pass/fail.
#
# Usage: ./run_regression.sh [config_file]
# Config file format: one "<test_name> <seed>" pair per line, '#' comments allowed.

set -euo pipefail

CONFIG="${1:-$(dirname "$0")/../../regression/configs/nightly.cfg}"
SUMMARY_DIR="$(dirname "$0")/../../results/reports"
mkdir -p "$SUMMARY_DIR"
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SIMULATOR="${SIMULATOR:-xcelium}"
RTL_REVISION="$(git -C "$REPO_ROOT" rev-parse --short HEAD)"
SIMULATOR_VERSION="$(xrun -version 2>&1 | head -1)"

if [ ! -f "$CONFIG" ]; then
  echo "Regression config not found: $CONFIG"
  echo "Create one under regression/configs/ (see regression/configs/README or .gitkeep placeholder)."
  exit 1
fi

PASS=0
FAIL=0
SUMMARY_FILE="${SUMMARY_DIR}/regression_summary_$(date +%Y%m%d_%H%M%S).txt"

echo "Regression run started: $(date)" | tee "$SUMMARY_FILE"
echo "Configuration: $CONFIG" | tee -a "$SUMMARY_FILE"
echo "Simulator: $SIMULATOR_VERSION" | tee -a "$SUMMARY_FILE"
echo "RTL revision: $RTL_REVISION" | tee -a "$SUMMARY_FILE"
echo "Coverage root: $REPO_ROOT/results/coverage" | tee -a "$SUMMARY_FILE"

while IFS= read -r line; do
  # skip comments/blank lines
  [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
  read -r TEST_NAME SEED <<< "$line"

  echo "-> Running ${TEST_NAME} (seed=${SEED})" | tee -a "$SUMMARY_FILE"
  if bash "$(dirname "$0")/run_test.sh" "$TEST_NAME" "$SEED"; then
    echo "   PASS" | tee -a "$SUMMARY_FILE"
    PASS=$((PASS + 1))
  else
    echo "   FAIL" | tee -a "$SUMMARY_FILE"
    FAIL=$((FAIL + 1))
  fi
  echo "   Log: $REPO_ROOT/results/logs/${TEST_NAME}_${SEED}.log" | tee -a "$SUMMARY_FILE"
  echo "   Coverage: $REPO_ROOT/results/coverage/${TEST_NAME}_${SEED}" | tee -a "$SUMMARY_FILE"
done < "$CONFIG"

echo "==============================" | tee -a "$SUMMARY_FILE"
echo "Regression complete: ${PASS} passed, ${FAIL} failed" | tee -a "$SUMMARY_FILE"

[ "$FAIL" -eq 0 ]
