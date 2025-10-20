# Contracts: Versionierung & Deprecations
- **Tagging:** Stabile Schemas werden via Branch/Tag `contracts-v1` referenziert.
- **Verwendung:** Downstream-Workflows pinnen auf `@contracts-v1`.
- **Deprecation-Fenster:** v1 bleibt mindestens bis 2026-03 gültig; Breaking-Änderungen → v2.
- **Validierung:** Reusable-Workflow `reusable-validate-jsonl.yml` aus diesem Repo.

## Beispiele (Pinning)
- `uses: heimgewebe/metarepo/.github/workflows/reusable-validate-jsonl.yml@contracts-v1`
