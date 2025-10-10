set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

alias wgx := "scripts/wgx"
alias yq := "scripts/tools/yq-pin.sh"

# Tooling guards
yq:ensure:
    {{yq}} ensure

# Fleet-Kommandos
list:
    {{wgx}} list

up:
    {{wgx}} up

run target="smoke":
    {{wgx}} run {{target}}

doctor:
    {{wgx}} doctor

wgx:validate:
    {{wgx}} validate

smoke:
    {{wgx}} smoke

sync:
    scripts/sync-templates.sh

log-sync *args:
    scripts/create-sync-log.py {{args}}

# Local CI
validate: yq:ensure
    .github/workflows/validate-local.sh

ci:
    just validate
