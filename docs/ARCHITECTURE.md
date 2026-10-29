# Architecture

## Modules and seams

`MatchupCatalog.Load(dataset)` is the core seam. It hides schema validation, evidence rules, key construction, and lookup behind one interface returning either a catalog or a structured error. Tests and the WoW adapter use the same seam.

The Patch Dataset is declarative Lua loaded by the game. It contains localized text keys rather than executable behavior. `CardView` is the first WoW adapter. It translates a slash command into a catalog lookup and renders only declared card content. It does not inspect combat state. Locales are another adapter selected by the client locale with English fallback.

`MatchupJournal.New(storage)` is the personal-learning seam. It owns Journal Entry validation, identifiers, filtering, and serializable state. The SavedVariables adapter maps that state to `ForeverCounterbookDB.journal`; tests use an in-memory adapter. Neither adapter contains journal rules.

## Dependency direction

```text
Patch Dataset -> MatchupCatalog <- tests
                         ^
Locales ----------> CardView <- WoW UI / slash command
MatchupJournal <--- CardView
      ^
SavedVariables adapter / in-memory test adapter
```

The viewer knows the catalog and journal interfaces; both core modules know nothing about frames, locale, or combat APIs. Dataset-change summaries should become a separate module referencing stable profile and matchup keys.

## Data evolution

`schemaVersion` governs the shape understood by code. `patchKey` identifies gameplay applicability. They are intentionally separate: a patch can change content without changing the schema, while a schema migration can support more than one patch during development. Distributed content must never silently elevate an Assumption or User Note to Confirmed.

