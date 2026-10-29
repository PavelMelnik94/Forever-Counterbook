local ViewerSettingsView = {}

function ViewerSettingsView.Apply(view, settings)
  if not settings then return end
  local values = settings:Get()
  view:SetScale(values.scale)
  view:ClearAllPoints()
  view:SetPoint(values.point, UIParent, values.point, values.x, values.y)
  if view.SetBackdropColor then
    if values.theme == "high_contrast" then view:SetBackdropColor(0, 0, 0, 1)
    elseif values.theme == "colorblind" then view:SetBackdropColor(0.08, 0.12, 0.18, 1)
    else view:SetBackdropColor(0.05, 0.05, 0.05, 0.9) end
  end
end

ForeverCounterbook.ViewerSettingsView = ViewerSettingsView
