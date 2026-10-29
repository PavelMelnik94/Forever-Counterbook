local BriefingChecklist = {}

local function emptyState()
  return { schemaVersion = 1, nextId = 1, itemsByProfile = {} }
end

local function validText(value)
  return type(value) == "string" and string.find(value, "%S") ~= nil
end

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

function BriefingChecklist.New(storage, profiles)
  if type(storage) ~= "table" or type(storage.Load) ~= "function" or type(storage.Save) ~= "function" then
    return nil, { code = "invalid_storage" }
  end
  if type(profiles) ~= "table" then return nil, { code = "invalid_profiles" } end
  local state = storage:Load() or emptyState()
  if state.schemaVersion ~= 1 or type(state.itemsByProfile) ~= "table" or type(state.nextId) ~= "number"
    or state.nextId < 1 or state.nextId ~= math.floor(state.nextId) then
    return nil, { code = "invalid_checklist_state" }
  end
  local seenIds, maximumId = {}, 0
  for profileId, items in pairs(state.itemsByProfile) do
    if profiles[profileId] == nil or not isDenseArray(items) then return nil, { code = "invalid_checklist_state" } end
    for _, item in ipairs(items) do
      if type(item) ~= "table" or type(item.id) ~= "number" or item.id < 1 or item.id ~= math.floor(item.id)
        or seenIds[item.id] or not validText(item.text) or type(item.completed) ~= "boolean" then
        return nil, { code = "invalid_checklist_state" }
      end
      seenIds[item.id] = true
      if item.id > maximumId then maximumId = item.id end
    end
  end
  if state.nextId <= maximumId then return nil, { code = "invalid_checklist_state" } end
  local checklist = {}

  function checklist:GetItems(profileId)
    return state.itemsByProfile[profileId] or {}
  end

  function checklist:Add(profileId, text)
    if profiles[profileId] == nil then return nil, { code = "unknown_profile" } end
    if not validText(text) then return nil, { code = "empty_checklist_item" } end
    local item = { id = state.nextId, text = text, completed = false }
    state.nextId = state.nextId + 1
    state.itemsByProfile[profileId] = state.itemsByProfile[profileId] or {}
    table.insert(state.itemsByProfile[profileId], item)
    storage:Save(state)
    return item, nil
  end

  function checklist:Toggle(profileId, itemId)
    for _, item in ipairs(self:GetItems(profileId)) do
      if item.id == itemId then
        item.completed = not item.completed
        storage:Save(state)
        return item, nil
      end
    end
    return nil, { code = "checklist_item_not_found" }
  end

  return checklist, nil
end

ForeverCounterbook.BriefingChecklist = BriefingChecklist
