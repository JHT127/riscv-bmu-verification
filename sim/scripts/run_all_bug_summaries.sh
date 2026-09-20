#!/usr/bin/env bash
# Run the log-based evidence extraction for all BMU bug families.
#
# Usage:
#   ./sim/scripts/run_all_bug_summaries.sh
#
# This script produces one summary file per bug under:
#   results/bugs/BMU-BUG-<n>/
#
# It does not require SimVision or GUI access.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
EXTRACTOR="${ROOT_DIR}/sim/scripts/extract_bug_summary.sh"

if [[ ! -x "${EXTRACTOR}" ]]; then
  echo "[all_bugs] extractor not executable: ${EXTRACTOR}"
  exit 1
fi

BUGS=(
  BMU-BUG-006
  BMU-BUG-009
  BMU-BUG-002
  BMU-BUG-003
  BMU-BUG-005
  BMU-BUG-007
  BMU-BUG-001
  BMU-BUG-008
)

for bug in "${BUGS[@]}"; do
  echo "[all_bugs] running: ${bug}"
  "${EXTRACTOR}" "${bug}" bmu_gap_checks_test 1
  echo
done

echo "[all_bugs] done"
echo "[all_bugs] results under: ${ROOT_DIR}/results/bugs"
