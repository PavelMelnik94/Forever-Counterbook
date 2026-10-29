# 05: Patch status and profile change summary

**What to build:** Show dataset revision, addon build, patch applicability, Stale Warning, and an authored summary of changes for the selected Player Profile.

**Blocked by:** 01: Versioned Matchup Card viewer.

**Status:** implemented; client smoke test pending

- [x] Schema version, Dataset Revision, addon build, and patch identity are distinct.
- [x] Unknown applicability produces a Stale Warning rather than a guess.
- [x] Change summaries are authored data and filtered by Player Profile.
- [x] Status is visible in RU and EN.
- [ ] `GetBuildInfo` values and status rendering are smoke-tested in Forever 1.60.1.

