ForeverCounterbook = {}
dofile("src/MatchupCatalog.lua")
dofile("src/MatchupJournal.lua")
dofile("src/SavedVariablesStorage.lua")
dofile("src/PatchIntelligence.lua")
dofile("src/MatchupDirectory.lua")
dofile("src/PvPBriefing.lua")
dofile("src/BriefingChecklist.lua")
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

local function directoryDataset()
  return {
    schemaVersion = 1,
    patchKey = "forever-1.60.1-interface-16001",
    sources = { spellbook = { label = "Fixture source", kind = "test" } },
    profiles = {
      resto_shaman = { nameKey = "profile_resto_shaman", searchTerms = { "restoration shaman", "шаман исцеление" } },
      arms_warrior = { nameKey = "profile_arms_warrior", searchTerms = { "arms warrior", "воин оружие" } },
    },
    opponentClasses = {
      warrior = { nameKey = "class_warrior", searchTerms = { "warrior", "воин" } },
      mage = { nameKey = "class_mage", searchTerms = { "mage", "маг" } },
    },
    matchups = {
      ["resto_shaman:warrior"] = {
        profileId = "resto_shaman", opponentClass = "warrior", countermeasures = {},
        searchTerms = {
          abilities = {
            { value = "grounding totem", sourceId = "spellbook" },
            { value = "тотем заземления", sourceId = "spellbook" },
          },
          races = {
            { value = "orc", sourceId = "spellbook" },
            { value = "орк", sourceId = "spellbook" },
          },
        },
      },
    },
  }
end

test("declares authored and missing Matchup Options for every profile and opponent", function()
  local directory, err = ForeverCounterbook.MatchupDirectory.Build(directoryDataset())
  equal(err, nil)
  local inventory = directory:GetInventory("resto_shaman")
  equal(inventory.total, 2)
  equal(inventory.authored, 1)
  equal(inventory.missing, 1)
  equal(inventory.entries[1].key, "resto_shaman:mage")
  equal(inventory.entries[1].status, "missing")
  equal(inventory.entries[2].key, "resto_shaman:warrior")
  equal(inventory.entries[2].status, "authored")
end)

