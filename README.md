![WGX](https://img.shields.io/badge/wgx-enabled-blue)

# metarepo

Zentrale Steuerzentrale (Meta-Layer) für alle Repos von **alexdermohr**.
Enthält:
- **WGX-Master**: Referenzdoku + `.wgx/profile.yml`-Template
- **Fleet-Orchestrierung**: `scripts/wgx` (up | list | run | doctor | validate | smoke)
- **Templates** zum Spiegeln in Subrepos: `templates/**`
- **CI**: wiederverwendbare Workflows + Template-Validator

## Repos (Quelle)
Siehe `repos.yml`. Standard: alle öffentlichen Repos unter `alexdermohr`, **außer** `vault-gewebe` (privat).

## Quickstart
1. `just list` – Repos anzeigen  
2. `just up` – Templates in alle Repos spiegeln  
3. `just smoke` – Fleet-Healthcheck (read-only Checks)  
4. `just validate` – prüft Template-Konsistenz

> Für Dummies: Dieses Repo ist die Schaltzentrale. Hier pflegst du Regeln und Vorlagen **einmal** und verteilst sie dann in alle anderen Repos. So vermeidest du Doppelpflege und Chaos.
