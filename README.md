![WGX](https://img.shields.io/badge/wgx-enabled-blue)

# metarepo

**Docs:** siehe [docs/README.md](docs/README.md) · [Fleet-Overview](docs/overview.md) · [Fleet-Gesamtbild](docs/heimgewebe-gesamt.md) · Canvas: [docs/canvas/](docs/canvas) · WGX-Master-Doku: https://github.com/heimgewebe/wgx

Zentrale Steuerzentrale (Meta-Layer) für alle Repos von **heimgewebe**.
Enthält:
- **WGX-Master**: Referenzdoku + `.wgx/profile.yml`-Template
- **Fleet-Orchestrierung**: `scripts/wgx` (up | list | run | doctor | validate | smoke)
- **Templates** zum Spiegeln in Subrepos: `templates/**`
- **CI**: wiederverwendbare Workflows + Template-Validator

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