test("finds the same profile inventory by English and Russian aliases", function()
  local directory = ForeverCounterbook.MatchupDirectory.Build(directoryDataset())
  local english = directory:Search("restoration shaman")
  local russian = directory:Search("шаман исцеление")
  equal(#english, 2)
  equal(#russian, 2)
  equal(english[1].key, "resto_shaman:mage")
  equal(english[2].key, "resto_shaman:warrior")
  equal(russian[1].key, english[1].key)
  equal(russian[2].key, english[2].key)
  local russianUpper = directory:Search("ШАМАН ИСЦЕЛЕНИЕ")
  equal(russianUpper[1].key, english[1].key)
end)

test("finds every profile option for an opponent class in stable order", function()
  local directory = ForeverCounterbook.MatchupDirectory.Build(directoryDataset())
  local results = directory:Search("class:воин")
  equal(#results, 2)
  equal(results[1].key, "arms_warrior:warrior")
  equal(results[1].status, "missing")
  equal(results[2].key, "resto_shaman:warrior")
  equal(results[2].status, "authored")
end)

test("searches authored ability, race, and patch metadata without inference", function()
  local directory = ForeverCounterbook.MatchupDirectory.Build(directoryDataset())
  equal(directory:Search("ability:тотем заземления")[1].key, "resto_shaman:warrior")
  equal(directory:Search("race:орк")[1].key, "resto_shaman:warrior")
  local patchResults = directory:Search("patch:1.60.1")
  equal(#patchResults, 4)
  equal(patchResults[1].key, "arms_warrior:mage")
  equal(patchResults[4].key, "resto_shaman:warrior")
end)

test("resolves authored and missing options without creating placeholder cards", function()
  local directory = ForeverCounterbook.MatchupDirectory.Build(directoryDataset())
  local authored = directory:Resolve("resto_shaman", "warrior")
  local missing = directory:Resolve("resto_shaman", "mage")
  local unknown, err = directory:Resolve("resto_shaman", "unknown")
  equal(authored.status, "authored")
  equal(missing.status, "missing")
  equal(unknown, nil)
  equal(err.code, "unknown_opponent_class")
end)

test("rejects unsourced ability and race search metadata", function()
  local input = directoryDataset()
  input.matchups["resto_shaman:warrior"].searchTerms.abilities[1].sourceId = "missing"
  local directory, err = ForeverCounterbook.MatchupDirectory.Build(input)
  equal(directory, nil)
  equal(err.code, "search_term_source_missing")
end)

dofile("src/data/16001.lua")
test("bundled content inventory declares six profiles across nine classes", function()
  local directory, err = ForeverCounterbook.MatchupDirectory.Build(ForeverCounterbook.Data16001)
  equal(err, nil)
  local profileIds = {
    "resto_shaman", "enhancement_shaman_leveling", "slsl_warlock",
    "arms_warrior", "resto_druid", "resto_balance_druid",
  }
  local total, authored = 0, 0
  for _, profileId in ipairs(profileIds) do
    local inventory = directory:GetInventory(profileId)
    equal(inventory.total, 9)
    total = total + inventory.total
    authored = authored + inventory.authored
  end
  equal(total, 54)
  equal(authored, 1)
  equal(directory:Search("ability:grounding totem")[1], nil)
  equal(directory:Search("race:orc")[1], nil)
end)

local function briefingDataset()
  return {
    profiles = { resto_shaman = { nameKey = "profile_resto_shaman" } },
    sources = { handbook = { label = "Verified fixture", kind = "test" } },
    briefings = {
      resto_shaman = {
        requirements = {
          gear = { { textKey = "briefing_fixture_gear", evidence = "confirmed", sourceId = "handbook" } },
          trinkets = {}, consumables = {}, reagents = {}, abilities = {},
        },
      },
    },
  }
end

test("builds a profile-aware Briefing that separates authored requirements from checklist items", function()
  local briefing, err = ForeverCounterbook.PvPBriefing.Build(briefingDataset(), "resto_shaman", {
    { id = 1, text = "Repair gear", completed = false },
  })
  equal(err, nil)
  equal(briefing.profileId, "resto_shaman")
  equal(briefing.sections.gear.status, "authored")
  equal(briefing.sections.gear.items[1].textKey, "briefing_fixture_gear")
  equal(briefing.sections.trinkets.status, "not_authored")
  equal(#briefing.checklist, 1)
  equal(briefing.checklist[1].text, "Repair gear")
end)

test("rejects a Confirmed Briefing requirement without a known Source", function()
  local input = briefingDataset()
  input.briefings.resto_shaman.requirements.gear[1].sourceId = "missing"
  local briefing, err = ForeverCounterbook.PvPBriefing.Build(input, "resto_shaman", {})
  equal(briefing, nil)
  equal(err.code, "confirmed_requirement_source_missing")
end)

test("persists private Briefing checklist state per Player Profile", function()
  local persisted
  local storage = {
    Load = function() return persisted end,
    Save = function(_, state) persisted = state end,
  }
  local profiles = { resto_shaman = {}, arms_warrior = {} }
  local checklist = ForeverCounterbook.BriefingChecklist.New(storage, profiles)
  local item, addError = checklist:Add("resto_shaman", "Repair gear")
  equal(addError, nil)
  equal(item.completed, false)
  local toggled, toggleError = checklist:Toggle("resto_shaman", item.id)
  equal(toggleError, nil)
  equal(toggled.completed, true)

  local reloaded = ForeverCounterbook.BriefingChecklist.New(storage, profiles)
  equal(reloaded:GetItems("resto_shaman")[1].completed, true)
  equal(#reloaded:GetItems("arms_warrior"), 0)
end)

test("SavedVariables adapter restores the private Briefing checklist", function()
  ForeverCounterbookDB = nil
  local profiles = { resto_shaman = {} }
  local first = ForeverCounterbook.BriefingChecklist.New(ForeverCounterbook.SavedVariablesStorage.NewBriefingChecklist(), profiles)
  first:Add("resto_shaman", "Bring water")
  local second = ForeverCounterbook.BriefingChecklist.New(ForeverCounterbook.SavedVariablesStorage.NewBriefingChecklist(), profiles)
  equal(second:GetItems("resto_shaman")[1].text, "Bring water")
end)

test("rejects orphan checklist profiles and malformed persisted items", function()
  local persisted
  local storage = { Load = function() return persisted end, Save = function(_, state) persisted = state end }
  local checklist = ForeverCounterbook.BriefingChecklist.New(storage, { resto_shaman = {} })
  local item, err = checklist:Add("unknown_profile", "Orphan item")
  equal(item, nil)
  equal(err.code, "unknown_profile")
  equal(persisted, nil)

  persisted = { schemaVersion = 1, nextId = 2, itemsByProfile = { resto_shaman = { {} } } }
  local invalid, invalidError = ForeverCounterbook.BriefingChecklist.New(storage, { resto_shaman = {} })
  equal(invalid, nil)
  equal(invalidError.code, "invalid_checklist_state")

  persisted = {
    schemaVersion = 1, nextId = 1,
    itemsByProfile = { resto_shaman = { [2] = { id = 1, text = "Gap", completed = false } } },
  }
  local sparse, sparseError = ForeverCounterbook.BriefingChecklist.New(storage, { resto_shaman = {} })
  equal(sparse, nil)
  equal(sparseError.code, "invalid_checklist_state")

  persisted = {
    schemaVersion = 1, nextId = 1,
    itemsByProfile = { resto_shaman = { { id = 1, text = "Duplicate next id", completed = false } } },
  }
  local duplicate, duplicateError = ForeverCounterbook.BriefingChecklist.New(storage, { resto_shaman = {} })
  equal(duplicate, nil)
  equal(duplicateError.code, "invalid_checklist_state")
end)

test("rejects malformed authored Briefing requirements", function()
  local input = briefingDataset()
  input.briefings.resto_shaman.requirements.gear[1].textKey = nil
  local briefing, err = ForeverCounterbook.PvPBriefing.Build(input, "resto_shaman", {})
  equal(briefing, nil)
  equal(err.code, "invalid_requirement")

  input = briefingDataset()
  input.briefings.resto_shaman.requirements.gear = { unexpected = { textKey = "bad", evidence = "assumption" } }
  local invalidContainer, containerError = ForeverCounterbook.PvPBriefing.Build(input, "resto_shaman", {})
  equal(invalidContainer, nil)
  equal(containerError.code, "invalid_requirement_container")
end)

test("bundled Briefings stay explicitly not authored for all active profiles", function()
  for profileId in pairs(ForeverCounterbook.Data16001.profiles) do
    local briefing, err = ForeverCounterbook.PvPBriefing.Build(ForeverCounterbook.Data16001, profileId, {})
    equal(err, nil)
    for _, sectionId in ipairs({ "gear", "trinkets", "consumables", "reagents", "abilities" }) do
      equal(briefing.sections[sectionId].status, "not_authored")
    end
  end
end)

print(string.format("%d passed, %d failed", passed, failed)); if failed > 0 then os.exit(1) end

