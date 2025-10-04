#!/usr/bin/env bash
set -euo pipefail
# lokal: sanity-check (z.B. fehlende Dateien, yaml lint)
command -v yq >/dev/null || { echo "yq fehlt"; exit 1; }
find templates -type f -maxdepth 3 -print
echo "Templates ok (oberflächlich geprüft)."
