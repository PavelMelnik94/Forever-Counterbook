local directory, directoryError = ForeverCounterbook.MatchupDirectory.Build(ForeverCounterbook.Data16001)
ForeverCounterbook.Directory = directory
ForeverCounterbook.DirectoryError = directoryError
local checklist, checklistError = ForeverCounterbook.BriefingChecklist.New(
  ForeverCounterbook.SavedVariablesStorage.NewBriefingChecklist(),
  ForeverCounterbook.Data16001.profiles
)
ForeverCounterbook.BriefingChecklistState = checklist
ForeverCounterbook.BriefingChecklistError = checklistError

local frame
local optionButtons = {}
local activeProfile = "resto_shaman"
local currentOptions = {}
local currentPage = 1
local PAGE_SIZE = 9
local selectedOption

local function appendBriefing(lines, profileId)
  local briefing, err = ForeverCounterbook.PvPBriefing.Build(
    ForeverCounterbook.Data16001,
    profileId,
    checklist and checklist:GetItems(profileId) or {}
  )
  table.insert(lines, "\n" .. ForeverCounterbook.Text("briefing_title") .. ":")
  if not briefing then table.insert(lines, "Forever Counterbook: " .. err.code); return end
  for _, sectionId in ipairs({ "gear", "trinkets", "consumables", "reagents", "abilities" }) do
    local section = briefing.sections[sectionId]
    table.insert(lines, ForeverCounterbook.Text("briefing_" .. sectionId) .. ":")
    if section.status == "not_authored" then
      table.insert(lines, "- " .. ForeverCounterbook.Text("book_not_authored"))
    else
      for _, item in ipairs(section.items) do
        local source = item.sourceId and ForeverCounterbook.Data16001.sources[item.sourceId]
        local sourceLabel = source and (" — " .. source.label) or ""
        table.insert(lines, "- [" .. ForeverCounterbook.Text("evidence_" .. item.evidence) .. "] " .. ForeverCounterbook.Text(item.textKey) .. sourceLabel)
      end
    end
  end
  table.insert(lines, ForeverCounterbook.Text("briefing_private_checklist") .. ":")
  if next(briefing.checklist) == nil then table.insert(lines, "- " .. ForeverCounterbook.Text("briefing_checklist_empty")) end
  for _, item in ipairs(briefing.checklist) do
    local marker = item.completed and "[x]" or "[ ]"
    table.insert(lines, marker .. " #" .. item.id .. " " .. item.text)
  end
end

local function labelForProfile(profileId)
  local profile = ForeverCounterbook.Data16001.profiles[profileId]
  return profile and ForeverCounterbook.Text(profile.nameKey) or profileId
end

local function labelForClass(classId)
  local class = ForeverCounterbook.Data16001.opponentClasses[classId]
  return class and ForeverCounterbook.Text(class.nameKey) or classId
end

local function makeButton(parent, width, height)
  local button = CreateFrame("Button", nil, parent)
  button:SetWidth(width); button:SetHeight(height)
  button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  button.text:SetAllPoints(button); button.text:SetJustifyH("LEFT")
  return button
end

