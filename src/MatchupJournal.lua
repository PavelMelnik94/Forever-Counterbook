local MatchupJournal = {}

local function emptyState()
  return { schemaVersion = 1, nextId = 1, entries = {} }
end

local function isNonEmptyString(value)
  return type(value) == "string" and string.find(value, "%S") ~= nil
end

function MatchupJournal.New(storage)
  if type(storage) ~= "table" or type(storage.Load) ~= "function" or type(storage.Save) ~= "function" then
    return nil, { code = "invalid_storage" }
  end

  local stored = storage:Load()
  local state = stored or emptyState()
  local journal = {}

  function journal:AddNote(matchupKey, text)
    if not isNonEmptyString(matchupKey) then return nil, { code = "invalid_matchup_key" } end
    if not isNonEmptyString(text) then return nil, { code = "empty_note" } end
    local entry = { id = state.nextId, matchupKey = matchupKey, text = text }
    state.nextId = state.nextId + 1
    table.insert(state.entries, entry)
    storage:Save(state)
    return entry, nil
  end

  function journal:GetNotes(matchupKey)
    local result = {}
    for _, entry in ipairs(state.entries) do
      if entry.matchupKey == matchupKey then table.insert(result, entry) end
    end
    return result
  end

  return journal, nil
end

ForeverCounterbook.MatchupJournal = MatchupJournal
