ForeverCounterbook = {}
dofile("src/MatchupCatalog.lua")
local passed, failed = 0, 0
local function test(name, body)
  local ok, message = pcall(body)
  if ok then passed = passed + 1; print("PASS " .. name) else failed = failed + 1; print("FAIL " .. name .. ": " .. tostring(message)) end
end
local function equal(actual, expected)
  if actual ~= expected then error("expected " .. tostring(expected) .. ", got " .. tostring(actual), 2) end
end
local function dataset()
  return { schemaVersion = 1, patchKey = "forever-1.60.1-interface-16001", sources = { spellbook = { label = "Verified spellbook", kind = "game" } }, matchups = {
    ["resto_shaman:warrior"] = { profileId = "resto_shaman", opponentClass = "warrior", titleKey = "title", countermeasures = {
      { textKey = "counter", evidence = "confirmed", sourceId = "spellbook" },
    } },
  } }
end

test("loads a versioned matchup dataset through the catalog interface", function()
  local catalog, err = ForeverCounterbook.MatchupCatalog.Load(dataset())
  equal(err, nil); equal(catalog.patchKey, "forever-1.60.1-interface-16001"); equal(catalog:GetCard("resto_shaman", "warrior").titleKey, "title")
end)
test("rejects an unsupported schema before exposing cards", function()
  local input = dataset(); input.schemaVersion = 2
  local catalog, err = ForeverCounterbook.MatchupCatalog.Load(input)
  equal(catalog, nil); equal(err.code, "unsupported_schema"); equal(err.path, "schemaVersion")
end)
test("rejects a confirmed countermeasure without a known source", function()
  local input = dataset(); input.matchups["resto_shaman:warrior"].countermeasures[1].sourceId = "missing"
  local catalog, err = ForeverCounterbook.MatchupCatalog.Load(input)
  equal(catalog, nil); equal(err.code, "confirmed_source_missing")
end)
test("keeps assumptions explicit and loadable", function()
  local input = dataset(); input.matchups["resto_shaman:warrior"].countermeasures[1] = { textKey = "hypothesis", evidence = "assumption" }
  local catalog, err = ForeverCounterbook.MatchupCatalog.Load(input)
  equal(err, nil); equal(catalog:GetCard("resto_shaman", "warrior").countermeasures[1].evidence, "assumption")
end)
print(string.format("%d passed, %d failed", passed, failed)); if failed > 0 then os.exit(1) end

