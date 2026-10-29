# Accessible UI evidence

Research date: 2026-10-29. Scope: primary Blizzard sources relevant to ticket 10. This note distinguishes product-level evidence from an API contract; no community API wiki is treated as authoritative.

## Confirmed by Blizzard

### Movable and scalable presentation

- Blizzard describes UI customizability as a core WoW principle and says add-ons may continue to change the location, size, and shape of frames while combat-information changes are constrained to prevent add-ons from making decisions for the player. This supports a movable/scalable informational panel as a permitted product category, but does **not** prove any particular Lua method exists in Forever. Source: [Blizzard, Combat Philosophy and Addon Disarmament in Midnight](https://worldofwarcraft.blizzard.com/en-us/news/24246290/combat-philosophy-and-addon-disarmament-in-midnight).
- Blizzard's base UI also exposes user customization and accessibility controls. The Forever starter guide directs players to `Game Menu > Options` for controls, key bindings, action bars, display, and accessibility settings. Source: [Blizzard, New Player's Starter Guide: Welcome to World of Warcraft: Forever](https://worldofwarcraft.blizzard.com/en-us/news/24315280).

### Local persistence and SavedVariables

- Blizzard Support's full UI reset procedure renames the local `Cache`, `Interface`, and `WTF` folders before relaunching the client. This is first-party evidence that add-ons/UI configuration have local on-disk state. It is **not** documentation of `.toc` `SavedVariables` declarations, scope, serialization, or write timing. Source: [Blizzard Support, Resetting the WoW User Interface](https://us.support.blizzard.com/en/help/article/7549).
- Therefore ticket 10 may require local persistence of position, scale, and layout, but its implementation must first verify Forever's actual SavedVariables mechanism. Do not infer Retail schema or lifecycle details from the reset article.

### Keybindings and combat boundaries

- Blizzard documents player-editable key bindings in the game UI; the Forever starter guide explicitly says controls and key bindings can be changed under Options. Sources: [Blizzard, New Player Tips: Press “1” for More Options](https://worldofwarcraft.blizzard.com/en-gb/news/9997302/new-player-tips-press-1-for-more-options), [Blizzard, Forever starter guide](https://worldofwarcraft.blizzard.com/en-us/news/24315280).
- Blizzard's current add-on direction is explicit: add-ons should not process combat information to automate or make combat decisions for the player. A Counterbook binding should therefore only open, close, focus, or navigate an informational UI; it must not target, cast, use an item, choose an ability, or chain a protected combat action. Source: [Blizzard, Combat Philosophy and Addon Disarmament in Midnight](https://worldofwarcraft.blizzard.com/en-us/news/24246290/combat-philosophy-and-addon-disarmament-in-midnight).
- The general add-on policy also requires compliance with the WoW terms/EULA and reserves Blizzard's right to disable add-on functionality. Source: [Blizzard, WoW User Interface Add-On Development Policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642).

### Color-independent status

- Blizzard's colorblind UI adds words such as “Rare” and “Epic” and friendly/neutral/hostile text where color previously carried the distinction. This is direct first-party precedent for redundant textual encoding rather than color alone. Source: [Blizzard, New Colorblind Support in Patch 6.1](https://worldofwarcraft.blizzard.com/en-gb/news/17989015).
- Blizzard later added a plus icon to learnable talent nodes when UI Colorblind Mode is enabled, another precedent for pairing color with a distinct symbol. Source: [Blizzard, Dragonflight 10.0.5 Content Update Notes](https://worldofwarcraft.blizzard.com/en-us/news/23892227).
- Ticket 10 should encode every important state with a short word plus an icon/shape (for example, `Verified ✓`, `Hypothesis ?`, `Invalid !`), with color as optional reinforcement. An explicit high-contrast theme is safer than assuming access to the client's colorblind setting.

## Forever-specific unknowns

No public Blizzard-owned Forever 1.60.1 API/FrameXML contract was found for:

- `CreateFrame`, `SetScale`, `SetMovable`, `StartMoving`, or `StopMovingOrSizing` signatures and behavior;
- `.toc` `SavedVariables` / per-character variables, serialization limits, and logout/reload write behavior;
- `Bindings.xml`, `SetBinding*`, binding persistence, or restrictions during combat lockdown;
- protected-action boundaries for addon-created buttons and keys;
- colorblind CVars, events, accessibility APIs, font coverage, or Cyrillic rendering.

These are release-blocking verification items, not implied capabilities. Smoke-test them in the exact Forever client and treat an absent or restricted API as unavailable.

## Ticket 10 implementation consequences

1. Keep the Matchup Book movable/scalable only after in-client method verification; provide safe defaults and a visible “Reset layout” action.
2. Persist only local UI preferences (position, scale, compact/full mode, accessibility theme, and verified binding choice), with schema versioning and bounds checks.
3. Bindings may toggle or navigate Counterbook UI only. Never bind targeting, casting, item use, or combat decisions.
4. Use status text and icons/shapes in addition to color. Ensure meaning survives grayscale and theme changes.
5. Diagnostics may show addon/data/schema versions, failed capability checks, and validation errors; they should not expose personal journal contents.
6. If a Forever capability probe fails, degrade visibly: fixed-position frame, default scale, slash-command opening, or manual accessibility theme rather than silent partial behavior.
