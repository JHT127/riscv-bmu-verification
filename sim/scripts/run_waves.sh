#!/usr/bin/env bash
# Run a single UVM test with an Xcelium SHM waveform dump under waveforms/.
#
# Usage: ./run_waves.sh <test_name> [seed] [verbosity]

set -euo pipefail

TEST="${1:?Usage: run_waves.sh <test_name> [seed] [verbosity]}"
SEED="${2:-1}"
VERBOSITY="${3:-UVM_LOW}"

SIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="${SIM_DIR}/../results/logs"
WAVES_DIR="${SIM_DIR}/../waveforms"
mkdir -p "${RESULTS_DIR}" "${WAVES_DIR}"

WAVE_SCRIPT="${WAVES_DIR}/${TEST}_${SEED}.tcl"
WAVE_DB="${WAVES_DIR}/${TEST}_${SEED}.shm"

cat > "${WAVE_SCRIPT}" <<EOF
database -open "${WAVE_DB}" -shm
probe -create -database "${WAVE_DB}" -all -depth all
run
EOF

echo "[waves] generating SHM dump for TEST=${TEST} SEED=${SEED} VERBOSITY=${VERBOSITY}"

xrun -64bit -uvm -sv -f "${SIM_DIR}/filelists/xcelium.f" \
  -coverage all -covoverwrite \
  -covworkdir "${SIM_DIR}/../results/coverage/${TEST}_${SEED}" \
  +UVM_TESTNAME="${TEST}" +ntb_random_seed="${SEED}" +UVM_VERBOSITY="${VERBOSITY}" \
  -access +rwc -input "${WAVE_SCRIPT}" \
  -l "${RESULTS_DIR}/${TEST}_${SEED}_waves.log"

echo "Wave SHM DB: ${WAVE_DB}"
