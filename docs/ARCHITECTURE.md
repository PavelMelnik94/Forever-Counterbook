# Architecture

## Modules and seams

`MatchupCatalog.Load(dataset)` is the core seam. It hides schema validation, evidence rules, key construction, and lookup behind one interface returning either a catalog or a structured error. Tests and the WoW adapter use the same seam.

The Patch Dataset is declarative Lua loaded by the game. It contains localized text keys rather than executable behavior. `CardView` is the first WoW adapter. It translates a slash command into a catalog lookup and renders only declared card content. It does not inspect combat state. Locales are another adapter selected by the client locale with English fallback.

`MatchupJournal.New(storage)` is the personal-learning seam. It owns Journal Entry validation, identifiers, filtering, and serializable state. The SavedVariables adapter maps that state to `ForeverCounterbookDB.journal`; tests use an in-memory adapter. Neither adapter contains journal rules.

`PatchIntelligence.Evaluate(dataset, runtime, profileId)` is the freshness seam. It keeps schema version, Dataset Revision, addon version, patch identity, build, and interface distinct; returns `current` only for exact observed matches; and filters authored changes by Player Profile. `RuntimeInfo` is a thin WoW adapter: unavailable client evidence produces `unknown`, never an optimistic match.

`MatchupDirectory.Build(dataset)` is the discovery seam. It expands declared profiles and Opponent Classes into deterministic Matchup Options, distinguishes Authored from Not Yet Authored without manufacturing empty cards, and indexes only declared profile, class, ability, race, and patch terms. `MatchupBookView` is the two-panel WoW adapter over that interface.

`PvPBriefing.Build(dataset, profileId, checklistItems)` is the preparation seam. It validates authored requirements and their Evidence/Source rules, emits five explicit Authored or Not Yet Authored sections, and keeps the Private Checklist separate. `BriefingChecklist.New(storage)` owns profile-scoped private state; the SavedVariables adapter maps it only to `ForeverCounterbookDB.briefingChecklist`.

`UISettings.New(storage)` owns the validated Viewer Layout, scale, position, and UI Theme state. Its SavedVariables adapter maps only to `ForeverCounterbookDB.uiSettings`; `ViewerSettingsView` applies the same presentation rules to book and compact frames. The primary Matchup Book remains the default and compact mode is an explicit player choice. `Diagnostics.Build(context)` is a whitelist boundary that exposes only versions, patch/runtime status, and validation error codes, never Matchup Journal or Private Checklist content. Keybindings call viewer functions only and do not inspect targets or combat state.

## Dependency direction

```text
Patch Dataset -> MatchupCatalog <- tests
                         ^
Locales ----------> CardView <- WoW UI / slash command
MatchupJournal <--- CardView
      ^
SavedVariables adapter / in-memory test adapter
Patch Dataset -> PatchIntelligence <- RuntimeInfo
                         |
                  PatchStatusView
Patch Dataset -> MatchupDirectory <- tests
                         |
                  MatchupBookView
Patch Dataset -> PvPBriefing <- BriefingChecklist
                                      ^
                         SavedVariables adapter
UISettings <------------- SavedVariables adapter
Diagnostics <------------ version/status/error context
        |
MatchupBookView / safe keybindings
```

The viewer knows the catalog, journal, and Patch Intelligence interfaces; core modules know nothing about frames, locale, or combat APIs. `PatchStatusView` and `RuntimeInfo` contain the WoW-specific presentation and observation details.

## Data evolution

`schemaVersion` governs the shape understood by code. `patchKey` identifies gameplay applicability. They are intentionally separate: a patch can change content without changing the schema, while a schema migration can support more than one patch during development. Distributed content must never silently elevate an Assumption or User Note to Confirmed.

