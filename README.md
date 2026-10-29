# Forever Counterbook

Forever Counterbook is an open, patch-aware PvP matchup reference and personal learning journal for **WoW: Forever 1.60.1** (`Interface 16001`). It is designed around preparation and reflection: read a concise matchup card before a fight, see whether each countermeasure is confirmed, personal, or still an assumption, then record what you learned after a duel or death.

The addon is not a DR tracker, cooldown bar, kill feed, damage meter, enemy-state oracle, or combat automation tool. It does not claim access to combat-log, enemy-aura, talent, cooldown, or protected data that the client does not expose.

## Current development slice

- Versioned Patch Dataset with validation and structured errors.
- Explicit `Confirmed`, `User Note`, and `Assumption` evidence statuses.
- English and Russian locale foundation.
- Minimal in-game viewer for the illustrative Restoration Shaman vs Warrior card.
- Manually saved Matchup Journal notes backed by SavedVariables.
- Offline Lua syntax and catalog behavior checks.

The included gameplay prompts are labelled as assumptions or user reflection prompts; they are not yet verified matchup claims.

## Install for an in-game smoke test

1. Copy or link this repository folder into the client's `Interface\AddOns\ForeverCounterbook` directory.
2. Ensure `ForeverCounterbook.toc` is directly inside that folder.
3. Start or reload the WoW: Forever 1.60.1 client and enable **Forever Counterbook**.
4. Run `/fcb resto_shaman warrior`.
5. Run `/fcb note <text>` to save a note for the open card and `/fcb notes` to read its notes.
6. Run `/fcb patch resto_shaman` to see Dataset Revision, supported build/interface, freshness, and authored profile changes.

## Develop and verify

Node.js is needed only for checks, not by the addon: `npm install`, then `npm run check`.

See the [Product Brief](docs/product/BRIEF.md), [PRD](docs/product/PRD.md), [MVP specification](docs/MVP.md), [architecture](docs/ARCHITECTURE.md), [ticket plan](docs/TICKETS.md), [domain language](GLOSSARY.md), and [contributing conventions](CONTRIBUTING.md).

## Privacy, monetization, and support

Forever Counterbook is free, stores its eventual journal locally, and has no telemetry or premium profiles. Donation solicitation does not belong in the in-game interface. When the project has a public support page, its URL may appear here and on GitHub/CurseForge distribution pages only:

> External support page: not configured yet.

## License

Forever Counterbook is released under the [MIT License](LICENSE).
