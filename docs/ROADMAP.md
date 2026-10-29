# Vertical-slice roadmap

## Slice 1 — versioned card viewer (implemented)

Load and validate one Patch Dataset, then display one localized Matchup Card without live-combat dependencies.

## MVP

### Slice 2 — manual Matchup Journal (current)

Let the player open the current card, manually record one observation or mistake, persist it in `ForeverCounterbookDB`, and read it back. Test the journal module through a storage interface using an in-memory adapter; smoke-test the SavedVariables adapter in game.

### Slice 3 — structured journal history

Add manual Encounter Result, cause, Mistake Tags, history, and local summaries, followed by explicit export/import.

### Slice 4 — profile-aware dataset changes (implemented; client smoke test pending)

Compare the previously seen dataset revision with the bundled revision and show a short, authored “what changed for my Player Profile” summary. Do not infer changes by diffing prose at runtime.

### Slice 5 — MVP Matchup Book, inventory, and search (implemented; client smoke test pending)

Declare coverage for Restoration Shaman, Enhancement Shaman levelling, SL/SL Warlock, Arms Warrior PvP damage, Restoration Druid, and Restoration/Balance Druid; provide deterministic manual search and the two-panel Matchup Book. Every Confirmed Countermeasure must cite an accepted Source.

All current Player Profiles have an explicit build or role. Gameplay guidance still requires evidence review before content enters the Patch Dataset.

### Slice 6a — profile-aware PvP Briefing (implemented; client smoke test pending)

Show evidence-aware profile requirements and a persistent private checklist inside the Matchup Book. All bundled requirements remain Not Yet Authored until sourced.

### Slice 6b — permitted post-fight context

Add manual outcome capture and only client-verified Death Recap integrations. Action-bar inspection remains absent until capability is verified.

### Slice 7 — accessible and diagnostic UI (implemented; client smoke test pending)

Persist the primary/compact viewer choice, scale, position, and accessible theme; add UI-only keybindings and privacy-safe diagnostics. All important statuses retain textual labels, and no target or combat state is read.

## 1.0

- Cover all nine classes and relevant races after profile decisions.
- Add extended local statistics and finish in-client accessibility polish.

## 1.x

- Add Team Plans, permitted addon-channel sharing, and WSG/AB/AV/Darkspear Islands scenarios.

## 2.0

- Add source-validated community Knowledge Packs with explicit compatibility and trust rules.

## Release readiness

- Verify all UI and locale behavior in the actual Forever 1.60.1 client.
- Confirm the CurseForge game-version tag and packaging behavior.
- Add an external support URL only to README and distribution pages.
- Produce a clean ZIP with one `ForeverCounterbook` root and a meaningful changelog.
