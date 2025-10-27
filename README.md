![WGX](https://img.shields.io/badge/wgx-enabled-blue)
[![Docs link check](https://github.com/heimgewebe/metarepo/actions/workflows/linkcheck.yml/badge.svg)](https://github.com/heimgewebe/metarepo/actions/workflows/linkcheck.yml)

# metarepo

**Docs:** siehe [Kernkonzepte](docs/konzept-kern.md) · [WGX-Kommandos](docs/wgx-konzept.md) · [Fleet-Gesamtbild](docs/heimgewebe-gesamt.md) · Systemdiagramm: [docs/system-overview.mmd](docs/system-overview.mmd) · Canvas: [docs/canvas/](docs/canvas)

Zentrale Steuerzentrale (Meta-Layer) für alle Repos von **heimgewebe**.
Enthält:
- **WGX-Master**: Referenzdoku + `.wgx/profile.yml`-Template
- **Fleet-Orchestrierung**: `scripts/wgx` (up | list | run | doctor | validate | smoke)
- **Templates** zum Spiegeln in Subrepos: `templates/**`
- **CI**: wiederverwendbare Workflows + Template-Validator
- 👉 Siehe auch: [docs/repo-matrix.md](docs/repo-matrix.md) (Rollen & Zustände)
  sowie [docs/contract-versioning.md](docs/contract-versioning.md) (Schema-Tags, Deprecations).

> Hinweis: Der `/ask`-Server begrenzt den Parameter `k` serverseitig auf ≤100.
> Secrets für den Heavy-Workflow: `ASK_ENDPOINT_URL` z. B. `https://host/ask?q=hi&k=3&ns=default`, `METRICS_SNAPSHOT_URL` z. B. `https://host/metrics`.

## Repos (Quelle)
Siehe `repos.yml`. Standard: alle öffentlichen Repos unter `heimgewebe`, **außer** `vault-gewebe` (privat bei `alexdermohr`).

## Voraussetzungen
- **`just`**: Dieses Projekt verwendet `just` als Befehlsausführer. Installiere es auf deinem System. Für Debian/Ubuntu kannst du `sudo apt-get install just` verwenden. Für andere Systeme beachte die [offizielle `just`-Dokumentation](https://github.com/casey/just).
- **`yq`**: Die Projektskripte laden automatisch eine bestimmte Version von `yq` (`mikefarah/yq`) herunter und verwenden diese. Du musst es nicht systemweit installieren. Solltest du eine inkompatible `yq`-Version in deinem System-PATH haben, werden die Skripte dies korrekt handhaben und die lokale Version priorisieren.

## Quickstart
1. `just list` – Repos anzeigen
2. `just up` – Templates in alle Repos spiegeln
3. `just smoke` – Fleet-Healthcheck (read-only Checks)
4. `just wgx:validate` – prüft Template-Konsistenz via WGX
5. `just validate` – lokale Validierung (z. B. YAML via mikefarah/yq v4)

## Devcontainer
Siehe [.devcontainer/README.md](.devcontainer/README.md) für die Docker-Socket- und Docker-in-Docker-Varianten. Wähle die gewünschte Variante via `just devcontainer:socket` bzw. `just devcontainer:dind` oder synchronisiere Pins mit `just devcontainer:sync`.

```bash
# Pins aktualisieren und Socket-Variante setzen
just devcontainer:sync
just devcontainer:socket
```

## Contracts (Kurz)
Zentrale Schemas und Reusables liegen im metarepo und werden über Tags (z. B. `contracts-v1`) konsumiert. Details: [docs/contracts/index.md](docs/contracts/index.md)

| Contract | Producer | Consumer |
| --- | --- | --- |
| `aussen.event` | aussensensor, (optional) weltgewebe | leitstand |
| `metrics.snapshot` | wgx | hausKI, leitstand |
| `insights` | semantAH | hausKI, leitstand |
| `audio.events` | hausKI-audio | hausKI, leitstand |
| `policy.decision` | heimlern | hausKI |
| `event.line` | hausKI | leitstand |

## Org-Übersicht
Aktuelle Übersicht:
- **Index:** [docs/org-index.md](docs/org-index.md)
- **Graph:** rendere `docs/org-graph.mmd` z. B. in Obsidian/VS Code (Mermaid).

## Dokumentation & Links
- [Docs-Index](docs/README.md) – thematische Übersicht aller Metarepo-Dokumente
- [Systemübersicht](docs/system-overview.md) – Repos, Verantwortlichkeiten & Einstiegspunkte
- [Architektur](docs/architecture.md) – Komponenten, Datenflüsse & Diagramme
- [Use-Cases](docs/use-cases.md) – Schritt-für-Schritt-Beispiele für typische Aufgaben
- [Automatisierung & CI](docs/automation.md) – Just-Targets, WGX-Kommandos & Workflows
- [Umgebung & Secrets](docs/environment.md) – lokale Konfiguration, Tokens & .env-Hinweise
- [Troubleshooting & FAQ](docs/troubleshooting.md) – häufige Probleme & Fixes
- [Events & Contracts](docs/contracts/index.md) – Schemas, Referenzen & Versionierung
- [End-to-End-Läufe](docs/e2e.md) – automatisierte Kette `aussensensor → leitstand → heimlern`

## End-to-End
Siehe [docs/e2e.md](docs/e2e.md) für den automatisierten Lauf `aussensensor → leitstand → heimlern`.

### WGX-Extras
- `./scripts/wgx plan` – Offline-Vorschau, welche Dateien aus `templates/` in jedes Repo gespiegelt würden.
- `PLAN_LIMIT=0 ./scripts/wgx plan` – zeigt alle Dateien pro Repo (Standard 10).
- `WGX_OWNER=org ./scripts/wgx plan` – Owner/Org überschreiben, falls `repos.yml` keine Angabe enthält.

### Sync-Run-Logs pflegen
- `just log-sync` – legt auf Basis von `reports/sync-logs/_TEMPLATE.sync-run.md` einen neuen Report mit aktuellem Datum an. Optional: zusätzliche Flags (z. B. `--repo-scope "repos.yml (static)"`).
- Reports landen in [`reports/sync-logs/`](reports/sync-logs/) und dokumentieren Blocker & Folgemaßnahmen rund um Flottenläufe.

> Für Dummies: Dieses Repo ist die Schaltzentrale. Hier pflegst du Regeln und Vorlagen **einmal** und verteilst sie dann in alle anderen Repos. So vermeidest du Doppelpflege und Chaos.

## Codex Playbook (Kurz)
1) Pull-Lernen:   ./scripts/sync-templates.sh --pull-from <repo> --pattern "templates/docs/**"
2) Drift-Report:  ./scripts/wgx-doctor --repo <repo>
3) Push-Kanon:    ./scripts/sync-templates.sh --push-to <repo> --pattern "templates/.wgx/profile.yml"
Tip: --dry-run für sichere Vorschau; Repos-Liste: repos.yml & --repos-from
