local SavedVariablesStorage = {}

function SavedVariablesStorage.New()
  ForeverCounterbookDB = ForeverCounterbookDB or {}
  local storage = {}

  function storage:Load()
    return ForeverCounterbookDB.journal
  end

  function storage:Save(state)
    ForeverCounterbookDB.journal = state
  end

  return storage
end

ForeverCounterbook.SavedVariablesStorage = SavedVariablesStorage
