local catalog, loadError = ForeverCounterbook.MatchupCatalog.Load(ForeverCounterbook.Data16001)
ForeverCounterbook.Catalog = catalog
ForeverCounterbook.CatalogError = loadError
local journal = ForeverCounterbook.MatchupJournal.New(ForeverCounterbook.SavedVariablesStorage.New())
ForeverCounterbook.Journal = journal
local frame
local currentMatchupKey

local function ensureFrame()
  if frame then return frame end
  frame = CreateFrame("Frame", "ForeverCounterbookCardFrame", UIParent)
  frame:SetWidth(430); frame:SetHeight(270); frame:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
  frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function() frame:StartMoving() end)
  frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
  if frame.SetBackdrop then frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 24, insets = { left = 6, right = 6, top = 6, bottom = 6 } }) end
  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -20)
  frame.body = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); frame.body:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -18)
  frame.body:SetWidth(390); frame.body:SetJustifyH("LEFT"); frame.body:SetJustifyV("TOP"); frame:Hide()
  return frame
end

function ForeverCounterbook.ShowCard(profileId, opponentClass)
  if not catalog then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: dataset error " .. loadError.code); return end
  local card = catalog:GetCard(profileId, opponentClass)
  if not card then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: no card for " .. profileId .. " vs " .. opponentClass); return end
  local view, lines = ensureFrame(), {}
  currentMatchupKey = profileId .. ":" .. opponentClass
  view.title:SetText(ForeverCounterbook.Text(card.titleKey))
  for index, item in ipairs(card.countermeasures) do
    lines[index] = index .. ". [" .. ForeverCounterbook.Text("evidence_" .. item.evidence) .. "] " .. ForeverCounterbook.Text(item.textKey)
  end
  view.body:SetText(table.concat(lines, "\n\n")); view:Show()
end

local function addCurrentNote(text)
  if not currentMatchupKey then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_open_card_first")); return end
  local _, err = journal:AddNote(currentMatchupKey, text)
  if err then DEFAULT_CHAT_FRAME:AddMessage("Forever Counterbook: " .. err.code); return end
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_note_saved"))
end

local function showCurrentNotes()
  if not currentMatchupKey then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_open_card_first")); return end
  local notes = journal:GetNotes(currentMatchupKey)
  if table.getn(notes) == 0 then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_no_notes")); return end
  DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("journal_notes_title"))
  for index, note in ipairs(notes) do DEFAULT_CHAT_FRAME:AddMessage(index .. ". " .. note.text) end
end

SLASH_FOREVERCOUNTERBOOK1 = "/fcb"
SlashCmdList.FOREVERCOUNTERBOOK = function(message)
  local bookProfile = string.match(message or "", "^book%s+(%S+)$")
  if bookProfile then ForeverCounterbook.ShowMatchupBook(string.lower(bookProfile)); return end
  local searchQuery = string.match(message or "", "^search%s+(.+)$")
  if searchQuery then ForeverCounterbook.ShowMatchupSearch(searchQuery); return end
  local openProfile, openOpponent = string.match(message or "", "^open%s+(%S+)%s+(%S+)$")
  if openProfile then ForeverCounterbook.OpenMatchupOption(string.lower(openProfile), string.lower(openOpponent)); return end
  local patchProfile = string.match(message or "", "^patch%s+(%S+)$")
  if patchProfile then ForeverCounterbook.ShowPatchStatus(string.lower(patchProfile)); return end
  if message == "notes" then showCurrentNotes(); return end
  local noteText = string.match(message or "", "^note%s+(.+)$")
  if noteText then addCurrentNote(noteText); return end
  local profileId, opponentClass = string.match(message or "", "^(%S+)%s+(%S+)$")
  if not profileId then DEFAULT_CHAT_FRAME:AddMessage(ForeverCounterbook.Text("viewer_hint")); return end
  ForeverCounterbook.ShowCard(string.lower(profileId), string.lower(opponentClass))
end

