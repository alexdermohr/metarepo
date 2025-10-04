#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar nullglob

red(){ printf "\e[31m%s\e[0m\n" "$*"; }
green(){ printf "\e[32m%s\e[0m\n" "$*"; }
yellow(){ printf "\e[33m%s\e[0m\n" "$*"; }

usage(){
  cat <<USG
Usage:
  $0 --pull-from <repo-name> --pattern "<glob>" [--pattern "..."] [--dry-run]
  $0 --push-to   <repo-name> --pattern "<glob>" [--pattern "..."] [--dry-run]
  $0 --repos-from <file> --pattern "<glob>" [--pattern "..."] [--dry-run]

Patterns sind relativ zu den Template-Roots:
  - templates/.github/workflows/*.yml
  - templates/Justfile
  - templates/docs/**
  - templates/.wgx/profile.yml
USG
}

REPO_FROM=""; REPO_TO=""
REPOS_FROM_FILE=""
PATTERNS=()
OWNER="${GITHUB_OWNER:-alexdermohr}"
CUSTOM_OWNER_SET=0
DRYRUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pull-from) REPO_FROM="$2"; shift 2 ;;
    --push-to)   REPO_TO="$2"; shift 2 ;;
    --repos-from) REPOS_FROM_FILE="$2"; shift 2 ;;
    --pattern)   PATTERNS+=("$2"); shift 2 ;;
    --owner)     OWNER="$2"; CUSTOM_OWNER_SET=1; shift 2 ;;
    --owner-from-env) OWNER="${GITHUB_OWNER:?Missing GITHUB_OWNER}"; CUSTOM_OWNER_SET=1; shift ;;
    --dry-run)   DRYRUN=1; shift ;;
    -h|--help)   usage; exit 0 ;;
    *) yellow "Ignoriere unbekanntes Argument: $1"; shift ;;
  esac
done

if [[ -n "$REPO_FROM" && ( -n "$REPO_TO" || -n "$REPOS_FROM_FILE" ) ]]; then
  red "Fehler: --pull-from nicht mit --push-to/--repos-from kombinieren."; exit 1
fi

if [[ -z "$REPO_FROM" && -z "$REPO_TO" && -z "$REPOS_FROM_FILE" ]]; then
  red "Fehler: --pull-from, --push-to oder --repos-from angeben."; usage; exit 1
fi

if [[ ${#PATTERNS[@]} -eq 0 ]]; then
  PATTERNS=("templates/.github/workflows/*.yml" "templates/Justfile" "templates/docs/**" "templates/.wgx/profile.yml")
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

clone_repo(){
  local name="$1"
  local url="https://github.com/${OWNER}/${name}.git"
  rm -rf "$TMPDIR/$name"
  git -c advice.detachedHead=false clone --depth=1 "$url" "$TMPDIR/$name" >/dev/null 2>&1 || {
    red "Clone fehlgeschlagen: $url"; exit 1; }
}

copy_into_metarepo_from_repo(){
  local name="$1"
  for p in "${PATTERNS[@]}"; do
    case "$p" in
      templates/*) src="${p#templates/}" ;;
      *) src="$p" ;;
    esac
    files=( "$TMPDIR/$name"/${src} )
    for f in "${files[@]}"; do
      # Remove TMPDIR/$name/ prefix for destination path
      rel_f="${f#$TMPDIR/$name/}"
      [[ -z "$rel_f" || "$rel_f" == "$f" ]] && continue
      dest="$PWD/templates/$rel_f"
      if ((DRYRUN==1)); then
        echo "↑ (dry-run) Pull: $name :: $rel_f → templates/$rel_f"
        continue
      fi
      mkdir -p "$(dirname "$dest")"
      cp -a "$f" "$dest"
      git add "templates/$rel_f" || true
      echo "↑ Pull: $name :: $rel_f → templates/$rel_f"
    done
  done
}

copy_from_metarepo_into_repo(){
  local name="$1"
  for p in "${PATTERNS[@]}"; do
    case "$p" in
      templates/*) src="$p" ;;
      *) src="$p" ;;
    esac
    mapfile -t files < <(compgen -G -- "$src")
    for f in "${files[@]}"; do
      [[ -z "$f" ]] && continue
      rel="${f#templates/}"
      [[ "$f" == "$rel" ]] && { yellow "Überspringe Nicht-Template: $f"; continue; }
      if ((DRYRUN==1)); then
        echo "↓ (dry-run) Push: templates/$rel → $name::$rel"
        continue
      fi
      mkdir -p "$TMPDIR/$name/$(dirname "$rel")"
      cp -a "$f" "$TMPDIR/$name/$rel"
      echo "↓ Push: templates/$rel → $name::$rel"
    done
  done
  (
    cd "$TMPDIR/$name"
    if ! git diff --quiet; then
      if ((DRYRUN==1)); then
        echo "DRY-RUN: Änderungen erkannt für $name (kein Commit erstellt)."
      else
        git config user.email "codex-bot@local"
        git config user.name "Codex Bot"
        git checkout -b chore/template-sync || true
        git add .
        git commit -m "chore(templates): sync from metarepo" || true
        echo "Lokaler Commit erstellt. Bitte PR manuell auf GitHub öffnen."
      fi
    else
      echo "Keine Änderungen für $name."
    fi
  )
}

sync_repos_from_file(){
  local file="$1"
  [[ -f "$file" ]] || { red "Repos-Datei nicht gefunden: $file"; exit 1; }
  mapfile -t REPOS < <(
    awk '
      /^[[:space:]]*#/ {next}
      /^[[:space:]]*repos:/ {section="repos"; next}
      /^[[:space:]]*static:/ {section="static"; next}
      /^[[:space:]]*include:/ {section=section ".include"; next}
      /^[[:space:]]*exclude:/ {section=section ".exclude"; next}
      /^[[:space:]]*[A-Za-z0-9_-]+:/ {section=$1; gsub(":$","",section); next}
      /^[[:space:]]*-/ {
        item=$0
        sub(/^[[:space:]]*-[[:space:]]*/,"",item)
        sub(/[[:space:]]+#.*/,"",item)
        if (item=="") next
        if (section=="repos" || section=="static.include") print item
      }
    ' "$file"
  )
  if [[ ${#REPOS[@]} -eq 0 ]]; then
    yellow "Keine Repos in $file gefunden (erwartet unter repos: oder static.include)."
    exit 1
  fi
  for repo in "${REPOS[@]}"; do
    [[ -z "$repo" ]] && continue
    echo "== Sync to $repo =="
    clone_repo "$repo"
    copy_from_metarepo_into_repo "$repo"
  done
}

if [[ -n "$REPO_FROM" ]]; then
  clone_repo "$REPO_FROM"
  copy_into_metarepo_from_repo "$REPO_FROM"
  echo "Empfehlung: git commit -m \"chore(templates): pull from $REPO_FROM\""
  exit 0
fi

if [[ -n "$REPOS_FROM_FILE" ]]; then
  sync_repos_from_file "$REPOS_FROM_FILE"
  exit 0
fi

if [[ -n "$REPO_TO" ]]; then
  clone_repo "$REPO_TO"
  copy_from_metarepo_into_repo "$REPO_TO"
  echo "Hinweis: PR für $REPO_TO auf GitHub erstellen (chore/template-sync)."
  exit 0
fi
