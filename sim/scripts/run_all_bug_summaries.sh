#!/usr/bin/env bash
# Run the log-based evidence extraction for all BMU bug families.
#
# Usage:
#   ./sim/scripts/run_all_bug_summaries.sh
#
# This script produces one summary file per bug under:
#   results/bugs/<bug_key>/
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
  bug_006_invalid_controls
  bug_009_ctz
  bug_002_pack
  bug_003_csr
  bug_005_grev
  bug_007_slt_max
  bug_001_cpop
  bug_008_grev_invalid_encoding
)

for bug in "${BUGS[@]}"; do
  echo "[all_bugs] running: ${bug}"
  "${EXTRACTOR}" "${bug}" bmu_gap_checks_test 1
  echo
done

echo "[all_bugs] done"
echo "[all_bugs] results under: ${ROOT_DIR}/results/bugs"
