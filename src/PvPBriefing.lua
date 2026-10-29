local PvPBriefing = {}

local SECTION_IDS = { "gear", "trinkets", "consumables", "reagents", "abilities" }

local function isDenseArray(values)
  if type(values) ~= "table" then return false end
  local count, maximum = 0, 0
  for key in pairs(values) do
    if type(key) ~= "number" or key < 1 or key ~= math.floor(key) then return false end
    count = count + 1
    if key > maximum then maximum = key end
  end
  return maximum == count
end

function PvPBriefing.Build(dataset, profileId, checklistItems)
  if type(dataset) ~= "table" or type(dataset.profiles) ~= "table" or dataset.profiles[profileId] == nil then
    return nil, { code = "unknown_profile" }
  end
  local authored = dataset.briefings and dataset.briefings[profileId]
  if authored ~= nil and (type(authored) ~= "table" or type(authored.requirements) ~= "table") then
    return nil, { code = "invalid_requirement_container" }
  end
  local requirements = authored and authored.requirements or {}
  local briefing = { profileId = profileId, sections = {}, checklist = checklistItems or {} }
  for _, sectionId in ipairs(SECTION_IDS) do
    local items = requirements[sectionId] or {}
    if not isDenseArray(items) then return nil, { code = "invalid_requirement_container" } end
    for _, item in ipairs(items) do
      if type(item) ~= "table" or type(item.textKey) ~= "string" or item.textKey == "" then
        return nil, { code = "invalid_requirement" }
      end
      if item.evidence ~= "confirmed" and item.evidence ~= "assumption" then
        return nil, { code = "invalid_requirement_evidence" }
      end
      if item.evidence == "confirmed" and (type(item.sourceId) ~= "string" or not dataset.sources or dataset.sources[item.sourceId] == nil) then
        return nil, { code = "confirmed_requirement_source_missing" }
      end
    end
    briefing.sections[sectionId] = {
      id = sectionId,
      status = next(items) and "authored" or "not_authored",
      items = items,
    }
  end
  return briefing, nil
end

ForeverCounterbook.PvPBriefing = PvPBriefing
