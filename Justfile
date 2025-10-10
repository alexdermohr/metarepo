set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Fleet-Kommandos
list:
    scripts/wgx list

up:
    scripts/wgx up

run target="smoke":
    scripts/wgx run {{target}}

doctor:
    scripts/wgx doctor

validate:
    scripts/validate-local.sh

smoke:
    scripts/wgx smoke

sync:
    scripts/sync-templates.sh

log-sync *args:
    scripts/create-sync-log.py {{args}}

# Local CI
ci:
    scripts/validate-local.sh
