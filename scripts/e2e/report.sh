#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOG_DIR="${LOG_DIR:-${ROOT}/.e2e-logs}"
REPORT_DIR="${ROOT}/.hauski-reports"
mkdir -p "${REPORT_DIR}"
mkdir -p "${LOG_DIR}"

STAMP="$(date -u +"%Y-%m-%dT%H-%M-%SZ")"
OUT="${REPORT_DIR}/${STAMP}-e2e-aussen-leitstand-heimlern.md"

cat >"${OUT}" <<'MD'
# E2E-Report: aussensensor → leitstand → heimlern

Dieser Report bündelt die Logs des End-to-End-Laufs (Trocken- und Echtlauf).

## Artefakte
MD

{
  echo ""
  echo "Log-Verzeichnis: \`${LOG_DIR}\`"
  echo ""
} >>"${OUT}"

emit() {
  local title="$1"; local file="$2"
  if [[ -s "${file}" ]]; then
    {
      echo "### ${title}"
      echo ""
      echo '```txt'
      sed -e 's/\x1b\[[0-9;]*m//g' "${file}" | tail -n 5000 || true
      echo '```'
      echo ""
    } >>"${OUT}"
  fi
}

emit "01 validate.sh"            "${LOG_DIR}/01_validate.out"
emit "02 push_leitstand (dry)"   "${LOG_DIR}/02_push_leitstand_dry.out"
emit "03 push_heimlern (dry)"    "${LOG_DIR}/03_push_heimlern_dry.out"
emit "04 push_leitstand (real)"  "${LOG_DIR}/04_push_leitstand_real.out"
emit "05 push_heimlern (real)"   "${LOG_DIR}/05_push_heimlern_real.out"
emit "Gesamtlog"                 "${LOG_DIR}/e2e.log"

echo "✓ Report: $(realpath "${OUT}")"
