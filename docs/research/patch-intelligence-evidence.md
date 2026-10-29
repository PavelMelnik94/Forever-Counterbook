# Patch Intelligence evidence

Research date: 2026-10-29. Scope: platform-owner evidence for addon version, interface/build compatibility, and honest freshness reporting. Community API references and gameplay sources are intentionally excluded.

## Confirmed

- Blizzard reserves the right to disable addon functionality and requires addons to comply with the WoW terms and EULA. Compatibility reporting therefore cannot turn an observed or declared version into a guarantee that every function remains available. Source: [Blizzard, World of Warcraft User Interface Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534).
- CurseForge describes a TOC file as addon metadata plus instructions used by the Blizzard client to load the addon. CurseForge also states that authors are responsible for keeping interface numbers and supported versions current. Source: [CurseForge, Multi-TOC for World of Warcraft Addons](https://support.curseforge.com/en/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons).
- CurseForge file uploads are tagged with the game versions they support, and those tags are visible in project details. Distribution compatibility is therefore an author/deployment declaration, not evidence that the installed runtime dataset is current. Source: [CurseForge, Multi-TOC for World of Warcraft Addons](https://support.curseforge.com/en/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons).
- CurseForge warns that an addon without a compatible version may be shown as outdated or corrupt and may still behave differently in game. This supports treating version metadata as compatibility evidence rather than a runtime guarantee. Source: [CurseForge, Updating Addons for New World of Warcraft Classic Expansions](https://support.curseforge.com/en/support/solutions/articles/9000202351-burning-crusade-classic-troubleshooting).

## Project assumptions

- The Forever 1.60.1 client accepts `## Interface: 16001`.
- The addon can read a client version/interface value at runtime through a `GetBuildInfo`-like function with the return shape expected by this project.
- The bundled Patch Dataset may declare its own Dataset Revision, supported interface, patch identity, and authored profile changes independently of the addon version.

These are project inputs, not facts established by the platform-owner sources above. They require an in-client smoke test before release.

## Unknowns

- No Blizzard-owned API contract specific to WoW: Forever was found for `GetBuildInfo`, addon metadata access, or build/interface mapping.
- It is unknown whether Forever exposes the same version functions, argument order, or values as another WoW client.
- A TOC `Interface` match alone does not establish that a Patch Dataset's gameplay knowledge is current.
- CurseForge support for a dedicated Forever version tag remains unconfirmed.

## Engineering implications

1. Keep addon version, schema version, Dataset Revision, declared patch identity, declared supported interface, and observed client interface as separate values.
2. Report `current` only when observed client evidence exactly matches the dataset's declared support. Report `stale` for a known mismatch and `unknown` when client evidence is absent or malformed.
3. Never infer current gameplay knowledge from the addon version, TOC alone, CurseForge tags, or a nearby interface number.
4. Treat profile change summaries as authored Patch Dataset content, filtered by Player Profile; do not synthesize them from prose or combat observations.
5. Put runtime version access behind a thin adapter so the core status module can be tested without assuming a Forever-specific API contract.
6. Smoke-test the actual Forever client values and CurseForge version tag before release, and preserve `unknown` as a safe fallback.
