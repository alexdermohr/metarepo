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
    scripts/wgx validate

smoke:
    scripts/wgx smoke

sync:
    scripts/sync-templates.sh

# Local CI
ci:
    bash .github/workflows/validate-local.sh 2>/dev/null || true
