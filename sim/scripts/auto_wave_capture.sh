#!/usr/bin/env bash
# Auto-capture a waveform PNG for a BMU bug reproducer.
#
# Usage:
#   ./sim/scripts/auto_wave_capture.sh <test_name> [seed] [png_name] [bug_key]
#
# Examples:
#   ./sim/scripts/auto_wave_capture.sh bmu_gap_checks_test 1
#   ./sim/scripts/auto_wave_capture.sh bmu_gap_checks_test 1 bug_006_guard.png invalid
#   ./sim/scripts/auto_wave_capture.sh bmu_gap_checks_test 1 bug_009_ctz.png ctz
#
# This script:
#   1. reuses the SHM database if it already exists,
#   2. finds the first mismatch time from the log,
#   3. uses a BMU bug-specific signal list to keep the waveform focused,
#   4. launches SimVision snapshot export to a PNG in waveforms/

set -euo pipefail

TEST="${1:-bmu_gap_checks_test}"
SEED="${2:-1}"
PNG_NAME="${3:-${TEST}_${SEED}_auto.png}"
BUG_KEY="${4:-default}"

SIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$(cd "${SIM_DIR}/.." && pwd)"
RESULTS_DIR="${ROOT_DIR}/results/logs"
WAVES_DIR="${ROOT_DIR}/waveforms"
DB_DIR="${WAVES_DIR}/${TEST}_${SEED}.shm"
LOG_FILE="${RESULTS_DIR}/${TEST}_${SEED}.log"
PNG_FILE="${WAVES_DIR}/${PNG_NAME}"
TMP_TCL="$(mktemp "${WAVES_DIR}/auto_wave_${TEST}_${SEED}.XXXXXX.tcl")"

mkdir -p "${WAVES_DIR}"

select_signal_group() {
  case "${BUG_KEY}" in
    cpop|cpop_high|cypop) echo "cpop" ;;
    pack|pack_order) echo "pack" ;;
    csr|csr_write|csr_imm) echo "csr" ;;
    grev|grev_valid|grev_invalid) echo "grev" ;;
    invalid|guard|conflict|empty) echo "invalid" ;;
    slt|max|sltmax|slt_max) echo "sltmax" ;;
    ctz|ctz_zero) echo "ctz" ;;
    *) echo "default" ;;
  esac
}

SIG_GROUP="$(select_signal_group)"

if [[ ! -d "${DB_DIR}" ]]; then
  echo "[auto_wave] SHM database not found: ${DB_DIR}"
  echo "[auto_wave] Running xrun with waveform capture enabled..."
  cd "${SIM_DIR}"
  xrun -64bit -uvm -sv -f filelists/xcelium.f \
    -coverage all -covoverwrite \
    -covworkdir "${ROOT_DIR}/results/coverage/${TEST}_${SEED}" \
    +UVM_TESTNAME="${TEST}" +ntb_random_seed="${SEED}" +UVM_VERBOSITY=UVM_LOW \
    -access +rwc \
    -l "${RESULTS_DIR}/${TEST}_${SEED}_waves.log"
fi

if [[ ! -f "${LOG_FILE}" ]]; then
  echo "[auto_wave] ERROR: log not found: ${LOG_FILE}" >&2
  exit 1
fi

MATCH_TIME="$(grep -E "UVM_(ERROR|FATAL).* @ [0-9]+:" "${LOG_FILE}" | head -n 1 | sed -E 's/.* @ ([0-9]+):.*/\1/' || true)"

if [[ -z "${MATCH_TIME}" ]]; then
  MATCH_TIME=1000
  echo "[auto_wave] No mismatch time found in log; using default ${MATCH_TIME} ns"
else
  echo "[auto_wave] First mismatch time resolved to ${MATCH_TIME} ns"
fi

START_NS=$(( MATCH_TIME - 20 ))
END_NS=$(( MATCH_TIME + 20 ))

case "${SIG_GROUP}" in
  cpop)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.reset_n
      bmu_tb_top.dut.ap.cpop
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  pack)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.dut.ap.pack
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  csr)
    SIGNALS=(
      bmu_tb_top.clk
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
  grev)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.dut.ap.grev
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.actual_result_ff
    )
    ;;
  invalid)
    SIGNALS=(
      bmu_tb_top.clk
      bmu_tb_top.dut.ap
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.dut.valid
      bmu_tb_top.environment.scoreboard.expected_error
      bmu_tb_top.environment.scoreboard.actual_error
    )
    ;;
  sltmax)
    SIGNALS=(
      bmu_tb_top.clk
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
  ctz)
    SIGNALS=(
      bmu_tb_top.clk
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
      bmu_tb_top.reset_n
      bmu_tb_top.dut.ap
      bmu_tb_top.dut.a_in
      bmu_tb_top.dut.b_in
      bmu_tb_top.dut.result_ff
      bmu_tb_top.dut.error
      bmu_tb_top.environment.scoreboard.expected_result_ff
      bmu_tb_top.environment.scoreboard.expected_error
      bmu_tb_top.environment.scoreboard.actual_result_ff
      bmu_tb_top.environment.scoreboard.actual_error
    )
    ;;
esac

cat > "${TMP_TCL}" <<EOF
# Auto-generated signal set for BMU bug capture
# test: ${TEST}
# seed: ${SEED}
# bug key: ${BUG_KEY}
# signal group: ${SIG_GROUP}
# mismatch time: ${MATCH_TIME} ns

if { [catch {database -open "${DB_DIR}" -shm}] } {
  puts "ERROR: SHM database not found: ${DB_DIR}"
  exit 1
}

probe -create -database "${DB_DIR}" -all -depth all
wave -new
wave -window -title "BMU ${TEST} / ${BUG_KEY} / ${MATCH_TIME} ns"

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

SIMVISION_CMD=(simvision -64 -input "${TMP_TCL}" -snapshot "${PNG_FILE}")

echo "[auto_wave] signal group: ${SIG_GROUP}"
echo "[auto_wave] generating PNG: ${PNG_FILE}"
echo "[auto_wave] command: ${SIMVISION_CMD[*]}"

"${SIMVISION_CMD[@]}"

rm -f "${TMP_TCL}"

echo "[auto_wave] done: ${PNG_FILE}"
