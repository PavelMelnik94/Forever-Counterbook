# Forever Counterbook

This context describes the patch-aware PvP knowledge and personal learning concepts used by the addon.

## Language

**Matchup Card**:
A concise preparation view for one Player Profile facing one Opponent Class in one Patch Dataset.
_Avoid_: guide, tier list

**Player Profile**:
A named class-and-build perspective from which Matchup Cards are written, such as Restoration Shaman, Arms Warrior, or Restoration Druid.
_Avoid_: character, spec preset

**Restoration/Balance Druid**:
A Druid Player Profile whose primary role is Restoration and whose defined secondary talent branch is Balance.
_Avoid_: Restoration-hybrid Druid, unspecified hybrid

**Opponent Class**:
One of the nine playable classes covered by the MVP as the opposing side of a Matchup Card.
_Avoid_: enemy scan, target profile

**Patch Dataset**:
A versioned collection of Matchup Cards and Sources that applies to a declared Forever client patch.
_Avoid_: database, live data

**Countermeasure**:
A short preparation or reflection prompt on a Matchup Card, carrying an explicit Evidence Status.
_Avoid_: automatic recommendation, combat instruction

**Evidence Status**:
The declared basis of a Countermeasure: Confirmed, User Note, or Assumption.

**Confirmed**:
An Evidence Status requiring a Source recorded in the Patch Dataset.
_Avoid_: guaranteed, detected

**User Note**:
An Evidence Status for knowledge entered or owned by the player rather than distributed as verified project data.
_Avoid_: confirmed

**Assumption**:
An Evidence Status for a project hypothesis that still requires verification.
_Avoid_: fact, confirmed

**Source**:
A traceable origin supporting a Confirmed Countermeasure.
_Avoid_: proof

**Matchup Journal**:
The player's private record of observations and mistakes after a duel or death.
_Avoid_: combat log, telemetry

**Journal Entry**:
One player-authored record attached to a Matchup Card, optionally describing an Encounter Result, cause, and Mistake Tags.
_Avoid_: evidence, combat event

**Encounter Result**:
A player-recorded outcome of one encounter; it is personal history rather than proof of matchup guidance.
_Avoid_: combat-log result, evidence

**Mistake Tag**:
A controlled label for a repeated learning pattern, such as positioning, consumables, CC, dispel, cooldown, or target choice.
_Avoid_: rating, diagnosis

**Win Condition**:
A strategic state or sequence that makes success in a matchup more likely.
_Avoid_: guaranteed win

**Loss Condition**:
A strategic failure state or sequence that makes defeat in a matchup more likely.
_Avoid_: guaranteed loss

**Threat**:
A high-priority opponent capability or situation presented for preparation.
_Avoid_: detected cooldown

**Response**:
A player option paired with a Threat as preparation guidance.
_Avoid_: automated action

**Attack Window**:
A matchup state in which the Player Profile can deliberately commit offensive resources.
_Avoid_: proc detection, automatic go

**Defensive Window**:
A matchup state in which preserving or using defensive resources has priority.
_Avoid_: automatic defensive

**Critical Error**:
The single avoidable decision a Matchup Card highlights as especially costly.
_Avoid_: loss prediction

**Dataset Revision**:
The identity of one published content revision within a Patch Dataset.
_Avoid_: addon version, schema version

**Stale Warning**:
An explicit notice that the active Patch Dataset cannot be confirmed as applicable to the current client patch.
_Avoid_: broken addon

**PvP Briefing**:
A preparation view combining Player Profile requirements with a private player checklist.
_Avoid_: gear optimizer

**Team Plan**:
A player-authored coordination plan for battleground roles, control chains, and defensive assignments.
_Avoid_: raid automation

**Knowledge Pack**:
A separately distributed, versioned collection of sourced matchup knowledge compatible with a declared schema and patch.
_Avoid_: plugin, premium profile

