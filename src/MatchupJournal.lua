local MatchupJournal = {}
local MAX_PAYLOAD_BYTES = 65535
local MAX_ENTRIES = 1000
local MAX_MATCHUP_KEY_BYTES = 128
local MAX_NOTE_BYTES = 4096

local function emptyState()
  return { schemaVersion = 1, nextId = 1, entries = {} }
end

local function isNonEmptyString(value)
  return type(value) == "string" and string.find(value, "%S") ~= nil
end

local function isValidMatchupKey(value)
  return isNonEmptyString(value) and string.len(value) <= MAX_MATCHUP_KEY_BYTES
    and string.match(value, "^[a-z0-9_]+:[a-z0-9_]+$") ~= nil
end

local function isValidNote(value)
  if not isNonEmptyString(value) or string.len(value) > MAX_NOTE_BYTES then return false end
  for index = 1, string.len(value) do
    local byte = string.byte(value, index)
    if (byte < 32 and byte ~= 9 and byte ~= 10 and byte ~= 13) or byte == 127 then return false end
  end
  return true
end

local function hexEncode(value)
  local result = {}
  for index = 1, string.len(value) do
    table.insert(result, string.format("%02X", string.byte(value, index)))
  end
  return table.concat(result)
end

local function hexDecode(value)
  if type(value) ~= "string" or string.len(value) == 0 or string.len(value) % 2 ~= 0
    or string.find(value, "[^0-9A-F]") then return nil end
  local result = {}
  for index = 1, string.len(value), 2 do
    table.insert(result, string.char(tonumber(string.sub(value, index, index + 1), 16)))
  end
  return table.concat(result)
end

local function normalizeNote(text)
  local normalized = string.gsub(text, "\r\n", "\n")
  normalized = string.gsub(normalized, "%s+", " ")
  return string.match(normalized, "^%s*(.-)%s*$")
end

local function copyEntry(entry)
  return { id = entry.id, matchupKey = entry.matchupKey, text = entry.text }
end

local function copySummary(summary)
  return {
    mode = summary.mode, existingCount = summary.existingCount, incomingCount = summary.incomingCount,
    addedCount = summary.addedCount, duplicateCount = summary.duplicateCount,
    resultingCount = summary.resultingCount,
  }
end

local function parsePayload(payload)
  if type(payload) ~= "string" then return nil, { code = "invalid_journal_import" } end
  if string.len(payload) > MAX_PAYLOAD_BYTES then return nil, { code = "journal_import_too_large" } end
  local normalized = string.gsub(payload, "\r\n", "\n")
  if string.find(normalized, "\r", 1, true) then return nil, { code = "invalid_journal_import" } end
  if string.sub(normalized, -1) == "\n" then normalized = string.sub(normalized, 1, -2) end
  local lines = {}
  for line in string.gmatch(normalized .. "\n", "([^\n]*)\n") do table.insert(lines, line) end
  if lines[1] ~= "FCBJ1" then return nil, { code = "unsupported_journal_import" } end
  local entries = {}
  for index = 2, #lines do
    local encodedKey, encodedText = string.match(lines[index], "^([0-9A-F]+)|([0-9A-F]+)$")
    local matchupKey, text = hexDecode(encodedKey), hexDecode(encodedText)
    if not matchupKey or not text or not isValidMatchupKey(matchupKey) or not isValidNote(text) then
      return nil, { code = "invalid_journal_import" }
    end
    table.insert(entries, { matchupKey = matchupKey, text = text })
    if #entries > MAX_ENTRIES then return nil, { code = "journal_import_too_many_entries" } end
  end
  return entries, nil
end


local function validState(state)
  if type(state) ~= "table" or state.schemaVersion ~= 1
    or type(state.nextId) ~= "number" or state.nextId < 1 or state.nextId ~= math.floor(state.nextId)
    or type(state.entries) ~= "table" or #state.entries > MAX_ENTRIES then return false end
  local seen, count, maxId = {}, 0, 0
  for index, entry in ipairs(state.entries) do
    if type(entry) ~= "table" or type(entry.id) ~= "number" or entry.id < 1
      or entry.id ~= math.floor(entry.id) or seen[entry.id]
      or not isValidMatchupKey(entry.matchupKey) or not isValidNote(entry.text) then return false end
    seen[entry.id] = true
    count = index
    if entry.id > maxId then maxId = entry.id end
  end
  for key in pairs(state.entries) do
    if type(key) ~= "number" or key < 1 or key > count or key ~= math.floor(key) then return false end
  end
  return state.nextId > maxId
