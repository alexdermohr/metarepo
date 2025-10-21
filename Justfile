set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# --- Aliase -------------------------------------------------------------------
alias wgx := _wgx
alias yq  := _yq

# --- Tasks --------------------------------------------------------------------
# Tooling guards
yq_ensure:
    just _yq ensure

# Fleet-Kommandos
list:
    just _wgx list

up:
    just _wgx up

run target="smoke":
    just _wgx run {{target}}

doctor:
    just _wgx doctor

wgx_validate:
    just _wgx validate

smoke:
    just _wgx smoke

sync:
    scripts/sync-templates.sh

log-sync *args:
    scripts/create-sync-log.py {{args}}

# Local CI
validate: yq_ensure
    .github/workflows/validate-local.sh

ci:
    just validate

linkcheck:
    docker run --rm -v $PWD:/work ghcr.io/lycheeverse/lychee:v0.14.3 \
      --config /work/.lychee.toml

e2e-dry:
    set -a; [ -f scripts/e2e/.env ] && . scripts/e2e/.env || true; set +a
    DRY_RUN=1 bash scripts/e2e/run_aussen_to_heimlern.sh

e2e:
    set -a; [ -f scripts/e2e/.env ] && . scripts/e2e/.env || true; set +a
    DRY_RUN=0 bash scripts/e2e/run_aussen_to_heimlern.sh
    bash scripts/e2e/report.sh

e2e-report:
    bash scripts/e2e/report.sh

# --- Interne Rezepte ----------------------------------------------------------
_wgx *args:
    @scripts/wgx {{args}}

_yq *args:
    @scripts/tools/yq-pin.sh {{args}}
