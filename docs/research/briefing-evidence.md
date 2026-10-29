# PvP Briefing evidence

Research date: 2026-10-29. Scope: primary-source evidence for profile-authored gear, trinket, consumable, reagent, and ability requirements in WoW: Forever. This note intentionally contains no PvP recommendations.

## Confirmed

- Blizzard describes Forever gearing as role-, activity-, and playstyle-dependent. The game keeps familiar Classic stats while reworking or adding others, changes weapon-skill itemization, lets healing power contribute some damage, and revises many item drops. This confirms that gear requirements are patch-sensitive rather than universal defaults. Source: [Blizzard, World of Warcraft: Forever Deep Dive Panel Recap](https://worldofwarcraft.blizzard.com/en-us/news/24303313).
- Blizzard's Forever class deep dives explicitly list class abilities and talents for Shaman, Druid, Warrior, and Warlock, but repeatedly warn that abilities and talents may continue to evolve during beta. Exact ability requirements may therefore be authored only when tied to a specific Source and Patch Dataset. Sources: [Blizzard, Mage and Shaman deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman), [Blizzard, Hunter and Druid deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid), [Blizzard, Priest and Warrior deep dive](https://worldofwarcraft.blizzard.com/en-gb/news/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior), and [Blizzard, Rogue and Warlock deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24310968).
- The Druid deep dive says shapeshifted Druids can use all potions and almost all similar consumables without leaving form. This is a sourced class capability, but it does not establish that a particular consumable is required for a PvP briefing. Source: [Blizzard, Hunter and Druid deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid).
- The Shaman deep dive identifies named abilities and describes weapon imbues, totems, and talent changes. These names can be referenced as patch-sensitive authored knowledge, but the article does not prove that any one reagent, action-bar placement, or loadout is mandatory. Source: [Blizzard, Mage and Shaman deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman).
- Blizzard's addon policy requires addons to be free, publicly readable, non-advertising in game, and compliant with the game terms; Blizzard may disable addon functionality. A Briefing must therefore remain readable static/user data and cannot treat an unverified client capability as guaranteed. Source: [Blizzard, World of Warcraft User Interface Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534).

## Project-authored data

- The six approved Player Profile names are project navigation identities. A per-profile briefing can exist with empty sections without claiming Blizzard recommends a build or loadout.
- A private checklist item is user-authored state. It is not gameplay evidence and must remain separate from distributed requirements.
- `Not Yet Authored` is an honest content status, not an Assumption and not a recommendation.

## Assumptions

- The project assumes the cited beta-era Forever pages are relevant background for the target `1.60.1` Patch Dataset, but individual requirements still need revision-specific verification before being marked Confirmed.
- The project assumes manual checklist storage in SavedVariables does not require live combat access.

## Unknowns

- No complete official profile-specific PvP gear, trinket, consumable, or reagent checklist was found for the six approved profiles and target Dataset Revision.
- No official Forever-specific contract was found that safely exposes action-bar contents to this addon.
- The sources do not establish universal best-in-slot items, mandatory consumables, required reagents, or one correct action-bar layout for these profiles.
- The exact launch values may differ from beta-era deep dives; sources themselves warn that abilities and talents can change.

## Engineering implications

1. Ship all bundled briefing requirement sections as `Not Yet Authored` until a specific item or ability requirement has a Source, Evidence Status, Player Profile, and Patch Dataset.
2. Validate every authored requirement: Confirmed requires a known Source; Assumption remains visibly labelled and must never be upgraded by UI or checklist state.
3. Keep private checklist items in a separate local store. They never become distributed requirements automatically.
4. Do not inspect action bars in this slice. If capability is researched later, gate it behind a thin adapter and retain a manual fallback.
5. Present missing categories explicitly instead of filling them with generic Classic knowledge or inferred best practices.
