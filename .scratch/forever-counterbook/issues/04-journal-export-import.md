# 04: Safe Journal export and import

**What to build:** Let a player explicitly export personal Journal Entries and restore them with validation and a clear merge or replace choice.

**Blocked by:** 03: Structured encounter history.

**Status:** implemented; client smoke test pending

- [x] Export contains a version and only personal journal data.
- [x] Invalid or incompatible imports are rejected without modifying existing data.
- [x] Merge and replace behavior is explicit and tested.
- [x] No network or telemetry is introduced.
- [ ] Smoke-test multiline copy/paste, RU/EN and Cyrillic, preview/apply, merge/replace, a 65,536-byte paste rejecting without truncation, and `/reload` persistence in Forever 1.60.1.

