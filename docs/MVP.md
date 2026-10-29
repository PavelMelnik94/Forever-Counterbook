# MVP specification

## Product promise

Forever Counterbook is a patch-aware PvP reference and personal matchup coach for WoW: Forever 1.60.1 (`Interface 16001`). It helps a player prepare before a fight, distinguish verified knowledge from notes and hypotheses, reflect after a duel or death, and understand what changed when the distributed dataset changes.

It is not a diminishing-returns tracker, cooldown bar, kill feed, damage meter, combat automation tool, or source of invented live enemy state.

## Initial audience and coverage

Committed Player Profiles are Restoration Shaman, Enhancement Shaman as a levelling profile, SL/SL Warlock (Affliction + Demonology), Arms Warrior as a PvP damage profile, Restoration Druid, and Restoration/Balance Druid. The future 1.0 target covers all nine classes.

## MVP capabilities

1. Load exactly one declared Patch Dataset and reject incompatible or misleading data.
2. Browse a Matchup Card before combat in Russian or English.
3. Display the Evidence Status beside every Countermeasure.
4. Add private Matchup Journal entries manually, persist them through reload, and read them from the relevant card; never infer unavailable events.
5. Show a short, dataset-authored change summary for the active Player Profile after a dataset update.
6. Store data locally, collect no telemetry, and provide no paid or premium capability.

## Acceptance criteria for this vertical slice

- The addon declares `Interface 16001` and loads without depending on live combat APIs.
- `/fcb resto_shaman warrior` opens the illustrative card.
- English is the fallback locale and Russian is selected when the client returns `ruRU`.
- A versioned dataset with schema version 1 is accepted through the catalog interface.
- Unsupported schemas, unknown Evidence Status values, mismatched card keys, and Confirmed items without a known Source are rejected with structured errors.
- Lua syntax and catalog behavior are checkable outside WoW with `npm run check`.

## Matchup Journal slice

- The user opens a Matchup Card, runs `/fcb note <text>`, and receives a saved confirmation.
- `/fcb notes` lists notes for the currently open card.
- A new Journal instance over the same SavedVariables state returns the saved note.
- The core Journal is tested through its public interface using in-memory storage.
- No outcome, tags, statistics, combat-event detection, or automatic post-fight prompt is included in this slice.

## Patch Intelligence slice

- `/fcb patch <profile>` shows Dataset Revision, patch identity, addon version, supported build/interface, and freshness.
- Exact observed client version, raw build, and interface matches return `current`; a known mismatch returns `stale`; missing runtime evidence returns `unknown` with a warning.
- Profile changes are authored Patch Dataset entries, filtered by Player Profile, and never inferred by diffing prose.
- A Confirmed profile change must reference a known Source.
- Actual `GetBuildInfo` behavior and rendering remain an in-client smoke test.

## Matchup Book and search slice

- `/fcb book <profile>` opens the primary two-panel Matchup Book.
- The top panel identifies the Player Profile and provides manual search; the left panel lists Matchup Options and their Authored or Not Yet Authored status; the right panel renders the selected Matchup Card, missing sections, patch/source context, and personal notes.
- `/fcb search <query>` supports deterministic profile aliases plus scoped `class:`, `ability:`, `race:`, and `patch:` queries without target reads.
- `/fcb open <profile> <class>` opens one option directly; missing content remains Not Yet Authored and never becomes a placeholder Matchup Card.
- Six profiles across nine Opponent Classes produce 54 declared options. The bundled dataset currently has one Authored card and 53 Not Yet Authored options.
- Ability/race behavior is tested with fixtures; bundled ability/race terms stay empty until Source-backed metadata is authored.
- Compact PvP Card is a future additional mode, not part of this slice.

## PvP Briefing slice

- The selected Matchup Book option shows five profile-aware sections: gear, trinkets, consumables, reagents, and key abilities.
- Each section is Authored only when requirements exist; otherwise it is explicitly Not Yet Authored.
- Confirmed Briefing Requirements require a known Source; Assumptions remain visibly labelled.
- The Private Checklist is stored separately per Player Profile and supports manual add/toggle commands.
- Bundled Briefing Requirements are currently all Not Yet Authored because no complete source-backed loadout exists for the active profiles.
- No action-bar, inventory, equipment, aura, cooldown, or combat-state inspection is included.

## Accessible and diagnostic UI slice

- The primary two-panel Matchup Book remains the default; the player may explicitly select the optional compact card layout.
- Layout, scale, Matchup Book position, and theme persist in a dedicated local `uiSettings` SavedVariables record.
- `default`, `high_contrast`, and `colorblind` themes supplement textual Authored/Not Yet Authored and Evidence labels; meaning never depends on color alone.
- Keybindings only toggle the Matchup Book or open the already selected authored compact card. They do not select targets or perform combat actions.
- `/fcb diagnostics` reports whitelisted addon, schema, dataset, patch, client, interface, and validation fields without journal notes or checklist text.
- Frame, binding, font, and SavedVariables behavior still require an in-client Forever 1.60.1 smoke test.

## Out of scope

- Reading restricted enemy auras, cooldowns, talents, or protected state.
- Automatically deciding or executing combat actions.
- Claims that an observed duel outcome proves a Countermeasure.
- Cloud sync, telemetry, accounts, monetized profiles, or in-game donation solicitation.
- CurseForge publication or release packaging in this pass.

## Open product decisions

- Which primary evidence is sufficient to mark gameplay advice Confirmed.
- Journal retention and export format.
- External support-page URL.

