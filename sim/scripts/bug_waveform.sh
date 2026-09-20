#!/usr/bin/env bash
# BMU bug waveform capture helper.
#
# Usage:
#   ./sim/scripts/bug_waveform.sh bug_006_invalid_controls [seed] [test_name]
#   ./sim/scripts/bug_waveform.sh bug_009_ctz [seed] [test_name]
#
# The script does the following automatically:
#   1. maps the bug key to the canonical test and signal set
#   2. creates a bug-specific SHM directory and file names under waveforms/bugs/
#   3. finds the first mismatch time from the log and picks a tight +/-20 ns window
#   4. opens SimVision with the right signals already selected and zoomed
#
# Output naming convention:
#   waveforms/bugs/<bug_key>/<bug_key>_<seed>.shm
#   waveforms/bugs/<bug_key>/<bug_key>_<seed>.tcl
#   results/logs/<test_name>_<seed>.log
#
# Save the waveform as PNG from the SimVision GUI once it opens.

set -euo pipefail

BUG_KEY="${1:-}"
SEED="${2:-1}"
TEST_NAME="${3:-bmu_gap_checks_test}"

if [[ -z "${BUG_KEY}" ]]; then
  echo "Usage: $0 <bug_key> [seed] [test_name]"
  echo "Examples:"
  echo "  $0 bug_001_cpop 1"
  echo "  $0 bug_006_invalid_controls 1"
  echo "  $0 bug_009_ctz 1"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SIM_DIR="${ROOT_DIR}/sim"
RESULTS_DIR="${ROOT_DIR}/results/logs"
WAVE_ROOT="${ROOT_DIR}/waveforms/bugs"
BUG_DIR="${WAVE_ROOT}/${BUG_KEY}"
DB_PATH="${BUG_DIR}/${BUG_KEY}_${SEED}.shm"
TCL_PATH="${BUG_DIR}/${BUG_KEY}_${SEED}.tcl"
LOG_PATH="${RESULTS_DIR}/${TEST_NAME}_${SEED}.log"

mkdir -p "${BUG_DIR}"

canonicalize_bug_key() {
  case "${1}" in
    001|001_cpop|cpop|BMU-BUG-001|bug_001_cpop) echo "bug_001_cpop" ;;
    002|002_pack|pack|BMU-BUG-002|bug_002_pack) echo "bug_002_pack" ;;
    003|003_csr|csr|BMU-BUG-003|bug_003_csr) echo "bug_003_csr" ;;
    005|005_grev|grev|BMU-BUG-005|bug_005_grev) echo "bug_005_grev" ;;
    006|006_invalid|invalid|guard|BMU-BUG-006|bug_006_invalid_controls) echo "bug_006_invalid_controls" ;;
    007|007_sltmax|sltmax|slt|max|BMU-BUG-007|bug_007_slt_max) echo "bug_007_slt_max" ;;
    008|008_grev_invalid|grev_invalid|BMU-BUG-008|bug_008_grev_invalid_encoding) echo "bug_008_grev_invalid_encoding" ;;
    009|009_ctz|ctz|BMU-BUG-009|bug_009_ctz) echo "bug_009_ctz" ;;
    *) echo "${1}" ;;
  esac
}

BUG_KEY="$(canonicalize_bug_key "${BUG_KEY}")"
BUG_DIR="${WAVE_ROOT}/${BUG_KEY}"
DB_PATH="${BUG_DIR}/${BUG_KEY}_${SEED}.shm"
TCL_PATH="${BUG_DIR}/${BUG_KEY}_${SEED}.tcl"

# Map bug family to the relevant signal list.
case "${BUG_KEY}" in
  bug_001_cpop)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.rst_l
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.cpop
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  bug_002_pack)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.pack
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  bug_003_csr)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.csr_write
      bmu_tb_top.dut.ap.csr_imm
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  bug_005_grev)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.grev
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  bug_006_invalid_controls)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_error
      bmu_tb_top.environment.scoreboard.actual_error
    )
    ;;
  bug_007_slt_max)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.sub
      bmu_tb_top.dut.ap.slt
      bmu_tb_top.dut.ap.max
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  bug_008_grev_invalid_encoding)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.grev
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  bug_009_ctz)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap.ctz
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  *)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.bmu_if.valid_in
      bmu_tb_top.dut.ap
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
    )
    ;;