end

function MatchupJournal.New(storage)
  if type(storage) ~= "table" or type(storage.Load) ~= "function" or type(storage.Save) ~= "function" then
    return nil, { code = "invalid_storage" }
  end

  local stored = storage:Load()
  local state = stored or emptyState()
  local journal = {}
  local pendingState, pendingSummary

  function journal:AddNote(matchupKey, text)
    if not isValidMatchupKey(matchupKey) then return nil, { code = "invalid_matchup_key" } end
    if not isValidNote(text) then return nil, { code = "invalid_note" } end
    local entry = { id = state.nextId, matchupKey = matchupKey, text = text }
    state.nextId = state.nextId + 1
    table.insert(state.entries, entry)
    pendingState, pendingSummary = nil, nil
    storage:Save(state)
    return copyEntry(entry), nil
  end

  function journal:GetNotes(matchupKey)
    local result = {}
    for _, entry in ipairs(state.entries) do
      if entry.matchupKey == matchupKey then table.insert(result, copyEntry(entry)) end
    end
    return result
  end

  function journal:Export()
    if not validState(state) then return nil, { code = "invalid_journal_state" } end
    local lines = { "FCBJ1" }
    for _, entry in ipairs(state.entries) do
      table.insert(lines, hexEncode(entry.matchupKey) .. "|" .. hexEncode(entry.text))
    end
    local payload = table.concat(lines, "\n")
    if string.len(payload) > MAX_PAYLOAD_BYTES then return nil, { code = "journal_export_too_large" } end
    return payload, nil
  end

  function journal:PreviewImport(payload, mode)
    pendingState, pendingSummary = nil, nil
    if mode ~= "merge" and mode ~= "replace" then return nil, { code = "invalid_import_mode" } end
    if not validState(state) then return nil, { code = "invalid_journal_state" } end
    local incoming, err = parsePayload(payload)
    if not incoming then return nil, err end
    local candidate = { schemaVersion = 1, nextId = 1, entries = {} }
    local seen = {}
    if mode == "merge" then
      candidate.nextId = state.nextId
      for _, entry in ipairs(state.entries) do
        local copied = copyEntry(entry)
        table.insert(candidate.entries, copied)
        seen[copied.matchupKey .. "\n" .. normalizeNote(copied.text)] = true
      end
    end
    local duplicateCount, addedCount = 0, 0
    for _, incomingEntry in ipairs(incoming) do
      local identity = incomingEntry.matchupKey .. "\n" .. normalizeNote(incomingEntry.text)
      if seen[identity] then
        duplicateCount = duplicateCount + 1
      else
        local entry = {
          id = candidate.nextId, matchupKey = incomingEntry.matchupKey, text = incomingEntry.text,
        }
        candidate.nextId = candidate.nextId + 1
        table.insert(candidate.entries, entry)
        seen[identity] = true
        addedCount = addedCount + 1
      end
    end
    if #candidate.entries > MAX_ENTRIES then return nil, { code = "journal_import_too_many_entries" } end
    pendingState = candidate
    pendingSummary = {
      mode = mode, existingCount = #state.entries, incomingCount = #incoming,
      addedCount = addedCount, duplicateCount = duplicateCount,
      resultingCount = #candidate.entries,
    }
    return copySummary(pendingSummary), nil
  end

  function journal:ApplyImport()
    if not pendingState then return nil, { code = "no_pending_journal_import" } end
    state = pendingState
    local summary = copySummary(pendingSummary)
    pendingState, pendingSummary = nil, nil
    storage:Save(state)
    return summary, nil
  end

  function journal:CancelImport()
    pendingState, pendingSummary = nil, nil
  end

  return journal, nil
end

ForeverCounterbook.MatchupJournal = MatchupJournal
