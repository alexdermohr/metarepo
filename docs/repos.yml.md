# `repos.yml` – Inventar & Filter

`repos.yml` definiert, welche Repositories vom metarepo als Teil der Fleet behandelt werden.
Das File wird von `scripts/wgx` und `scripts/sync-templates.sh --repos-from` gelesen.

## Schema
```yaml
# Modus: "static" (nur Liste) oder "github" (per GitHub-API ermitteln)
mode: static

# GitHub-Owner/Organisation der Fleet
github:
  owner: alexdermohr

# Statische Fleet-Liste (genutzt, wenn mode: static)
repos:
  - weltgewebe
  - hauski-audio

static:
  include:
    - semantAH
    - wgx
```

### Felder
- `mode`
  - `static` (Default): Fleet-Liste kommt aus `repos` + `static.include`.
  - `github`: Fleet wird dynamisch über `gh repo list <owner>` bestimmt.
- `github.owner`: GitHub Namespace. Wird auch von `scripts/sync-templates.sh --owner-from-env` genutzt.
- `repos`: Kernmenge der Repositories. Kommentare (`# ...`) werden ignoriert.
- `static.include`: Ergänzende Repos, z. B. wenn `repos` leer bleiben soll.

## Standard-Policy
- Fleet umfasst alle **öffentlichen** Repos unter `alexdermohr`.
- Ausnahme: `vault-gewebe` bleibt aus Datenschutzgründen ausgeschlossen.

## Praxis-Tipps
- Für einmalige Pushes `scripts/sync-templates.sh --repos-from repos.yml --pattern "templates/.github/workflows/*.yml"`.
- Bei `mode: github` regelmäßig `gh auth status` prüfen (Token für `gh repo list`).
- Änderungen an `repos.yml` immer mit PR begründen (z. B. neues Repo aufgenommen / stillgelegt).
