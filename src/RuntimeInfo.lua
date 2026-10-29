local RuntimeInfo = {}

function RuntimeInfo.Read()
  local runtime = { addonVersion = ForeverCounterbook.VERSION }
  if type(GetBuildInfo) == "function" then
    local ok, clientVersion, clientBuild, _, interfaceVersion = pcall(GetBuildInfo)
    if ok then
      runtime.clientVersion = clientVersion
      runtime.clientBuild = clientBuild
      runtime.interfaceVersion = tonumber(interfaceVersion)
    end
  end
  return runtime
end

ForeverCounterbook.RuntimeInfo = RuntimeInfo