local function ensureFrame()
  if frame then return frame end
  frame = CreateFrame("Frame", "ForeverCounterbookMatchupBook", UIParent)
  frame:SetWidth(800); frame:SetHeight(520); frame:SetPoint("CENTER", UIParent, "CENTER", 0, 30)
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function() frame:StartMoving() end)
  frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
  if frame.SetBackdrop then frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 24, insets = { left = 6, right = 6, top = 6, bottom = 6 } }) end

  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -18); frame.title:SetText(ForeverCounterbook.Text("book_title"))
  frame.profileLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.profileLabel:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -12)
  frame.profileLabel:SetText(ForeverCounterbook.Text("book_profile"))
  frame.profileInput = CreateFrame("EditBox", nil, frame)
  frame.profileInput:SetWidth(170); frame.profileInput:SetHeight(24); frame.profileInput:SetPoint("LEFT", frame.profileLabel, "RIGHT", 10, 0)
  frame.profileInput:SetFontObject(GameFontHighlight); frame.profileInput:SetAutoFocus(false)
  frame.profileButton = makeButton(frame, 55, 24); frame.profileButton:SetPoint("LEFT", frame.profileInput, "RIGHT", 8, 0)
  frame.profileButton.text:SetText(ForeverCounterbook.Text("book_load_profile"))

  frame.search = CreateFrame("EditBox", nil, frame)
  frame.search:SetWidth(190); frame.search:SetHeight(24); frame.search:SetPoint("TOPLEFT", frame, "TOPLEFT", 500, -48)
  frame.search:SetFontObject(GameFontHighlight); frame.search:SetAutoFocus(false)
  frame.searchButton = makeButton(frame, 80, 24); frame.searchButton:SetPoint("LEFT", frame.search, "RIGHT", 8, 0)
  frame.searchButton.text:SetText(ForeverCounterbook.Text("book_search_button"))

  frame.leftTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.leftTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -88); frame.leftTitle:SetText(ForeverCounterbook.Text("book_inventory"))
  for index = 1, PAGE_SIZE do
    local button = makeButton(frame, 250, 32)
    button:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -90 - index * 36)
    optionButtons[index] = button
  end
  frame.previousButton = makeButton(frame, 70, 24); frame.previousButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 22)
  frame.previousButton.text:SetText(ForeverCounterbook.Text("book_previous"))
  frame.nextButton = makeButton(frame, 70, 24); frame.nextButton:SetPoint("LEFT", frame.previousButton, "RIGHT", 110, 0)
  frame.nextButton.text:SetText(ForeverCounterbook.Text("book_next"))
  frame.pageText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.pageText:SetPoint("LEFT", frame.previousButton, "RIGHT", 10, 0)

  frame.cardTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.cardTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 300, -92)
  frame.cardBody = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.cardBody:SetPoint("TOPLEFT", frame.cardTitle, "BOTTOMLEFT", 0, -14); frame.cardBody:SetWidth(470)
  frame.cardBody:SetJustifyH("LEFT"); frame.cardBody:SetJustifyV("TOP")
  frame.cardBody:SetText(ForeverCounterbook.Text("book_open_hint"))
  frame:Hide()
  return frame
end

local function renderOption(option)
  selectedOption = option
  local view = ensureFrame()
  view.cardTitle:SetText(labelForProfile(option.profileId) .. " vs " .. labelForClass(option.opponentClass))
  if option.status == "missing" then
    local missingLines = {
      ForeverCounterbook.Text("book_not_authored"),
      "\n" .. ForeverCounterbook.Text("patch_status_dataset") .. ": " .. ForeverCounterbook.Data16001.datasetRevision,
    }
    appendBriefing(missingLines, option.profileId)
    view.cardBody:SetText(table.concat(missingLines, "\n"))
    return
  end

  local card = ForeverCounterbook.Catalog:GetCard(option.profileId, option.opponentClass)
  local lines = {
    ForeverCounterbook.Text("book_plan") .. ":",
  }
  for index, item in ipairs(card.countermeasures or {}) do
    table.insert(lines, index .. ". [" .. ForeverCounterbook.Text("evidence_" .. item.evidence) .. "] " .. ForeverCounterbook.Text(item.textKey))
  end
  table.insert(lines, "\n" .. ForeverCounterbook.Text("book_dangers") .. ": " .. ForeverCounterbook.Text("book_not_authored"))
  table.insert(lines, ForeverCounterbook.Text("book_windows") .. ": " .. ForeverCounterbook.Text("book_not_authored"))
  local patchReport, patchError = ForeverCounterbook.PatchIntelligence.Evaluate(ForeverCounterbook.Data16001, ForeverCounterbook.RuntimeInfo.Read(), option.profileId)
  table.insert(lines, "\n" .. ForeverCounterbook.Text("book_sources") .. ":")
  if patchReport then
    table.insert(lines, ForeverCounterbook.Data16001.patchKey .. " / " .. ForeverCounterbook.Data16001.datasetRevision .. " / " .. ForeverCounterbook.Text("patch_status_" .. patchReport.status))
  else
    table.insert(lines, ForeverCounterbook.Data16001.patchKey .. " / " .. ForeverCounterbook.Text("patch_status_unknown") .. " (" .. patchError.code .. ")")
  end
  local sourceCount = 0
  for _, item in ipairs(card.countermeasures or {}) do
    if item.sourceId and ForeverCounterbook.Data16001.sources[item.sourceId] then
      sourceCount = sourceCount + 1
      table.insert(lines, "- " .. ForeverCounterbook.Data16001.sources[item.sourceId].label)
    end
  end
  if sourceCount == 0 then table.insert(lines, ForeverCounterbook.Text("book_no_confirmed_sources")) end
  table.insert(lines, "\n" .. ForeverCounterbook.Text("book_personal_notes") .. ":")
  local notes = ForeverCounterbook.Journal:GetNotes(option.key)
  if next(notes) == nil then table.insert(lines, ForeverCounterbook.Text("journal_no_notes")) end
  for index, note in ipairs(notes) do table.insert(lines, index .. ". " .. note.text) end
  appendBriefing(lines, option.profileId)
  view.cardBody:SetText(table.concat(lines, "\n"))
