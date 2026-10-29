# Constraints and Non-goals

## Platform constraints

- Target client assumptions are WoW: Forever 1.60.1 and `Interface 16001`; client-specific API availability requires in-game verification.
- The addon reads only data actually exposed by the client and never represents unavailable state as observed fact.
- Runtime code and distributed data remain public, readable, and free.
- Donation solicitation and external support links never appear in the game UI.

## Product constraints

- Evidence Status is visible and cannot be omitted from distributed Countermeasures.
- User Notes remain private user knowledge and never become Confirmed automatically.
- Patch applicability and dataset freshness are explicit.
- RU and EN are maintained together.
- The core learning loop works without telemetry, network services, accounts, or paid capabilities.

## Non-goals

- Combat automation, automatic targeting, casts, item use, or decision execution.
- Hidden combat-log reconstruction, unavailable enemy-aura reads, or inferred protected state.
- Presenting Assumptions as facts.
- Replacing DR trackers, cooldown bars, kill feeds, or damage meters.
- External social network, public ratings, or cloud statistics in MVP.
- Automatically treating fight outcomes or Death Recap as proof of a Countermeasure.
- Gameplay advice for an unnamed or ambiguous Player Profile.

## Distribution constraints

- MIT licensed; no premium profiles or paid functionality.
- Buy Me a Coffee may appear on GitHub, CurseForge, or another distribution page only.
- CurseForge project creation, release packaging, and publication require separate authorization.
