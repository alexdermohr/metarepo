#!/usr/bin/env bash
set -euo pipefail
# Pin & Ensure für mikefarah/yq v4.x – ohne Netz zur Laufzeit.
# Erwartet, dass ein kompatibles Binary entweder in ./tools/bin/yq liegt oder im PATH verfügbar ist.

REQ_MAJOR=4
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TOOLS_DIR="${ROOT_DIR}/tools"
BIN_DIR="${TOOLS_DIR}/bin"
YQ_LOCAL="${BIN_DIR}/yq"

log(){ printf '%s\n' "$*" >&2; }
die(){ log "ERR: $*"; exit 1; }

ensure_dir(){ mkdir -p -- "${BIN_DIR}"; }

have_cmd(){ command -v "$1" >/dev/null 2>&1; }

version_ok(){
  local v="$1"
  [[ "$v" =~ ^([0-9]+)\. ]] || return 1
  local major="${BASH_REMATCH[1]}"
  [[ "${major}" -eq "${REQ_MAJOR}" ]]
}

resolved_yq(){
  if [[ -x "${YQ_LOCAL}" ]]; then
    echo "${YQ_LOCAL}"
    return 0
  fi
  if have_cmd yq; then
    command -v yq
    return 0
  fi
  return 1
}

cmd_ensure(){
  ensure_dir
  local yq_bin
  if ! yq_bin="$(resolved_yq)"; then
    die "mikefarah/yq nicht gefunden. Lege ein v${REQ_MAJOR}.x-Binary unter ${YQ_LOCAL} ab oder installiere es systemweit."
  fi
  local v
  if ! v="$("${yq_bin}" --version 2>/dev/null | sed -E 's/^yq .* version v?//')"; then
    die "konnte yq-Version nicht ermitteln"
  fi
  if ! version_ok "${v}"; then
    die "yq v${REQ_MAJOR}.x erforderlich, gefunden: ${v}"
  fi
  if [[ "${yq_bin}" != "${YQ_LOCAL}" && ! -e "${YQ_LOCAL}" ]]; then
    ln -s -- "${yq_bin}" "${YQ_LOCAL}" || true
  fi
  log "OK: yq ${v} verfügbar"
}

case "${1:-ensure}" in
  ensure)
    shift
    cmd_ensure "$@"
    ;;
  *)
    die "usage: $0 ensure"
    ;;
esac
