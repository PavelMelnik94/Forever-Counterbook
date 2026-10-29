local frame
local editor
local suppressTextChanged = false

local function makeButton(parent, width, label)
  local button = CreateFrame("Button", nil, parent)
  button:SetWidth(width); button:SetHeight(24)
  button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  button.text:SetAllPoints(button); button.text:SetText(label)
  return button
end

local function ensureFrame()
  if frame then return frame end
  frame = CreateFrame("Frame", "ForeverCounterbookJournalTransfer", UIParent)
  frame:SetWidth(620); frame:SetHeight(430); frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function() frame:StartMoving() end)
  frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
  if frame.SetBackdrop then frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 24, insets = { left = 6, right = 6, top = 6, bottom = 6 } }) end

  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -20)
  frame.title:SetText(ForeverCounterbook.Text("journal_transfer_title"))
  frame.instructions = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.instructions:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -10)
  frame.instructions:SetWidth(580); frame.instructions:SetJustifyH("LEFT")
  frame.instructions:SetText(ForeverCounterbook.Text("journal_transfer_instructions"))

  editor = CreateFrame("EditBox", nil, frame)
  editor:SetWidth(580); editor:SetHeight(300); editor:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -82)
  editor:SetMultiLine(true); editor:SetAutoFocus(false); editor:SetFontObject(GameFontHighlight)
  editor:SetMaxLetters(65536)
  editor:SetScript("OnTextChanged", function()
    if not suppressTextChanged then ForeverCounterbook.Journal:CancelImport() end
  end)

  frame.closeButton = makeButton(frame, 90, ForeverCounterbook.Text("journal_transfer_close"))
  frame.closeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 18)
  frame.closeButton:SetScript("OnClick", function() frame:Hide() end)
  frame:Hide()
  return frame
end

local function setEditorText(text, highlight)
  ensureFrame()
  suppressTextChanged = true
  editor:SetText(text or "")
  suppressTextChanged = false
  frame:Show(); editor:SetFocus()
  if highlight then editor:HighlightText() end
end

function ForeverCounterbook.ShowJournalExport()
  local payload, err = ForeverCounterbook.Journal:Export()
  if not payload then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_transfer_error") .. " (" .. err.code .. ")"); return end
  ForeverCounterbook.Journal:CancelImport()
  setEditorText(payload, true)
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_export_ready"))
end

function ForeverCounterbook.ShowJournalImport()
  ForeverCounterbook.Journal:CancelImport()
  setEditorText("", false)
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_import_paste"))
end

function ForeverCounterbook.PreviewJournalImport(mode)
  ensureFrame()
  local preview, err = ForeverCounterbook.Journal:PreviewImport(editor:GetText(), mode)
  if not preview then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_transfer_error") .. " (" .. err.code .. ")"); return end
  DEFAULT_CHAT_FRAME:AddMessage(string.format(
    ForeverCounterbook.Text("journal_import_preview"), ForeverCounterbook.Text("journal_import_mode_" .. preview.mode),
    preview.existingCount, preview.incomingCount, preview.addedCount, preview.duplicateCount, preview.resultingCount
  ))
end

function ForeverCounterbook.ApplyJournalImport()
  local result, err = ForeverCounterbook.Journal:ApplyImport()
  if not result then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_transfer_error") .. " (" .. err.code .. ")"); return end
  DEFAULT_CHAT_FRAME:AddMessage(string.format(ForeverCounterbook.Text("journal_import_applied"), result.resultingCount))
end