end

local function showOptions(options, page)
  local view = ensureFrame()
  currentOptions = options
  currentPage = page or 1
  local optionCount = 0
  for _ in ipairs(options) do optionCount = optionCount + 1 end
  local pageCount = math.max(1, math.ceil(optionCount / PAGE_SIZE))
  if currentPage > pageCount then currentPage = pageCount end
  local startIndex = (currentPage - 1) * PAGE_SIZE + 1
  for index, button in ipairs(optionButtons) do
    local option = options[startIndex + index - 1]
    if option then
      local selectedOption = option
      local marker = option.status == "authored" and ForeverCounterbook.Text("book_authored") or ForeverCounterbook.Text("book_not_authored")
      button.text:SetText(labelForProfile(option.profileId) .. " — " .. labelForClass(option.opponentClass) .. " [" .. marker .. "]")
      button:SetScript("OnClick", function() renderOption(selectedOption) end); button:Show()
    else
      button:Hide()
    end
  end
  if next(options) == nil then view.cardBody:SetText(ForeverCounterbook.Text("book_no_results")) end
  view.pageText:SetText(ForeverCounterbook.Text("book_page") .. " " .. currentPage .. "/" .. pageCount)
  view.previousButton:SetScript("OnClick", function() if currentPage > 1 then showOptions(currentOptions, currentPage - 1) end end)
  view.nextButton:SetScript("OnClick", function() if currentPage < pageCount then showOptions(currentOptions, currentPage + 1) end end)
end

function ForeverCounterbook.ShowMatchupBook(profileId)
  local view = ensureFrame()
  activeProfile = profileId or activeProfile
  local inventory, err = directory:GetInventory(activeProfile)
  if not inventory then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. err.code); return end
  view.profileInput:SetText(activeProfile)
  view.profileButton:SetScript("OnClick", function() ForeverCounterbook.ShowMatchupBook(view.profileInput:GetText()) end)
  view.searchButton:SetScript("OnClick", function() showOptions(directory:Search(view.search:GetText()), 1) end)
  showOptions(inventory.entries, 1); view:Show()
end

function ForeverCounterbook.ShowMatchupSearch(query)
  local view = ensureFrame(); view.search:SetText(query); view.profileInput:SetText(ForeverCounterbook.Text("book_all_profiles")); showOptions(directory:Search(query), 1); view:Show()
end

function ForeverCounterbook.OpenMatchupOption(profileId, opponentClass)
  local option, err = directory:Resolve(profileId, opponentClass)
  if not option then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. err.code); return end
  ForeverCounterbook.ShowMatchupBook(profileId); renderOption(option)
end

function ForeverCounterbook.AddBriefingChecklistItem(profileId, text)
  if not checklist then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. checklistError.code); return end
  local _, err = checklist:Add(profileId, text)
  if err then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. err.code); return end
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("briefing_item_added"))
  if selectedOption and selectedOption.profileId == profileId then renderOption(selectedOption) end
end

function ForeverCounterbook.ToggleBriefingChecklistItem(profileId, itemId)
  if not checklist then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. checklistError.code); return end
  local _, err = checklist:Toggle(profileId, itemId)
  if err then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. err.code); return end
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("briefing_item_toggled"))
  if selectedOption and selectedOption.profileId == profileId then renderOption(selectedOption) end
end
