#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log(){ printf "[validate] %s\n" "$*" >&2; }
die(){ log "ERR: $*"; exit 1; }

# --- Requirements (no auto-install here!) ---
need(){ command -v "$1" >/dev/null 2>&1 || die "Fehlt: $1"; }
need yq   # erwartet mikefarah yq v4
need git

# Prüfen, ob es wirklich mikefarah/yq v4 ist
if ! yq --version 2>/dev/null | grep -Eq 'yq.*version v?[4-9]\.'; then
  die "yq v4+ (mikefarah) nötig. Install-Hinweis: https://github.com/mikefarah/yq#install"
fi

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

log "YAML-Syntax prüfen…"
# Alle YAML-Dateien (Tracked) parsen; yq e 'true' validiert nur
if ! git ls-files -z -- '*.yml' '*.yaml' | xargs -0 -r -I{} yq e 'true' "{}" >/dev/null; then
  die "YAML-Validierung fehlgeschlagen."
fi

# Optional: template-Ordner gesondert listen (nur Info)
if [[ -d templates ]]; then
  log "Templates inventarisieren…"
  git ls-files templates -z -- '*.yml' '*.yaml' \
    | xargs -0 -r -I{} sh -c 'printf " - %s\n" "{}"' >&2 || true
fi

log "Validation complete."