#!/usr/bin/env bash
# Extract bug evidence from the simulator log without opening SimVision.
#
# Usage:
#   ./sim/scripts/extract_bug_summary.sh BMU-BUG-006 bmu_gap_checks_test 1
#   ./sim/scripts/extract_bug_summary.sh bug_006_invalid_controls bmu_gap_checks_test 1
#
# Output:
#   results/bugs/BMU-BUG-006/BMU-BUG-006_1_summary.txt
#   results/bugs/BMU-BUG-006/BMU-BUG-006_1_context.txt

set -euo pipefail

BUG_KEY="${1:-}"
TEST_NAME="${2:-bmu_gap_checks_test}"
SEED="${3:-1}"

if [[ -z "${BUG_KEY}" ]]; then
  echo "Usage: $0 <bug_id_or_alias> [test_name] [seed]"
  echo "Examples:"
  echo "  $0 BMU-BUG-006 bmu_gap_checks_test 1"
  echo "  $0 bug_006_invalid_controls bmu_gap_checks_test 1"
  exit 1
fi

canonicalize_bug_id() {
  case "${1}" in
    BMU-BUG-001|001|bug_001_cpop|cpop) echo "BMU-BUG-001" ;;
    BMU-BUG-002|002|bug_002_pack|pack) echo "BMU-BUG-002" ;;
    BMU-BUG-003|003|bug_003_csr|csr) echo "BMU-BUG-003" ;;
    BMU-BUG-005|005|bug_005_grev|grev) echo "BMU-BUG-005" ;;
    BMU-BUG-006|006|bug_006_invalid_controls|invalid|guard) echo "BMU-BUG-006" ;;
    BMU-BUG-007|007|bug_007_slt_max|sltmax|slt|max) echo "BMU-BUG-007" ;;
    BMU-BUG-008|008|bug_008_grev_invalid_encoding|grev_invalid) echo "BMU-BUG-008" ;;
    BMU-BUG-009|009|bug_009_ctz|ctz) echo "BMU-BUG-009" ;;
    *) echo "${1}" ;;
  esac
}

BUG_ID="$(canonicalize_bug_id "${BUG_KEY}")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_PATH="${ROOT_DIR}/results/logs/${TEST_NAME}_${SEED}.log"
OUT_DIR="${ROOT_DIR}/results/bugs/${BUG_ID}"
mkdir -p "${OUT_DIR}"
SUMMARY_PATH="${OUT_DIR}/${BUG_ID}_${SEED}_summary.txt"
CONTEXT_PATH="${OUT_DIR}/${BUG_ID}_${SEED}_context.txt"

if [[ ! -f "${LOG_PATH}" ]]; then
  echo "[evidence] log not found: ${LOG_PATH}"
  echo "[evidence] run the test first, for example:"
  echo "  make TEST=${TEST_NAME} SEED=${SEED} VERBOSITY=UVM_LOW"
  exit 1
fi

# Pull the most relevant lines from the log.
grep -nE 'UVM_(ERROR|FATAL)|Mismatch|mismatch|expected|actual|ASSERT|assert|CHECK|check|error' "${LOG_PATH}" | head -n 200 > "${CONTEXT_PATH}" || true

{
  echo "BUG_ID: ${BUG_ID}"
  echo "BUG_KEY: ${BUG_KEY}"
  echo "TEST: ${TEST_NAME}"
  echo "SEED: ${SEED}"
  echo "LOG: ${LOG_PATH}"
  echo ""
  echo "First lines with issue markers:"
  cat "${CONTEXT_PATH}"
  echo ""
  echo "If you want more context, open the same log and search for '${BUG_ID}' or 'UVM_ERROR'."
} > "${SUMMARY_PATH}"

echo "[evidence] summary written to: ${SUMMARY_PATH}"
echo "[evidence] context written to: ${CONTEXT_PATH}"
