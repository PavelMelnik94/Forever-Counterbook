# Vertical-slice roadmap

## Slice 1 — versioned card viewer (implemented)

Load and validate one Patch Dataset, then display one localized Matchup Card without live-combat dependencies.

## Slice 2 — manual Matchup Journal

Let the player open the current card, manually record one observation or mistake, persist it in `ForeverCounterbookDB`, and read it back. Test the journal module through a storage interface using an in-memory adapter; smoke-test the SavedVariables adapter in game.

## Slice 3 — profile-aware dataset changes

Compare the previously seen dataset revision with the bundled revision and show a short, authored “what changed for my Player Profile” summary. Do not infer changes by diffing prose at runtime.

## Slice 4 — content breadth

Add the remaining eight Restoration Shaman cards, then the nine SL/SL Warlock and nine Holy Paladin cards. Every Confirmed Countermeasure must cite an accepted Source; unresolved gameplay claims remain Assumptions.

## Release readiness

- Verify all UI and locale behavior in the actual Forever 1.60.1 client.
- Confirm the CurseForge game-version tag and packaging behavior.
- Add an external support URL only to README and distribution pages.
- Produce a clean ZIP with one `ForeverCounterbook` root and a meaningful changelog.
