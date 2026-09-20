#!/usr/bin/env bash
# Extract the bug evidence from the simulator log without opening SimVision.
#
# Usage:
#   ./sim/scripts/extract_bug_summary.sh bug_006_invalid_controls bmu_gap_checks_test 1
#
# Output:
#   results/bugs/<bug_key>/<bug_key>_<seed>_summary.txt
#   results/bugs/<bug_key>/<bug_key>_<seed>_context.txt

set -euo pipefail

BUG_KEY="${1:-}"
TEST_NAME="${2:-bmu_gap_checks_test}"
SEED="${3:-1}"

if [[ -z "${BUG_KEY}" ]]; then
  echo "Usage: $0 <bug_key> [test_name] [seed]"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_PATH="${ROOT_DIR}/results/logs/${TEST_NAME}_${SEED}.log"
OUT_DIR="${ROOT_DIR}/results/bugs/${BUG_KEY}"
mkdir -p "${OUT_DIR}"
SUMMARY_PATH="${OUT_DIR}/${BUG_KEY}_${SEED}_summary.txt"
CONTEXT_PATH="${OUT_DIR}/${BUG_KEY}_${SEED}_context.txt"

if [[ ! -f "${LOG_PATH}" ]]; then
  echo "[evidence] log not found: ${LOG_PATH}"
  echo "[evidence] run the test first, for example:"
  echo "  make TEST=${TEST_NAME} SEED=${SEED} VERBOSITY=UVM_LOW"
  exit 1
fi

# Pull the most relevant lines from the log.
grep -nE 'UVM_(ERROR|FATAL)|Mismatch|mismatch|expected|actual|ASSERT|assert|CHECK|check|error' "${LOG_PATH}" | head -n 200 > "${CONTEXT_PATH}" || true

{
  echo "BUG: ${BUG_KEY}"
  echo "TEST: ${TEST_NAME}"
  echo "SEED: ${SEED}"
  echo "LOG: ${LOG_PATH}"
  echo ""
  echo "First lines with issue markers:"
  cat "${CONTEXT_PATH}"
  echo ""
  echo "If you want more context, open the same log and search for '${BUG_KEY}' or 'UVM_ERROR'."
} > "${SUMMARY_PATH}"

echo "[evidence] summary written to: ${SUMMARY_PATH}"
echo "[evidence] context written to: ${CONTEXT_PATH}"
