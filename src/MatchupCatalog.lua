local Catalog = {}

local VALID_EVIDENCE = {
  confirmed = true,
  user = true,
  assumption = true,
}

local function failure(code, path)
  return nil, { code = code, path = path }
end

local function nonEmptyString(value)
  return type(value) == "string" and value ~= ""
end

function Catalog.Load(dataset)
  if type(dataset) ~= "table" then
    return failure("dataset_not_table", "dataset")
  end
  if dataset.schemaVersion ~= 1 then
    return failure("unsupported_schema", "schemaVersion")
  end
  if not nonEmptyString(dataset.patchKey) then
    return failure("missing_patch_key", "patchKey")
  end
  if type(dataset.sources) ~= "table" then
    return failure("missing_sources", "sources")
  end
  if type(dataset.matchups) ~= "table" then
    return failure("missing_matchups", "matchups")
  end

  local cards = {}
  for key, card in pairs(dataset.matchups) do
    local path = "matchups." .. tostring(key)
    if type(card) ~= "table" or not nonEmptyString(card.profileId) or not nonEmptyString(card.opponentClass) then
      return failure("invalid_card_identity", path)
    end
    if type(card.countermeasures) ~= "table" then
      return failure("missing_countermeasures", path .. ".countermeasures")
    end
    for index, item in ipairs(card.countermeasures) do
      local itemPath = path .. ".countermeasures." .. index
      if type(item) ~= "table" or not nonEmptyString(item.textKey) then
        return failure("invalid_countermeasure", itemPath)
      end
      if not VALID_EVIDENCE[item.evidence] then
        return failure("invalid_evidence", itemPath .. ".evidence")
      end
      if item.evidence == "confirmed" and (not nonEmptyString(item.sourceId) or dataset.sources[item.sourceId] == nil) then
        return failure("confirmed_source_missing", itemPath .. ".sourceId")
      end
    end
    local expectedKey = card.profileId .. ":" .. card.opponentClass
    if key ~= expectedKey then
      return failure("card_key_mismatch", path)
    end
    cards[key] = card
  end

  local catalog = { schemaVersion = dataset.schemaVersion, patchKey = dataset.patchKey, cards = cards, sources = dataset.sources }
  function catalog:GetCard(profileId, opponentClass)
    return self.cards[profileId .. ":" .. opponentClass]
  end
  return catalog, nil
end

ForeverCounterbook.MatchupCatalog = Catalog