esac

if [[ ! -f "${LOG_PATH}" ]]; then
  echo "[bug_wave] log not found: ${LOG_PATH}"
  echo "[bug_wave] running ${TEST_NAME} seed ${SEED} to generate it"
  cd "${SIM_DIR}"
  make TEST="${TEST_NAME}" SEED="${SEED}" VERBOSITY=UVM_LOW > /dev/null
fi

if [[ ! -f "${LOG_PATH}" ]]; then
  echo "[bug_wave] ERROR: test did not create the expected log at ${LOG_PATH}" >&2
  exit 1
fi

MATCH_TIME="$(grep -E 'UVM_(ERROR|FATAL).* @ [0-9]+:' "${LOG_PATH}" | head -n 1 | sed -E 's/.* @ ([0-9]+):.*/\1/' || true)"
if [[ -z "${MATCH_TIME}" ]]; then
  MATCH_TIME=1000
  echo "[bug_wave] no explicit mismatch time found; using ${MATCH_TIME} ns"
else
  echo "[bug_wave] first mismatch time: ${MATCH_TIME} ns"
fi

START_NS=$(( MATCH_TIME - 20 ))
END_NS=$(( MATCH_TIME + 20 ))

cat > "${TCL_PATH}" <<EOF
# Auto-generated BMU bug waveform setup
# bug: ${BUG_KEY}
# test: ${TEST_NAME}
# seed: ${SEED}
# mismatch time: ${MATCH_TIME} ns

if { [catch {database -open "${DB_PATH}" -shm}] } {
  puts "ERROR: SHM DB not found: ${DB_PATH}"
  exit 1
}

probe -create -database "${DB_PATH}" -all -depth all
wave -new
wave -window -title "${BUG_KEY} @ ${MATCH_TIME} ns"
foreach sig {
  $(printf '%s\n' "${SIGNALS[@]}" | sed 's/^/  /')
} {
  if { [catch {wave -add \$sig}] } {
    puts "warning: signal not found -> \$sig"
  }
}
wave -cursor "${MATCH_TIME} ns"
wave -zoom range "${START_NS} ns" "${END_NS} ns"
EOF

if [[ ! -d "${DB_PATH}" ]]; then
  echo "[bug_wave] SHM DB not found: ${DB_PATH}"
  echo "[bug_wave] running Xcelium with SHM capture enabled"
  cd "${SIM_DIR}"
  xrun -64bit -uvm -sv -f filelists/xcelium.f \
    -coverage all -covoverwrite \
    -covworkdir "${ROOT_DIR}/results/coverage/${TEST_NAME}_${SEED}" \
    +UVM_TESTNAME="${TEST_NAME}" +ntb_random_seed="${SEED}" +UVM_VERBOSITY=UVM_LOW \
    -access +rwc \
    -l "${RESULTS_DIR}/${TEST_NAME}_${SEED}_waves.log"
fi

if [[ ! -d "${DB_PATH}" ]]; then
  echo "[bug_wave] ERROR: SHM DB still missing after Xcelium run: ${DB_PATH}" >&2
  exit 1
fi

echo "[bug_wave] bug wave directory: ${BUG_DIR}"
echo "[bug_wave] waveform DB: ${DB_PATH}"
echo "[bug_wave] setup file: ${TCL_PATH}"
echo "[bug_wave] open the GUI with: simvision -64 -waves -input \"${TCL_PATH}\""
echo "[bug_wave] then save the waveform as PNG from the SimVision menu"

if ! command -v simvision >/dev/null 2>&1; then
  echo "[bug_wave] simvision not found in PATH; install Cadence tools or run from a shell with the toolchain loaded." >&2
  exit 1
fi

simvision -64 -waves -input "${TCL_PATH}"
