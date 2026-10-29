local function joined(values)
  local result = {}
  for index, value in ipairs(values or {}) do result[index] = tostring(value) end
  if next(result) == nil then return ForeverCounterbook.Text("patch_status_not_declared") end
  return table.concat(result, ", ")
end

local function observed(value)
  if value == nil or value == "" then return ForeverCounterbook.Text("patch_status_not_observed") end
  return tostring(value)
end

function ForeverCounterbook.ShowPatchStatus(profileId)
  local report, err = ForeverCounterbook.PatchIntelligence.Evaluate(
    ForeverCounterbook.Data16001,
    ForeverCounterbook.RuntimeInfo.Read(),
    profileId
  )
  if not report then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. err.code); return end

  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_title"))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_schema") .. ": " .. report.schemaVersion)
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_dataset") .. ": " .. report.datasetRevision)
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_patch") .. ": " .. report.patchKey)
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_addon") .. ": " .. report.addonVersion)
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_supported_version") .. ": " .. joined(report.supportedClientVersions))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_supported_build") .. ": " .. joined(report.supportedBuilds))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_supported_interface") .. ": " .. joined(report.supportedInterfaces))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_observed_version") .. ": " .. observed(report.clientVersion))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_observed_build") .. ": " .. observed(report.clientBuild))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_observed_interface") .. ": " .. observed(report.interfaceVersion))
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_result") .. ": " .. ForeverCounterbook.Text("patch_status_" .. report.status))
  if report.status ~= "current" then
    DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_warning") .. " (" .. report.reason .. ")")
  end

  if next(report.changes) == nil then
    DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_no_changes"))
  else
    DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("patch_status_changes"))
    for index, change in ipairs(report.changes) do
      DEFAULT_CHAT_FRAME:AddMessage(index .. ". [" .. ForeverCounterbook.Text("evidence_" .. change.evidence) .. "] " .. ForeverCounterbook.Text(change.textKey))
    end
  end
end
