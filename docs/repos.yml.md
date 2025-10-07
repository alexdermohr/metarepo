# `repos.yml` – Inventar & Filter

`repos.yml` definiert, welche Repositories vom metarepo als Teil der Fleet behandelt werden.
Das File wird von `scripts/wgx` und `scripts/sync-templates.sh --repos-from` gelesen.

## Schema
```yaml
# Modus: "static" (nur Liste) oder "github" (per GitHub-API ermitteln)
mode: static

# GitHub-Owner/Organisation der Fleet
github:
  owner: heimgewebe

# Statische Fleet-Liste (genutzt, wenn mode: static)
repos:
  - name: weltgewebe
    url: https://github.com/heimgewebe/weltgewebe
    default_branch: main
  - name: hauski
    url: https://github.com/heimgewebe/hausKI
    default_branch: main
  - name: hauski-audio
    url: https://github.com/heimgewebe/hauski-audio
    default_branch: main
    depends_on:
      - hauski

static:
  include:
    - name: semantAH
      url: https://github.com/heimgewebe/semantAH
      default_branch: main
    - name: wgx
      url: https://github.com/heimgewebe/wgx
      default_branch: main
```

### Felder
- `mode`
  - `static` (Default): Fleet-Liste kommt aus `repos` + `static.include`.
  - `github`: Fleet wird dynamisch über `gh repo list <owner>` bestimmt.
- `github.owner`: GitHub Namespace. Wird auch von `scripts/sync-templates.sh --owner-from-env` genutzt.
- `repos`: Kernmenge der Repositories. Jeder Eintrag besitzt mindestens das Feld `name`, optional `url`, `default_branch` und `depends_on`.
- `static.include`: Ergänzende Repos, z. B. wenn `repos` leer bleiben soll. Aufbau identisch zu `repos`.

## Standard-Policy
- Fleet umfasst alle **öffentlichen** Repos unter `heimgewebe`.
- Ausnahme: `vault-gewebe` bleibt aus Datenschutzgründen ausgeschlossen (liegt weiter bei `alexdermohr`).

## Praxis-Tipps
- Für einmalige Pushes `scripts/sync-templates.sh --repos-from repos.yml --pattern "templates/.github/workflows/*.yml"`.
- Bei `mode: github` regelmäßig `gh auth status` prüfen (Token für `gh repo list`).
- Änderungen an `repos.yml` immer mit PR begründen (z. B. neues Repo aufgenommen / stillgelegt).
