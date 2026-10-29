# Content search evidence

Research date: 2026-10-29. Scope: primary-source evidence for Player Profile identities and searchable class, ability, race, and patch metadata in WoW: Forever. This note intentionally contains no matchup recommendations.

## Confirmed

- Blizzard's official Forever overview says the product has nine available classes and publishes the Horde and Alliance race/class-combination tables. The tables name Druid, Hunter, Mage, Paladin, Priest, Rogue, Shaman, Warlock, and Warrior, and include Forever-specific combinations such as Skyborne. These class and race names may be indexed as source-backed Forever identities when the dataset records this Blizzard page as their Source. Source: [Blizzard, Create the Hero You Want to Be in World of Warcraft: Forever](https://worldofwarcraft.blizzard.com/en-us/news/24304075/erschafft-den-helden-der-ihr-sein-wollt-in-world-of-warcraft-forever).
- Blizzard publishes Forever-specific class deep dives, including Warrior, Druid, Shaman, and Warlock. These pages are suitable primary Sources for the exact ability or talent names they explicitly describe, but not for claims absent from the page. Sources: [Blizzard, Priest and Warrior deep dive](https://worldofwarcraft.blizzard.com/en-gb/news/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior), [Hunter and Druid deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24301515/), [Mage and Shaman deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman), [Rogue and Warlock deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24310968).
- Blizzard repeatedly warns in those deep dives that Forever abilities and talents may continue to evolve during beta. An ability name found there is patch-sensitive evidence, not a permanent cross-revision fact. Source: [Blizzard, Hunter and Druid deep dive](https://worldofwarcraft.blizzard.com/en-us/news/24301515/).
- Blizzard's addon policy requires visible public code and permits Blizzard to disable addon functionality. Search indexes must therefore remain readable bundled data and cannot imply that a static name proves live client availability. Source: [Blizzard, World of Warcraft User Interface Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534).

## Project-declared identities

- Restoration Shaman, Enhancement Shaman (levelling), SL/SL Warlock, Arms Warrior, Restoration Druid, and Restoration/Balance Druid are product-owned Player Profile identities approved by the project. Their names can be searchable without claiming that Blizzard publishes those exact builds.
- Stable internal identifiers and RU/EN aliases are project vocabulary. They should be treated as navigation metadata, not gameplay evidence.
- A declared inventory row saying that a Matchup Card is missing or not yet authored is project state and needs no gameplay claim.

## Assumptions

- The project assumes the official Forever article's nine-class list applies to the target 1.60.1 Patch Dataset.
- The project assumes RU aliases can be authored as navigation labels without changing the underlying class identity.

## Unknowns

- No official source was found that freezes every ability, racial bonus, talent, or localized RU name for the exact target dataset revision.
- The current source set does not establish a complete source-backed ability or race index for all six Player Profiles and all nine Opponent Classes.
- Search metadata alone cannot establish matchup relevance, counterplay, or an Evidence Status for advice.

## Engineering implications

1. Index the six project-approved Player Profile names and the nine source-backed Opponent Class identities, with RU/EN aliases kept as navigation metadata.
2. Keep ability and race terms optional per authored card. With no sourced term, return an honest empty result rather than inventing metadata.
3. Prove ability/race search behavior with test fixtures; do not use fixture terms as bundled knowledge.
4. Store patch identity on every search document so patch queries are deterministic and never inferred from runtime combat state.
5. Represent the full profile-by-opponent matrix as `authored` or `missing`; a missing row is diagnostics, not an empty advice card.
6. Require a recorded Source before a bundled ability or race term is presented as Confirmed Forever content, and re-check it when Dataset Revision changes.
