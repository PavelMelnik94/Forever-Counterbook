# Platform constraints research

Research date: 2026-10-29. Scope: primary, platform-owner sources needed for the MVP. This note deliberately does not treat community API wikis or third-party gameplay guides as authoritative.

## Confirmed

### Blizzard add-on policy

- Add-ons must be distributed free of charge. Paid downloads, paid services related to an add-on, and premium versions with paid features are prohibited. Source: [Blizzard, WoW User Interface Add-On Development Policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642).
- Add-on code must be visible, unobfuscated, and freely accessible to the public. Source: [Blizzard, WoW User Interface Add-On Development Policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642).
- Add-ons may not advertise goods or services and may not solicit donations in game. Blizzard explicitly limits donation requests to an add-on website or distribution site. Therefore a support link belongs in repository/distribution-page prose, not in Lua, localization strings, slash-command output, or frames. Source: [Blizzard, WoW User Interface Add-On Development Policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642).
- Add-ons must not harm realm performance or other players, must comply with the WoW terms/EULA, and Blizzard may disable add-on functionality at its discretion. Source: [Blizzard, WoW User Interface Add-On Development Policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642).

### CurseForge distribution

- A CurseForge project submission requires a meaningful name, summary, and description; the description must clearly explain what the project does. Project and file approval is moderated. Source: [CurseForge, Creating and Submitting a Project](https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project).
- Uploads are normally ZIP archives. An uploaded file is tagged with release type, changelog, and supported game version(s). At least one `Release` file is needed for default CurseForge App synchronization. Source: [CurseForge, Creating and Submitting a Project](https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project).
- For a WoW add-on ZIP, CurseForge documents that it expects a single root folder whose name matches the `.toc` filename. Source: [CurseForge, Known Issues](https://support.curseforge.com/support/solutions/articles/9000196615).
- CurseForge requires English project names. Descriptions and summaries may additionally use other languages, but the English version must appear first. Source: [CurseForge, Moderation Policies](https://support.curseforge.com/support/solutions/articles/9000197279).
- CurseForge allows personal donation links on the project page only after the functional project description, at reasonable size. Its moderation rules also require projects to follow the game developer's EULA and terms. Source: [CurseForge, Moderation Policies](https://support.curseforge.com/support/solutions/articles/9000197279).
- CurseForge file uploads must carry a changelog, and re-uploads without substantive changes may be rejected as visibility gaming. Source: [CurseForge, Moderation Policies](https://support.curseforge.com/support/solutions/articles/9000197279).

## Project assumptions

These are product inputs, not facts verified by the platform-owner sources above:

- The target client identifies itself as WoW: Forever 1.60.1 and accepts `## Interface: 16001`.
- The target client has incomplete or restricted combat-log, enemy-aura, and protected-data access compared with other WoW clients.
- A conservative, user-invoked reference-card viewer that reads bundled static data and does not choose or execute combat actions is an appropriate first vertical slice.
- Matchup content must label provenance (`verified`, `user`, or `hypothesis`) rather than presenting all records as equally authoritative.

These assumptions should be verified in the actual Forever client before a public release. They should not be generalized from Retail or Classic API documentation.

## Unknowns

- No Blizzard-owned API/FrameXML reference specific to WoW: Forever 1.60.1 was found in the scoped search. Exact widget, event, combat-log, aura, and protected-function availability therefore remains unknown until tested against the shipped client/API.
- It is not yet confirmed that CurseForge exposes a dedicated WoW: Forever game-version tag. Confirm this in the CurseForge author UI before packaging; do not substitute an inaccurate version tag.
- The exact localized client behavior for Cyrillic fonts, saved-variable encoding, and locale identifiers in Forever remains to be tested in game.
- The specific boundary between permitted informational assistance and any newly restricted combat assistance may evolve. Keep the MVP independent of live enemy-state inference and re-check Blizzard policy before release.

## Engineering implications for the MVP

1. Keep all runtime code and bundled data readable and public.
2. Keep support/donation material entirely outside the in-game artifact.
3. Make the data loader reject unsupported schema/data versions and invalid provenance values.
4. Make the viewer user-invoked and static-data-driven; do not infer unavailable enemy state or automate actions.
5. Package later as a single correctly named root folder and supply an English-first CurseForge description, supported-version tag, and meaningful changelog.
