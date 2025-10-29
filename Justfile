set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# --- Devcontainer integration (auto-imported) ---
# erlaubt z. B.:
#   just devcontainer:sync
#   just devcontainer:socket
#   just devcontainer:dind
#   just devcontainer:which
if (import_path := ".devcontainer/justfile") != "" && path_exists(import_path)
    import import_path
end
# --- Meta ---------------------------------------------------------------------
default: help

help:
    @printf "Metarepo Justfile – häufige Kommandos:\n"
    @printf "  just deps          # Tooling & Pins via uv sync --frozen\n"
    @printf "  just list          # WGX-Liste aller angebundenen Repos\n"
    @printf "  just up            # Templates synchronisieren (wgx up)\n"
    @printf "  just validate      # Lokale Checks (Linting, Format, yq)\n"
    @printf "  just smoke         # Schneller Fleet-Integrationslauf\n"
    @printf "  just log-sync      # Report-Vorlage unter reports/sync-logs/\n"
    @printf "\nWeitere Ziele: just --list\n"

# --- Aliase -------------------------------------------------------------------
alias wgx := _wgx
alias yq  := _yq

# --- Org Assets ---------------------------------------------------------------
deps:
    uv sync --frozen

org-index:
    uv run scripts/generate_org_assets.py --repos-file repos.yml --index docs/org-index.md

org-graph:
    uv run scripts/generate_org_assets.py --repos-file repos.yml --graph docs/org-graph.mmd

linkcheck:
    docker run --rm -v $PWD:/work ghcr.io/lycheeverse/lychee:v0.14.3 \
      --config /work/.lychee.toml

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

# --- Fleet Push (Wave-1: agent-kit + contracts) --------------------------------
# Voraussetzungen:
#  - GitHub CLI (`gh`) mit Push-Rechten
#  - Python 3.11+
#  - templates/agent-kit/** vorhanden
#  - contracts/agent.tool.schema.json vorhanden

# Push für einzelnes Repo
fleet.push repo?="":
    @python3 scripts/fleet/push_template.py \
      --repo "{{repo}}" \
      --paths "templates/agent-kit" "contracts" \
      --message "feat: adopt agent-kit + contracts (wave 1)"

# Trockenlauf für einzelnes Repo
fleet.push-dry repo?="":
    @python3 scripts/fleet/push_template.py \
      --repo "{{repo}}" \
      --paths "templates/agent-kit" "contracts" \
      --message "feat: adopt agent-kit + contracts (wave 1)" \
      --dry-run

# Push für alle Repos aus fleet/repos.yml
fleet.push-all:
    @python3 scripts/fleet/push_template.py \
      --paths "templates/agent-kit" "contracts" \
      --message "feat: adopt agent-kit + contracts (wave 1)"

# Local CI
validate: yq_ensure
    .github/workflows/validate-local.sh

ci:
    just validate

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
