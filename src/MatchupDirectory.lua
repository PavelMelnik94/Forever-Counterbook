local MatchupDirectory = {}

local CYRILLIC_LOWER = {
  ["А"]="а", ["Б"]="б", ["В"]="в", ["Г"]="г", ["Д"]="д", ["Е"]="е", ["Ё"]="ё", ["Ж"]="ж",
  ["З"]="з", ["И"]="и", ["Й"]="й", ["К"]="к", ["Л"]="л", ["М"]="м", ["Н"]="н", ["О"]="о",
  ["П"]="п", ["Р"]="р", ["С"]="с", ["Т"]="т", ["У"]="у", ["Ф"]="ф", ["Х"]="х", ["Ц"]="ц",
  ["Ч"]="ч", ["Ш"]="ш", ["Щ"]="щ", ["Ъ"]="ъ", ["Ы"]="ы", ["Ь"]="ь", ["Э"]="э", ["Ю"]="ю", ["Я"]="я",
}

local function sortedKeys(values)
  local keys = {}
  for key in pairs(values) do table.insert(keys, key) end
  table.sort(keys)
  return keys
end

local function normalize(value)
  if type(value) ~= "string" then return "" end
  local normalized = string.lower(string.gsub(value, "^%s*(.-)%s*$", "%1"))
  for upper, lower in pairs(CYRILLIC_LOWER) do normalized = string.gsub(normalized, upper, lower) end
  return normalized
end

local function termsContain(terms, query)
  for _, term in ipairs(terms or {}) do
    if string.find(normalize(term), query, 1, true) then return true end
  end
  return false
end

local function sourcedTermsContain(terms, query)
  for _, term in ipairs(terms or {}) do
    if string.find(normalize(term.value), query, 1, true) then return true end
  end
  return false
end

function MatchupDirectory.Build(dataset)
  if type(dataset) ~= "table" or type(dataset.profiles) ~= "table" or type(dataset.opponentClasses) ~= "table"
    or type(dataset.matchups) ~= "table" then
    return nil, { code = "invalid_directory_metadata" }
  end
  local catalog, catalogError = ForeverCounterbook.MatchupCatalog.Load(dataset)
  if not catalog then return nil, { code = "invalid_matchup_dataset", cause = catalogError.code } end
  for _, card in pairs(dataset.matchups) do
    for _, group in ipairs({ "abilities", "races" }) do
      local terms = card.searchTerms and card.searchTerms[group] or {}
      for _, term in ipairs(terms) do
        if type(term) ~= "table" or type(term.value) ~= "string" or type(term.sourceId) ~= "string"
          or dataset.sources[term.sourceId] == nil then
          return nil, { code = "search_term_source_missing" }
        end
      end
    end
  end

  local directory = {}

  function directory:Resolve(profileId, opponentClass)
    if dataset.profiles[profileId] == nil then return nil, { code = "unknown_profile" } end
    if dataset.opponentClasses[opponentClass] == nil then return nil, { code = "unknown_opponent_class" } end
    local key = profileId .. ":" .. opponentClass
    return {
      key = key, profileId = profileId, opponentClass = opponentClass,
      status = catalog:GetCard(profileId, opponentClass) and "authored" or "missing",
    }, nil
  end

  function directory:GetInventory(profileId)
    if dataset.profiles[profileId] == nil then return nil, { code = "unknown_profile" } end
    local inventory = { profileId = profileId, total = 0, authored = 0, missing = 0, entries = {} }
    for _, opponentClass in ipairs(sortedKeys(dataset.opponentClasses)) do
      local option = self:Resolve(profileId, opponentClass)
      table.insert(inventory.entries, option)
      inventory.total = inventory.total + 1
      inventory[option.status] = inventory[option.status] + 1
    end
    return inventory, nil
  end

  function directory:Search(query)
    local normalized = normalize(query)
    if normalized == "" then return {} end
    local scope, scopedQuery = string.match(normalized, "^(%a+):(.*)$")
    if scope == "patch" then
      if not string.find(normalize(dataset.patchKey), scopedQuery, 1, true) then return {} end
      local results = {}
      for _, profileId in ipairs(sortedKeys(dataset.profiles)) do
        local inventory = self:GetInventory(profileId)
        for _, option in ipairs(inventory.entries) do table.insert(results, option) end
      end
      return results
    end
    if scope == "ability" or scope == "race" then
      local results = {}
      local termGroup = scope == "ability" and "abilities" or "races"
      for _, key in ipairs(sortedKeys(dataset.matchups)) do
        local card = dataset.matchups[key]
        if card.searchTerms and sourcedTermsContain(card.searchTerms[termGroup], scopedQuery) then
          table.insert(results, {
            key = key, profileId = card.profileId, opponentClass = card.opponentClass, status = "authored",
          })
        end
      end
      return results
    end
    if scope == "class" then
      local results = {}
      for _, opponentClass in ipairs(sortedKeys(dataset.opponentClasses)) do
        if termsContain(dataset.opponentClasses[opponentClass].searchTerms, scopedQuery) then
          for _, profileId in ipairs(sortedKeys(dataset.profiles)) do
            local key = profileId .. ":" .. opponentClass
            table.insert(results, {
              key = key, profileId = profileId, opponentClass = opponentClass,
              status = catalog:GetCard(profileId, opponentClass) and "authored" or "missing",
            })
          end
        end
      end
      return results
    end
    local results = {}
    for _, profileId in ipairs(sortedKeys(dataset.profiles)) do
      local profile = dataset.profiles[profileId]
      if termsContain(profile.searchTerms, normalized) then
        local inventory = self:GetInventory(profileId)
        for _, option in ipairs(inventory.entries) do table.insert(results, option) end
      end
    end
    return results
  end

  return directory, nil
end

ForeverCounterbook.MatchupDirectory = MatchupDirectory
