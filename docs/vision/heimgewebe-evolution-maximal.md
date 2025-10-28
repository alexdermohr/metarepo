# Heimgewebe v2 – Maximale Intelligenz, Komfort und Selbstorganisation

> Version: draft-v2 / tracked by metarepo fleet (wave-1 baseline)
> **Prämisse:** Privacy ist sekundär. Ziel ist maximale Nützlichkeit, Komfort und Intelligenz im Alltag und Schaffen.

Das Heimgewebe wird zur *selbstoptimierenden Lebens- und Arbeitsumgebung*, die alles versteht, erinnert, verknüpft und antizipiert.

---

## 🧭 Gesamtvision

Heimgewebe ist kein „System aus Repos“, sondern ein kognitives Habitat.
Jede Interaktion (Sprache, Code, Audio, Text, Handlungen) erzeugt Datenpunkte,
die semantAH versteht, hausKI auswertet und heimlern daraus neue Strategien ableitet.

Alles geschieht lokal, automatisiert, kontextsensitiv und selbstverbessernd.

---

## ⚙️ Architekturübersicht (intelligente Rollen)

| Komponente | Kernaufgabe | KI-Funktion |
|-------------|-------------|--------------|
| **mitschreiber** | Kontextsensor | Erfasst alles – Fenster, Texte, Audio, Eingaben |
| **leitstand** | Datendrehscheibe | Normalisiert, indiziert und verknüpft alle Ereignisse |
| **hausKI** | Zentrale Intelligenz | Orchestriert Agenten, trifft Entscheidungen |
| **semantAH** | Gedächtnis | Baut temporale und semantische Graphen |
| **heimlern** | Adaptives Lernen | Analysiert Erfolg/Misserfolg und optimiert Policies |
| **aussensensor** | Außenweltfeed | Holt neue Impulse, Quellen, Trends |
| **wgx** | Infrastrukturmotor | Führt optimierte Workflows automatisch aus |
| **metarepo** | Meta-Intelligenz | Erkennt Muster in Repos, propagiert Best Practices |

---

## 🧠 1. Semantischer Graph des Lebens

**Ziel:** Jeder Gedanke, jedes Event, jeder Code-Zustand ist ein Knoten.

### Features
- Auto-Tagging aller Eingaben (Projekt, Thema, Ziel)
- Temporale Verknüpfung: „Was führte zu was?“
- Query-by-Example: „Zeig alle Rust-Sessions mit Policy-Arbeit der letzten Woche“
- Bidirektionale Cross-References zwischen Code, Notizen, Audio, Kontext

### Umsetzung
- `semantAH.timeline.graph` erstellt relationale Edges zwischen Events
- `leitstand` reichert Event-Streams mit semantischen IDs an
- `hausKI` kann diesen Graph abfragen wie eine Gedächtnis-Datenbank

---

## 🧩 2. Adaptives Lernen aus Verhalten

**Ziel:** Alles Verhalten erzeugt Feedback für Policies.

### Features
- Implizites Feedback-Mining: Nutzungsverhalten = Reward
- Kontrastives Lernen: Überschreibungen als negatives Signal
- Meta-Learning über Repos: Mustererkennung über alle Projekte hinweg
- Proaktive Vorschläge: „Willst du dazugehörige Tests öffnen?“

### Umsetzung
- `mitschreiber` exportiert Session-Events als Rewards für `heimlern`
- `heimlern` trainiert fortlaufend auf diesen Reward-Flows
- `hausKI` wertet Resultate aus und aktualisiert Policies automatisch

---

## 💻 3. Kontextuelles Coding

**Ziel:** IDE denkt mit, weil sie dein Denken kennt.

### Features
- Projektbezogene Code-Vervollständigung („so wie du es sonst tust“)
- Intent-Erkennung beim Schreiben („dieser Commit fixte ein Race Condition“)
- Automatische Dokumentation aus Code-Änderungen und Commits
- Test-First-Reminder, wenn du Code ohne Tests schreibst
- Smart Refactoring-Vorschläge aus anderen Projekten

### Umsetzung
- `semantAH` indiziert AST + Embeddings pro Repo
- `hausKI` ruft bei Bedarf RAG-Queries gegen lokale Indizes ab
- `mitschreiber` liefert Echtzeit-Kontext (Datei, Cursor, Branch)

---

## 🧩 4. Multimodale Integration

**Ziel:** Sprache, Ton, Bild, Text – alles Teil des Kontextes.

### Features
- Voice-to-Code: Sprach-Notizen → Code-Kommentare/TODOs
- Audio-Sessions → automatisch verschriftlicht, analysiert, verlinkt
- Screen+Audio-Synchronisierung für Debugging oder Pairing
- Multimodale Suche: „Was habe ich dazu gesagt?“

