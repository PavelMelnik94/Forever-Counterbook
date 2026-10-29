local UISettings = {}

local VALID_LAYOUTS = { book = true, compact = true }
local VALID_THEMES = { default = true, high_contrast = true, colorblind = true }
local VALID_POINTS = { CENTER = true, TOPLEFT = true, TOPRIGHT = true, BOTTOMLEFT = true, BOTTOMRIGHT = true }

local function defaultState()
  return { schemaVersion = 1, layout = "book", scale = 1, point = "CENTER", x = 0, y = 30, theme = "default" }
end

local function valid(state)
  return type(state) == "table" and state.schemaVersion == 1 and VALID_LAYOUTS[state.layout]
    and type(state.scale) == "number" and state.scale >= 0.6 and state.scale <= 1.6
    and VALID_POINTS[state.point] and type(state.x) == "number" and type(state.y) == "number"
    and VALID_THEMES[state.theme]
end

function UISettings.New(storage)
  if type(storage) ~= "table" or type(storage.Load) ~= "function" or type(storage.Save) ~= "function" then
    return nil, { code = "invalid_storage" }
  end
  local state = storage:Load() or defaultState()
  if not valid(state) then return nil, { code = "invalid_ui_settings" } end
  local settings = {}

  function settings:Get()
    return state
  end

  function settings:Update(values)
    local candidate = {
      schemaVersion = 1,
      layout = values.layout or state.layout,
      scale = values.scale or state.scale,
      point = values.point or state.point,
      x = values.x or state.x,
      y = values.y or state.y,
      theme = values.theme or state.theme,
    }
    if not valid(candidate) then return nil, { code = "invalid_ui_settings" } end
    state = candidate
    storage:Save(state)
    return state, nil
  end

  return settings, nil
end

ForeverCounterbook.UISettings = UISettings
