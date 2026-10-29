# Forever Counterbook

Forever Counterbook is an open, patch-aware PvP matchup reference and personal learning journal for **WoW: Forever 1.60.1** (`Interface 16001`). It is designed around preparation and reflection: read a concise matchup card before a fight, see whether each countermeasure is confirmed, personal, or still an assumption, then record what you learned after a duel or death.

The addon is not a DR tracker, cooldown bar, kill feed, damage meter, enemy-state oracle, or combat automation tool. It does not claim access to combat-log, enemy-aura, talent, cooldown, or protected data that the client does not expose.

## Current development slice

- Versioned Patch Dataset with validation and structured errors.
- Explicit `Confirmed`, `User Note`, and `Assumption` evidence statuses.
- English and Russian locale foundation.
- Minimal in-game viewer for the illustrative Restoration Shaman vs Warrior card.
- Manually saved Matchup Journal notes backed by SavedVariables.
- Manually recorded Encounter History with win/loss, cause, controlled Mistake Tags, and a note in separate local storage.
- Two-panel Matchup Book with deterministic RU/EN search and explicit authored/missing coverage.
- Persistent book/compact layout, scale, position, accessible themes, safe keybindings, and privacy-safe diagnostics.
- Offline Lua syntax and catalog behavior checks.

The included gameplay prompts are labelled as assumptions or user reflection prompts; they are not yet verified matchup claims.

## Install for an in-game smoke test

1. Copy or link this repository folder into the client's `Interface\AddOns\ForeverCounterbook` directory.
2. Ensure `ForeverCounterbook.toc` is directly inside that folder.
3. Start or reload the WoW: Forever 1.60.1 client and enable **Forever Counterbook**.
4. Run `/fcb resto_shaman warrior`.
5. Run `/fcb note <text>` to save a note for the open card and `/fcb notes` to read its notes.
6. Run `/fcb patch resto_shaman` to see Dataset Revision, supported build/interface, freshness, and authored profile changes.
7. Run `/fcb book resto_shaman` to open the Matchup Book.
8. Search with `/fcb search <query>`. Scoped examples: `class:воин`, `ability:<name>`, `race:<name>`, and `patch:1.60.1`.
9. Run `/fcb open <profile> <class>` to open one Matchup Option directly.
10. Run `/fcb briefing <profile> <class>` to open the profile-aware PvP Briefing inside the Matchup Book.
11. Manage the private checklist with `/fcb checklist <profile> add <text>` and `/fcb checklist <profile> toggle <id>`.
12. Configure the viewer with `/fcb ui layout book|compact`, `/fcb ui scale 0.6-1.6`, and `/fcb ui theme default|high_contrast|colorblind`.
13. Run `/fcb diagnostics` to print version, patch, client, and validation status without journal or checklist content.
14. In Key Bindings, assign **Open or close Matchup Book** or **Open selected compact card**. These bindings only open local UI and never target or act in combat.
15. Select a Matchup Option in the book, then record a result with `/fcb encounter <win|loss> <cause> | <tags> | <note>`. Separate multiple tags with commas; allowed tags are `positioning`, `consumables`, `cc`, `dispel`, `cooldown`, and `target_choice`.
16. Run `/fcb history` to list manual Encounter Results for the selected Matchup Key.

The bundled inventory currently declares 54 profile/class options: one Authored card and 53 Not Yet Authored options. Ability and race searches intentionally return no bundled results until sourced metadata is authored.

All bundled Briefing Requirement sections are currently Not Yet Authored. The private checklist is local user state and never becomes distributed Evidence. No action-bar, bag, gear, aura, or combat-state inspection is performed.

Encounter History is also private local state. Results and causes are accepted only from the explicit command; the addon does not inspect combat logs, targets, auras, or infer victory or defeat.

## Develop and verify

Node.js is needed only for checks, not by the addon: `npm install`, then `npm run check`.

See the [Product Brief](docs/product/BRIEF.md), [PRD](docs/product/PRD.md), [MVP specification](docs/MVP.md), [architecture](docs/ARCHITECTURE.md), [ticket plan](docs/TICKETS.md), [domain language](GLOSSARY.md), and [contributing conventions](CONTRIBUTING.md).

## Privacy, monetization, and support

Forever Counterbook is free, stores its eventual journal locally, and has no telemetry or premium profiles. Donation solicitation does not belong in the in-game interface. When the project has a public support page, its URL may appear here and on GitHub/CurseForge distribution pages only:

> External support page: not configured yet.

## License

Forever Counterbook is released under the [MIT License](LICENSE).
