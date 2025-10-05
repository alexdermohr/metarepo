# Templates verteilen & driftfrei halten

Alle Fleet-Vorlagen leben unter `templates/**`. Sie werden 1:1 in Sub-Repos gespiegelt
(`scripts/wgx up` oder `scripts/sync-templates.sh`).

## Ordnerstruktur
- `templates/.github/workflows/` – Reusable- und Fleet-Workflows (`wgx-guard`, `wgx-smoke`, `reusable-ci`).
- `templates/.wgx/profile.yml` – Standardprofil für WGX.
- `templates/docs/**` – Referenzdokumente (z. B. `wgx-konzept.md`, ADR-Template).
- `templates/Justfile` – Fleet-Justfile mit `just up|validate|smoke`.

## Sync-Strategien
- **Voll-Sync**: `just up` bzw. `./scripts/wgx up` kopiert sämtliche Templates in jedes Repo.
- **Selektiv**: `scripts/sync-templates.sh --push-to <repo> --pattern "templates/.github/workflows/*.yml"`.
- **Pull-Lernen**: `scripts/sync-templates.sh --pull-from <repo> --pattern "templates/docs/**"` holt Verbesserungen zurück ins metarepo.

Setze immer `--dry-run`, wenn du neue Muster ausprobierst.

## Drift-Kontrolle
1. `./scripts/wgx-doctor --repo <repo>` erzeugt einen Drift-Report in `reports/`.
2. Prüfe Differenzen; entscheide, ob lokale Änderungen kuratiert (→ Pull) oder überschrieben (→ Push) werden.
3. Dokumentiere das Ergebnis im PR (Wer gewinnt? Warum?).

## Konflikte lösen
- Konflikte entstehen, wenn Sub-Repos die Templates anpassen.
- Nutze Pull-Lernen, um Verbesserungen zurückzuholen.
- Bei harten Abweichungen neue Fleet-Regel definieren (z. B. repo-spezifische Ausnahme im Ziel-Repo dokumentieren).

> 🔗 Deep-Dive zu WGX-spezifischen Settings siehe [WGX-Doku](https://github.com/alexdermohr/wgx).
