# 03: Structured encounter history

**What to build:** Let a player record an Encounter Result, cause, and Mistake Tags with a note, then browse history for one Matchup Card.

**Blocked by:** 02: Persistent Matchup Journal note.

**Status:** implemented; client smoke test pending

- [x] Entry creation remains manual and accepts win/loss, cause, and controlled Mistake Tags.
- [x] History is filtered by Matchup Key and survives reload through the storage seam.
- [x] Existing note-only entries remain readable.
- [x] RU and EN labels are complete.
- [ ] Smoke-test commands, selected-card rendering, Cyrillic text, and SavedVariables persistence after `/reload` in Forever 1.60.1.

