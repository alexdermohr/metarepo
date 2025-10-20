# Repo-Matrix (Rolle • Status • Schnittstellen)
- **metarepo**: Control-Plane (Templates, Reusables, Contracts) — Status: stabil
- **wgx**: Orchestrator (CLI) — Status: aktiv
- **hauski**: KI-Orchestrator (Rust, GPU, Offline) — Status: aktiv
- **hauski-audio**: Audio-Pipeline — Status: MVP
- **semantAH**: Semantik & Graph — Status: Aufbau
- **leitstand**: HTTP-Ingest (JSONL) — Status: stabil
- **aussensensor**: Feeds → Leitstand — Status: aktiv (Daemon geplant)
- **heimlern**: Policies/Bandit — Status: Experiment
- **weltgewebe**: Web (docs-first, Gates) — Status: Docs-only
- **tools**: Hilfsskripte — Status: aktiv
- **vault-gewebe**: Obsidian Vault — Status: kuratiert

## Schnittstellenverträge (Auswahl)
- Aussen-Events (JSONL): `contracts/aussen.event.schema.json` (Tag: `contracts-v1`)
- Semantics: `contracts/semantics/*.schema.json` (WIP)
- Policy-Snapshot: `contracts/policy_snapshot.schema.json` (geplant)

