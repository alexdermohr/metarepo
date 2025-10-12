# Leitlinien · Heimgewebe

## Daten & Formate
- JSONL ist **append-only**: jede Zeile genau ein JSON-Objekt, UTF-8.
- Producer validieren ihre Artefakte gegen Schemas aus `metarepo/contracts/*.schema.json`.
- „Editierbare Wahrheit“: Vault & Code (Dateien + Git).  
  Abgeleitetes (Indizes/Insights) ist rebuildbar.  
  Gerätestate (SQLite) wird **nicht** zwischen Geräten gesynct.

## Events & Schemas (Contracts v1)
- `aussensensor/weltgewebe` → `aussen.event.schema.json`  
- `semantAH` → `insights.schema.json`  
- `wgx` → `metrics.snapshot.schema.json`  
- `hausKI` JSONL-Log → `event.line.schema.json`  
- `heimlern` Decisions → `policy.decision.schema.json`

## Security
- Ingest-Endpunkte lokal; optional Shared-Secret via Header `x-auth`.
- Keine Secrets ins Repo; `.env`/Tokens nur lokal bzw. als CI-Secret.

## Ports & Endpunkte
- **leitstand**: `POST /ingest/{domain}` → `data/{domain}.jsonl`  
- Domains: `aussen`, `pc`, `musik`, `heute`, …

## CI
- Schema-Checks via reusable Workflow `contracts-validate` (AJV).
- Producer pushen kleine Beispielartefakte, die in CI validiert werden.

## Mantras
- **Dateien & Code** syncen, **State nie**.  
- **Events immer** (append-only, deterministisch mergen).  
- **Explainability:** Entscheidungen tragen ein `why`.