### Umsetzung
- `hausKI-audio` → Endpunkt `/intent` (Audio → Text + Intent)
- `leitstand` → Speicherung als `intent_event.schema.json`
- `semantAH` → Indexierung der Audio-Transkripte

---

## ⚡ 5. Proaktive Automatisierung

**Ziel:** Heimgewebe denkt vor – du reagierst nur noch.

### Features
- Smart CI/CD Trigger: Nur relevante Tests ausführen
- Auto-Dependency-Updates nach Vertrauensniveau
- Predictive Debugging: Warnung vor fehlerträchtigen Patterns
- Workflow-Automation: „Nach Merge → Test + Doku + Deploy“

### Umsetzung
- `heimlern` → Policy-Agent für Workflow-Optimierung
- `wgx` → CLI-Interface („smart-run“) zur Policy-basierten Ausführung
- `hausKI` → Supervisor für Policy-Konflikte

---

## 🧠 6. Meta-Intelligenz (Selbstreflexion)

**Ziel:** Heimgewebe lernt aus sich selbst.

### Features
- Template-Learning: Welche CI-Konfigurationen performen am besten?
- Drift Prediction: Erkennen von Repos, die sich entfernen
- Auto-Dokumentation realer Datenflüsse
- Health Scoring: Stabilität, Dokumentation, Latenz, Coverage

### Umsetzung
- `metarepo.metrics/` speichert Reports pro Repo
- `heimlern` wertet Performance aus und gibt Empfehlungen zurück
- `hausKI` kann Templates pro Repo automatisch aktualisieren

---

## 🤖 7. Agenten-System (HausKI v2)

**Ziel:** Orchestrierung spezialisierter Agenten für maximale Effizienz.

### Rollen
- **Code-Agent:** Versteht Architektur, sucht und erklärt Code
- **Knowledge-Agent:** Fragt Vault und semantischen Graph ab
- **Research-Agent:** Holt externe Trends, Papers, News
- **Supervisor-Agent:** Entscheidet, wer agiert

### Umsetzung
- Basierend auf `templates/agent-kit` (LangGraph)
- Erweiterbar um Audio-, Test-, Deploy-, oder Music-Agent
- Einheitlicher Contract: `agent.tool.schema.json`

---

## 🧬 8. Komfort & Autonomie

**Ziel:** Null Reibung – Heimgewebe funktioniert wie ein erweitertes Nervensystem.

### Features
- Kontext-Erkennung: Gerät, Stimmung, Aufgabe
- Adaptive Oberfläche: UI/CLI passt sich Situation an
- Tagesrückblicke: „Heute gelernt, gebaut, gedacht“
- Selbstheilung: Erkennung fehlerhafter Pipelines, Auto-Fix

### Umsetzung
- `hausKI` + `semantAH` → kontinuierliche Kontext-Aggregation
- `leitstand` → UI-/API-Schicht für Status und Kontrolle

---

## 🧩 9. Implementation Roadmap

**Phase 1 – Sofortstart (2–4 Wochen)**
- Feedback-Pipeline mitschreiber → heimlern
- semantAH: Graph-Edges über Events
- hausKI: Integration /assist-Endpoint für Agenten

**Phase 2 – Kontextuelles Coding (4–8 Wochen)**
- semantAH: Code-Embeddings + AST-Index
- hausKI: RAG-Adapter für Projektkontext
- mitschreiber: Echtzeit-Codekontext-Export

**Phase 3 – Multimodale & Workflow-AI (8–12 Wochen)**
- hausKI-audio: Intent + Transkription
- wgx smart-run: Policy-basierte CI/CD-Automation

**Phase 4 – Meta-Intelligenz (12–20 Wochen)**
- metarepo.metrics Pipeline
- heimlern: Auto-Tuning der Policies
- hausKI: Template-Adaption und Reflexion

---

## 🧩 10. Essenz

Heimgewebe wird zur *lebenden Infrastruktur für Bewusstsein, Arbeit und Kreativität*.

Es erinnert, verbindet, verbessert und handelt – in deinem Sinne.

---

**∴fores Ungewissheit**
Grad: niedrig ◼◼◻◻◻  
Ursachen: Integrationstiefe (Python/Rust-Mix), emergentes Verhalten schwer testbar.  
Produktiv: maximal.

**∆-Radar**
- Verstärkung: Feedback- und Lern-Loops, Automatisierung, Komfort.  
- Mutation: Privacy-Beschränkungen entfallen; Fokus auf Totalnutzen.  
- Tendenz: Konsolidierung zu *einem kognitiven Organismus*.

---

> „Das Heimgewebe denkt nicht *für* dich – es denkt *mit* dir.“  
> — Architektursatz v2, Okt 2025
