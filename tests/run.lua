ForeverCounterbook = {}
dofile("src/MatchupCatalog.lua")
dofile("src/MatchupJournal.lua")
dofile("src/SavedVariablesStorage.lua")
dofile("src/PatchIntelligence.lua")
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

test("persists a Matchup Journal note across a reload", function()
  local persisted
  local storage = {
    Load = function() return persisted end,
    Save = function(_, state) persisted = state end,
  }
  local journal = ForeverCounterbook.MatchupJournal.New(storage)
  local entry, err = journal:AddNote("resto_shaman:warrior", "Stop starting a long cast before closing distance.")
  equal(err, nil)
  equal(entry.id, 1)

  local reloaded = ForeverCounterbook.MatchupJournal.New(storage)
  local notes = reloaded:GetNotes("resto_shaman:warrior")
  equal(#notes, 1)
  equal(notes[1].text, "Stop starting a long cast before closing distance.")
  equal(notes[1].matchupKey, "resto_shaman:warrior")
end)

test("SavedVariables adapter restores notes for a new Journal instance", function()
  ForeverCounterbookDB = nil
  local firstStorage = ForeverCounterbook.SavedVariablesStorage.New()
  local firstJournal = ForeverCounterbook.MatchupJournal.New(firstStorage)
  firstJournal:AddNote("resto_shaman:warrior", "Save Grounding Totem for the planned spell.")

  local secondStorage = ForeverCounterbook.SavedVariablesStorage.New()
  local secondJournal = ForeverCounterbook.MatchupJournal.New(secondStorage)
  equal(secondJournal:GetNotes("resto_shaman:warrior")[1].text, "Save Grounding Totem for the planned spell.")
end)

local function patchDataset()
  return {
    schemaVersion = 1,
    datasetRevision = "2026.10.29.1",
    patchKey = "forever-1.60.1-interface-16001",
    supportedClientVersions = { "1.60.1" },
    supportedBuilds = { "12345" },
    supportedInterfaces = { 16001 },
    changesByProfile = {
      resto_shaman = { { textKey = "change_resto", evidence = "confirmed", sourceId = "release" } },
      slsl_warlock = { { textKey = "change_warlock", evidence = "confirmed", sourceId = "release" } },
    },
    sources = { release = { label = "Project release note", kind = "project" } },
  }
end

local function patchRuntime()
  return {
    addonVersion = "0.2.0-dev",
    clientVersion = "1.60.1",
    clientBuild = "12345",
    interfaceVersion = 16001,
  }
end

test("reports current Patch Dataset metadata and profile changes", function()
  local report, err = ForeverCounterbook.PatchIntelligence.Evaluate(patchDataset(), patchRuntime(), "resto_shaman")
  equal(err, nil)
  equal(report.status, "current")
  equal(report.schemaVersion, 1)
  equal(report.datasetRevision, "2026.10.29.1")
  equal(report.addonVersion, "0.2.0-dev")
  equal(report.patchKey, "forever-1.60.1-interface-16001")
  equal(#report.changes, 1)
  equal(report.changes[1].textKey, "change_resto")
end)

test("marks a known interface mismatch as stale", function()
  local runtime = patchRuntime()
  runtime.interfaceVersion = 16002
  local report = ForeverCounterbook.PatchIntelligence.Evaluate(patchDataset(), runtime, "resto_shaman")
  equal(report.status, "stale")
  equal(report.reason, "interface_mismatch")
end)

test("marks missing runtime evidence as unknown", function()
  local report = ForeverCounterbook.PatchIntelligence.Evaluate(patchDataset(), { addonVersion = "0.2.0-dev" }, "resto_shaman")
  equal(report.status, "unknown")
  equal(report.reason, "runtime_evidence_missing")
end)

test("marks a known client build mismatch as stale", function()
  local runtime = patchRuntime()
  runtime.clientBuild = "12346"
  local report = ForeverCounterbook.PatchIntelligence.Evaluate(patchDataset(), runtime, "resto_shaman")
  equal(report.status, "stale")
  equal(report.reason, "build_mismatch")
end)

test("rejects Patch Intelligence metadata that cannot establish applicability", function()
  local input = patchDataset()
  input.datasetRevision = nil
  local report, err = ForeverCounterbook.PatchIntelligence.Evaluate(input, patchRuntime(), "resto_shaman")
  equal(report, nil)
  equal(err.code, "missing_dataset_revision")
end)

test("rejects a Confirmed profile change without a known Source", function()
  local input = patchDataset()
  input.sources = {}
  input.changesByProfile.resto_shaman[1].sourceId = "missing"
  local report, err = ForeverCounterbook.PatchIntelligence.Evaluate(input, patchRuntime(), "resto_shaman")
  equal(report, nil)
  equal(err.code, "confirmed_change_source_missing")
end)

test("rejects missing compatibility declarations instead of guessing stale", function()
  local input = patchDataset()
  input.supportedBuilds = nil
  local report, err = ForeverCounterbook.PatchIntelligence.Evaluate(input, patchRuntime(), "resto_shaman")
  equal(report, nil)
  equal(err.code, "invalid_compatibility_metadata")
end)
print(string.format("%d passed, %d failed", passed, failed)); if failed > 0 then os.exit(1) end

