# CI-Reusables aus dem metarepo

Das metarepo stellt wiederverwendbare GitHub-Actions-Workflows bereit,
die Sub-Repos direkt referenzieren. Sie bilden die Fleet-Standards ab und
verweisen bei Bedarf auf die WGX-Engine im [WGX-Repository](https://github.com/heimgewebe/wgx).

## Verfügbare Workflows (`templates/.github/workflows/`)
- `wgx-guard.yml` – überprüft das Vorhandensein des WGX-Profils (`.wgx/profile.yml`).
- `wgx-smoke.yml` – ruft den `reusable-ci`-Workflow mit Standard-Inputs auf (Lint ja, Tests nein).
- `reusable-ci.yml` – generischer CI-Baustein mit optionalen Lint- und Test-Schritten (`just`).

## Konsum in Sub-Repos
```yaml
# .github/workflows/wgx-guard.yml im Ziel-Repo
name: WGX Guard
on:
  push:
    branches: [main]
  pull_request:

jobs:
  guard:
    uses: heimgewebe/metarepo/.github/workflows/wgx-guard.yml@main
```

Zusätzliche Beispiel-Einbindung für den Smoke-Workflow:

```yaml
jobs:
  smoke:
    uses: heimgewebe/metarepo/.github/workflows/wgx-smoke.yml@main
    with:
      run_tests: true
```
- Verwende immer einen **festen Ref**. Für reproduzierbare Builds **Tag oder Commit-SHA** pinnen.
  - Beispiel Tag: `@metarepo-ci-v20251005`
  - Beispiel Commit: `@d34db33f5e7c0de...`
- `reusable-ci.yml` akzeptiert `run_lint`/`run_tests` (Booleans). Weitere Inputs bei Bedarf ergänzen.

## Versionierung & Pinning
- `main` spiegelt den aktuellen Fleet-Kanon.
- Für reproduzierbare Pipelines Tags nutzen (`git tag metarepo-ci-vYYYYMMDD`), dann `@metarepo-ci-vYYYYMMDD` referenzieren.
- Funktionale Änderungen (z. B. echte WGX-Checks) entstehen im WGX-Repo und werden hier nur verlinkt.

## Caching-Hinweise
- Lint/Test-Schritte basieren auf `just`. Stelle sicher, dass das Ziel-Repo entsprechende Rezepte anbietet.
- Weitere Tools (z. B. `wgx`, `uv`, `lychee`) werden bei Bedarf projektindividuell installiert; dokumentiere Anpassungen im PR.
