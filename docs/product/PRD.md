# Product Requirements Document

## Problem Statement

WoW: Forever PvP players must combine patch-specific class knowledge with lessons from their own fights. General guides blur verified facts, hypotheses, and personal observations; combat addons often optimize live tracking instead of durable learning. Client API limitations also make some live claims impossible or unsafe.

## Solution

Forever Counterbook provides a manually opened Matchup Card backed by a versioned knowledge base, plus a private Matchup Journal. Patch Intelligence explains freshness and authored changes. Later releases add structured briefings, permitted post-fight context, broader profiles, local statistics, and team plans without turning the addon into combat automation.

## User Stories

1. As a player, I want to select my Player Profile, so that advice is written from my actual role and build perspective.
2. As a Restoration Shaman, Enhancement levelling Shaman, SL/SL Warlock, Arms Warrior, Restoration Druid, or Restoration/Balance Druid player, I want cards against each Opponent Class, so that I can prepare consistently.
3. As an Arms Warrior or Druid player, I want advice written for an explicit build and role, so that generic class labels do not hide contradictory play styles.
4. As a player, I want each card to state Win Conditions and Loss Conditions, so that I understand the strategic shape of the matchup.
5. As a player, I want dangerous abilities and racial bonuses identified, so that I can prepare responses.
6. As a player, I want CC, dispels, immunities, Defensive Windows, and resources-to-save explained, so that the advice is actionable.
7. As a player, I want duel, world PvP, and battleground context separated, so that advice does not silently cross scenarios.
8. As a player, I want a two-panel Matchup Book with coverage on the left and the selected card, patch/source context, and personal notes on the right, so that learning remains navigable and honest about missing content.
9. As a player, I want to open a card manually by target or search, so that the addon assists without automatic targeting.
10. As a player, I want every Countermeasure labelled Confirmed, Assumption, or User Note, so that I know how much trust to place in it.
11. As a maintainer, I want Confirmed guidance tied to Sources and a Patch Dataset, so that stale claims are reviewable.
12. As a player, I want to add a Journal Entry to the open Matchup Card, so that I retain lessons from a fight.
13. As a player, I want the Journal Entry to survive reload and logout, so that the journal is dependable.
14. As a player, I want to record outcome, cause, repeated mistakes, and Mistake Tags, so that patterns emerge locally.
15. As a player, I want encounter history and local statistics, so that I can evaluate my progress without telemetry.
16. As a player, I want export and import, so that I can back up or transfer my private journal deliberately.
17. As a player, I want dataset version, build, changelog, Stale Warning, and profile-specific changes, so that I do not apply old advice blindly.
18. As a player, I want a PvP Briefing for gear, trinkets, consumables, reagents, action-bar omissions, and my checklist, so that preparation includes logistics.
19. As a player, I want to record a result manually after combat and optionally attach available Blizzard Death Recap information, so that hidden data is never invented.
20. As a player, I want RU and EN, compact/full layouts, scale, movement, themes, colorblind support, keybinds, and diagnostics, so that the addon is accessible and operable.
21. As a battleground player after MVP, I want Team Plans for kill target, peel, dispel, flag carrier, CC chains, and defensive assignments, so that a group can coordinate permitted information.
22. As a team member, I want plans shared through permitted addon channels, so that coordination stays within platform rules.
23. As a community contributor in 2.0, I want Knowledge Packs with source verification, so that content can grow without weakening provenance.
24. As a privacy-conscious player, I want no telemetry, accounts, ratings, or social network, so that my learning data remains local.
25. As a player, I want every feature free under MIT with no premium gate, so that product support never changes gameplay access.

## Functional Requirements

### Knowledge base and Matchup Card

- A Matchup Card belongs to one Player Profile, Opponent Class, PvP Context, and Patch Dataset.
- Full content supports strategic conditions, abilities, racial bonuses, control interactions, windows, stages, and scenario-specific advice.
- Compact content presents at most three primary Threats and Responses plus one Attack Window and Critical Error.
- The primary MVP UI is the two-panel Matchup Book; a compact PvP Card is a later optional mode.
- Advice is never promoted to Confirmed without a Source accepted by project policy.

### Matchup Journal

- Entry creation is explicit and player-initiated.
- MVP starts with a note attached to the currently open Matchup Card and persisted locally.
- Later slices add Encounter Result, cause, Mistake Tags, history, statistics, and safe export/import.
- Journal content never becomes distributed project evidence automatically.

### Patch Intelligence

- The addon distinguishes schema version, Dataset Revision, client patch, and addon build.
- Change summaries are authored for Player Profiles rather than inferred from prose at runtime.
- A Stale Warning appears when applicability cannot be established.

### PvP Briefing and post-fight flow

- Briefing combines profile-authored requirements with a user checklist.
- Any action-bar or Death Recap integration is gated by verified client capability.
- Post-fight flow accepts manual outcome first and may attach only platform-exposed facts.

### Team play and community content

- Team Plans and addon-channel sharing are post-MVP.
- Knowledge Packs are a 2.0 capability and require provenance validation and compatibility rules.

## Player Profile Scope

- MVP committed profiles: Restoration Shaman, SL/SL Warlock, Arms Warrior as PvP damage, Restoration Druid, and Restoration/Balance Druid.
- MVP levelling profile: Enhancement Shaman.
- 1.0 target: coverage for all nine classes and relevant races.

## Implementation Decisions

- Patch knowledge remains declarative and separate from core modules.
- The catalog interface is the seam for loading and querying distributed knowledge.
- The journal interface accepts a storage adapter; SavedVariables is the game adapter and an in-memory adapter supports tests.
- Stable Matchup Keys connect cards, Journal Entries, change summaries, and future statistics.
- RU and EN strings are added together; EN remains fallback.
- Manual invocation precedes any compact live helper.

## Testing Decisions

- Tests exercise observable behavior through catalog and journal interfaces.
- Catalog tests verify data compatibility and evidence invariants.
- Journal tests verify persistence by constructing a new Journal instance over the same storage state.
- The SavedVariables adapter is checked outside WoW for round-trip behavior and smoke-tested in the actual client before release.
- UI widgets, protected APIs, locale rendering, and reload behavior require client smoke tests.

## Out of Scope

See [Constraints and non-goals](CONSTRAINTS.md).

## Open Decisions

- Evidence policy for Confirmed gameplay guidance.
- Journal retention, export encoding, and conflict behavior.
- Exact Forever client capabilities for target lookup, action bars, Death Recap, and addon channels.
- External support-page URL.

