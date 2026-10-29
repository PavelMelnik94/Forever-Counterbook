# MVP specification

## Product promise

Forever Counterbook is a patch-aware PvP reference and personal matchup coach for WoW: Forever 1.60.1 (`Interface 16001`). It helps a player prepare before a fight, distinguish verified knowledge from notes and hypotheses, reflect after a duel or death, and understand what changed when the distributed dataset changes.

It is not a diminishing-returns tracker, cooldown bar, kill feed, damage meter, combat automation tool, or source of invented live enemy state.

## Initial audience and coverage

Player Profiles: Restoration Shaman (with an eventual Enhancement levelling view), SL/SL Warlock (Affliction + Demonology), and Holy Paladin. The content milestone is one Matchup Card per Player Profile against each of the nine Opponent Classes. This first vertical slice deliberately ships one illustrative, non-confirmed `Restoration Shaman vs Warrior` card so the data contract and viewer can be exercised before gameplay claims are authored.

## MVP capabilities

1. Load exactly one declared Patch Dataset and reject incompatible or misleading data.
2. Browse a Matchup Card before combat in Russian or English.
3. Display the Evidence Status beside every Countermeasure.
4. Add private Matchup Journal entries manually after a duel or death; never infer unavailable events.
5. Show a short, dataset-authored change summary for the active Player Profile after a dataset update.
6. Store data locally, collect no telemetry, and provide no paid or premium capability.

## Acceptance criteria for this vertical slice

- The addon declares `Interface 16001` and loads without depending on live combat APIs.
- `/fcb resto_shaman warrior` opens the illustrative card.
- English is the fallback locale and Russian is selected when the client returns `ruRU`.
- A versioned dataset with schema version 1 is accepted through the catalog interface.
- Unsupported schemas, unknown Evidence Status values, mismatched card keys, and Confirmed items without a known Source are rejected with structured errors.
- Lua syntax and catalog behavior are checkable outside WoW with `npm run check`.

## Out of scope

- Reading restricted enemy auras, cooldowns, talents, or protected state.
- Automatically deciding or executing combat actions.
- Claims that an observed duel outcome proves a Countermeasure.
- Cloud sync, telemetry, accounts, monetized profiles, or in-game donation solicitation.
- CurseForge publication or release packaging in this pass.

## Open product decisions

- Which primary evidence is sufficient to mark gameplay advice Confirmed.
- Whether Enhancement becomes a separate Player Profile or a levelling mode of Restoration Shaman.
- Journal retention and export format.
- External support-page URL.

