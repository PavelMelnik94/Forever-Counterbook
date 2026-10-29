# Contributing

## Local checks

Install Node.js dependencies once with `npm install`, then run `npm run check`. This parses all Lua as Lua 5.1-compatible syntax and runs the catalog behavior tests in Fengari. In-game smoke testing on the Forever 1.60.1 client remains required for UI changes.

## Conventions

- Keep runtime Lua compatible with the target client; do not assume retail-only APIs.
- Put gameplay content in a Patch Dataset, not in UI code.
- Use stable lowercase identifiers such as `resto_shaman:warrior`.
- Every Countermeasure declares an Evidence Status. Confirmed content cites a recorded Source.
- Russian and English keys are added together; English is the fallback.
- No telemetry, combat automation, premium gates, or donation solicitation in the addon UI.
- Tests cross the catalog interface and describe observable behavior rather than implementation details.

