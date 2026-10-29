local SavedVariablesStorage = {}

local function newStorage(key)
  ForeverCounterbookDB = ForeverCounterbookDB or {}
  local storage = {}

  function storage:Load()
    return ForeverCounterbookDB[key]
  end

  function storage:Save(state)
    ForeverCounterbookDB[key] = state
  end

  return storage
end

function SavedVariablesStorage.New()
  return newStorage("journal")
end

function SavedVariablesStorage.NewBriefingChecklist()
  return newStorage("briefingChecklist")
end

function SavedVariablesStorage.NewUISettings()
  return newStorage("uiSettings")
end

ForeverCounterbook.SavedVariablesStorage = SavedVariablesStorage
