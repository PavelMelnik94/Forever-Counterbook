local Diagnostics = {}
local ERROR_KEYS = { "catalog", "directory", "checklist", "uiSettings", "encounterHistory" }

function Diagnostics.Build(context)
  local errors = {}
  local suppliedErrors = context.errors or {}
  for _, key in ipairs(ERROR_KEYS) do
    local value = suppliedErrors[key]
    if type(value) == "string" and string.match(value, "^[%w_%-]+$") then errors[key] = value end
  end
  return {
    addonVersion = context.addonVersion,
    schemaVersion = context.schemaVersion,
    datasetRevision = context.datasetRevision,
    patchKey = context.patchKey,
    patchStatus = context.patchStatus,
    patchReason = context.patchReason,
    clientVersion = context.clientVersion,
    clientBuild = context.clientBuild,
    interfaceVersion = context.interfaceVersion,
    errors = errors,
  }
end

ForeverCounterbook.Diagnostics = Diagnostics
