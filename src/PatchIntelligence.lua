local PatchIntelligence = {}

local function contains(values, expected)
  for _, value in ipairs(values or {}) do
    if value == expected then return true end
  end
  return false
end

function PatchIntelligence.Evaluate(dataset, runtime, profileId)
  if type(dataset.datasetRevision) ~= "string" or dataset.datasetRevision == "" then
    return nil, { code = "missing_dataset_revision" }
  end
  if type(dataset.supportedClientVersions) ~= "table" or type(dataset.supportedBuilds) ~= "table"
    or type(dataset.supportedInterfaces) ~= "table" or type(dataset.changesByProfile) ~= "table"
    or type(dataset.sources) ~= "table" then
    return nil, { code = "invalid_compatibility_metadata" }
  end
  local changes = dataset.changesByProfile[profileId] or {}
  for _, change in ipairs(changes) do
    if change.evidence == "confirmed" and (type(change.sourceId) ~= "string" or dataset.sources[change.sourceId] == nil) then
      return nil, { code = "confirmed_change_source_missing" }
    end
  end
  local report = {
    schemaVersion = dataset.schemaVersion,
    datasetRevision = dataset.datasetRevision,
    addonVersion = runtime.addonVersion,
    patchKey = dataset.patchKey,
    supportedClientVersions = dataset.supportedClientVersions,
    supportedBuilds = dataset.supportedBuilds,
    supportedInterfaces = dataset.supportedInterfaces,
    clientVersion = runtime.clientVersion,
    clientBuild = runtime.clientBuild,
    interfaceVersion = runtime.interfaceVersion,
    changes = changes,
  }
  if runtime.clientVersion == nil or runtime.clientBuild == nil or runtime.interfaceVersion == nil then
    report.status = "unknown"
    report.reason = "runtime_evidence_missing"
  elseif not contains(dataset.supportedClientVersions, runtime.clientVersion) then
    report.status = "stale"
    report.reason = "client_version_mismatch"
  elseif not contains(dataset.supportedInterfaces, runtime.interfaceVersion) then
    report.status = "stale"
    report.reason = "interface_mismatch"
  elseif next(dataset.supportedBuilds) == nil then
    report.status = "unknown"
    report.reason = "build_declaration_missing"
  elseif not contains(dataset.supportedBuilds, runtime.clientBuild) then
    report.status = "stale"
    report.reason = "build_mismatch"
  else
    report.status = "current"
  end
  return report, nil
end

ForeverCounterbook.PatchIntelligence = PatchIntelligence
