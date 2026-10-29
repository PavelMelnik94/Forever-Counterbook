local EncounterHistory = {}
local RESULTS = { win = true, loss = true }
local TAGS = {
  positioning = true, consumables = true, cc = true,
  dispel = true, cooldown = true, target_choice = true,
}

local function emptyState()
  return { schemaVersion = 1, nextId = 1, entries = {} }
end

local function isNonEmptyString(value)
  return type(value) == "string" and string.find(value, "%S") ~= nil
end

local function validTags(tags)
  if type(tags) ~= "table" or next(tags) == nil then return false end
  local seen, count = {}, 0
  for index, tag in ipairs(tags) do
    if not TAGS[tag] or seen[tag] then return false end
    seen[tag] = true
    count = index
  end
  for key in pairs(tags) do
    if type(key) ~= "number" or key < 1 or key > count or key ~= math.floor(key) then return false end
  end
  return true
end

local function validEntry(entry)
  return type(entry) == "table"
    and type(entry.id) == "number" and entry.id >= 1 and entry.id == math.floor(entry.id)
    and isNonEmptyString(entry.matchupKey) and RESULTS[entry.result]
    and isNonEmptyString(entry.cause) and validTags(entry.tags) and isNonEmptyString(entry.note)
end

local function validState(state)
  if type(state) ~= "table" or state.schemaVersion ~= 1
    or type(state.nextId) ~= "number" or state.nextId < 1 or state.nextId ~= math.floor(state.nextId)
    or type(state.entries) ~= "table" then return false end
  local seen, count, maxId = {}, 0, 0
  for index, entry in ipairs(state.entries) do
    if not validEntry(entry) or seen[entry.id] then return false end
    seen[entry.id] = true
    count = index
    if entry.id > maxId then maxId = entry.id end
  end
  for key in pairs(state.entries) do
    if type(key) ~= "number" or key < 1 or key > count or key ~= math.floor(key) then return false end
  end
  return state.nextId > maxId
end

local function copyTags(tags)
  local result = {}
  for _, tag in ipairs(tags) do table.insert(result, tag) end
  return result
end

local function copyEntry(entry)
  return {
    id = entry.id, matchupKey = entry.matchupKey, result = entry.result,
    cause = entry.cause, tags = copyTags(entry.tags), note = entry.note,
  }
end

function EncounterHistory.New(storage)
  if type(storage) ~= "table" or type(storage.Load) ~= "function" or type(storage.Save) ~= "function" then
    return nil, { code = "invalid_storage" }
  end
  local state = storage:Load() or emptyState()
  if not validState(state) then return nil, { code = "invalid_encounter_history_state" } end
  local history = {}

  function history:Record(matchupKey, result, cause, tags, note)
    if not isNonEmptyString(matchupKey) then return nil, { code = "invalid_matchup_key" } end
    if not RESULTS[result] then return nil, { code = "invalid_encounter_result" } end
    if not isNonEmptyString(cause) then return nil, { code = "invalid_encounter_cause" } end
    if not validTags(tags) then return nil, { code = "invalid_mistake_tags" } end
    if not isNonEmptyString(note) then return nil, { code = "invalid_encounter_note" } end
    local entry = {
      id = state.nextId, matchupKey = matchupKey, result = result,
      cause = cause, tags = copyTags(tags), note = note,
    }
    state.nextId = state.nextId + 1
    table.insert(state.entries, entry)
    storage:Save(state)
    return copyEntry(entry), nil
  end

  function history:List(matchupKey)
    local result = {}
    for _, entry in ipairs(state.entries) do
      if entry.matchupKey == matchupKey then table.insert(result, copyEntry(entry)) end
    end
    return result
  end

  return history, nil
end

ForeverCounterbook.EncounterHistory = EncounterHistory
