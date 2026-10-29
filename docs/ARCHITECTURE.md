# Architecture

## Modules and seams

`MatchupCatalog.Load(dataset)` is the core seam. It hides schema validation, evidence rules, key construction, and lookup behind one interface returning either a catalog or a structured error. Tests and the WoW adapter use the same seam.

The Patch Dataset is declarative Lua loaded by the game. It contains localized text keys rather than executable behavior. `CardView` is the first WoW adapter. It translates a slash command into a catalog lookup and renders only declared card content. It does not inspect combat state. Locales are another adapter selected by the client locale with English fallback.

## Dependency direction

```text
Patch Dataset -> MatchupCatalog <- tests
                         ^
Locales ----------> CardView <- WoW UI / slash command
```

The viewer knows the catalog interface; the catalog knows nothing about frames, saved variables, locale, or combat APIs. Journal storage and dataset-change summaries should become separate modules that reference stable profile and matchup keys.

## Data evolution

`schemaVersion` governs the shape understood by code. `patchKey` identifies gameplay applicability. They are intentionally separate: a patch can change content without changing the schema, while a schema migration can support more than one patch during development. Distributed content must never silently elevate an Assumption or User Note to Confirmed.

