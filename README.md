![WGX](https://img.shields.io/badge/wgx-enabled-blue)

# metarepo

**Docs:** siehe [docs/README.md](docs/README.md) · WGX-Master-Doku: https://github.com/heimgewebe/wgx

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

## Quickstart
1. `just list` – Repos anzeigen
2. `just up` – Templates in alle Repos spiegeln
3. `just smoke` – Fleet-Healthcheck (read-only Checks)
4. `just validate` – prüft Template-Konsistenz

### Sync-Run-Logs pflegen
- `just log-sync` – legt auf Basis von `reports/sync-logs/_TEMPLATE.sync-run.md` einen neuen Report mit aktuellem Datum an. Optional: zusätzliche Flags (z. B. `--repo-scope "repos.yml (static)"`).
- Reports landen in [`reports/sync-logs/`](reports/sync-logs/) und dokumentieren Blocker & Folgemaßnahmen rund um Flottenläufe.

> Für Dummies: Dieses Repo ist die Schaltzentrale. Hier pflegst du Regeln und Vorlagen **einmal** und verteilst sie dann in alle anderen Repos. So vermeidest du Doppelpflege und Chaos.

## Codex Playbook (Kurz)
1) Pull-Lernen:   ./scripts/sync-templates.sh --pull-from <repo> --pattern "templates/docs/**"
2) Drift-Report:  ./scripts/wgx-doctor --repo <repo>
3) Push-Kanon:    ./scripts/sync-templates.sh --push-to <repo> --pattern "templates/.wgx/profile.yml"
Tip: --dry-run für sichere Vorschau; Repos-Liste: repos.yml & --repos-from
