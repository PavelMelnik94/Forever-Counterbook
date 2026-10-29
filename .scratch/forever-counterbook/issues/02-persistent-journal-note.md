# 02: Persistent Matchup Journal note

**What to build:** Let a player attach a private note to the open Matchup Card and read it after the addon is loaded again.

**Blocked by:** 01: Versioned Matchup Card viewer.

**Status:** implemented; client smoke test pending

- [x] A note is added manually to the current Matchup Key.
- [x] A new Journal instance over the same SavedVariables state returns the note.
- [x] RU and EN commands and confirmations are available.
- [ ] Saving and reading after `/reload` is smoke-tested in Forever 1.60.1.

