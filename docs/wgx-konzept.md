# WGX – Master-Konzept

WGX = dünner Meta-Layer über alle Repos.
Priorität der Envs: Devcontainer → Devbox → mise/direnv → Termux.

**Default-Kommandos** (fleet-weit): `wgx up | list | run | doctor | validate | smoke`

**Verteilung**: Diese Datei wird als Referenz in Subrepos gespiegelt (`templates/docs/wgx-konzept.md`).
Änderungen hier -> `just up` -> Subrepos erhalten Updates.

Siehe auch `.wgx/profile.yml` für repo-lokale Profile.
