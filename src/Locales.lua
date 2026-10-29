ForeverCounterbook.Locales = {
  enUS = {
    viewer_hint = "Use /fcb resto_shaman warrior, /fcb note <text>, /fcb notes, or /fcb patch <profile>",
    journal_open_card_first = "Open a matchup card before writing a note.",
    journal_note_saved = "Matchup note saved.",
    journal_no_notes = "No personal notes for this matchup.",
    journal_notes_title = "Personal matchup notes:",
    patch_status_title = "Forever Counterbook patch status",
    patch_status_schema = "Schema version", patch_status_dataset = "Dataset revision", patch_status_patch = "Patch", patch_status_addon = "Addon version",
    patch_status_supported_version = "Supported client version",
    patch_status_supported_build = "Supported build", patch_status_supported_interface = "Supported interface",
    patch_status_observed_version = "Observed client version", patch_status_observed_build = "Observed build", patch_status_observed_interface = "Observed interface",
    patch_status_not_declared = "Not declared", patch_status_not_observed = "Not observed",
    patch_status_result = "Freshness", patch_status_current = "Current", patch_status_stale = "Stale", patch_status_unknown = "Unknown",
    patch_status_warning = "Stale warning: compatibility is not confirmed.",
    patch_status_changes = "Changes for this profile:", patch_status_no_changes = "No authored changes for this profile.",
    patch_change_resto_initial_card = "Added the first versioned Restoration Shaman matchup card.",
    evidence_confirmed = "Confirmed", evidence_user = "Your note", evidence_assumption = "Assumption",
    matchup_resto_shaman_warrior_title = "Restoration Shaman vs Warrior",
    matchup_resto_shaman_warrior_1 = "Keep enough distance to react before committing to a long cast.",
    matchup_resto_shaman_warrior_2 = "Record which cast or movement decision decided the exchange.",
  },
  ruRU = {
    viewer_hint = "Команды: /fcb resto_shaman warrior, /fcb note <текст>, /fcb notes, /fcb patch <профиль>",
    journal_open_card_first = "Перед записью заметки откройте карточку матчапа.",
    journal_note_saved = "Заметка о матчапе сохранена.",
    journal_no_notes = "Для этого матчапа пока нет личных заметок.",
    journal_notes_title = "Личные заметки о матчапе:",
    patch_status_title = "Статус патча Forever Counterbook",
    patch_status_schema = "Версия схемы", patch_status_dataset = "Ревизия данных", patch_status_patch = "Патч", patch_status_addon = "Версия аддона",
    patch_status_supported_version = "Поддерживаемая версия клиента",
    patch_status_supported_build = "Поддерживаемый build", patch_status_supported_interface = "Поддерживаемый interface",
    patch_status_observed_version = "Обнаруженная версия клиента", patch_status_observed_build = "Обнаруженный build", patch_status_observed_interface = "Обнаруженный interface",
    patch_status_not_declared = "Не объявлено", patch_status_not_observed = "Не обнаружено",
    patch_status_result = "Актуальность", patch_status_current = "Актуально", patch_status_stale = "Устарело", patch_status_unknown = "Неизвестно",
    patch_status_warning = "Предупреждение: совместимость не подтверждена.",
    patch_status_changes = "Изменения для профиля:", patch_status_no_changes = "Для профиля нет описанных изменений.",
    patch_change_resto_initial_card = "Добавлена первая версионированная карточка матчапа Restoration Shaman.",
    evidence_confirmed = "Подтверждено", evidence_user = "Ваша заметка", evidence_assumption = "Предположение",
    matchup_resto_shaman_warrior_title = "Шаман «Исцеление» против воина",
    matchup_resto_shaman_warrior_1 = "Сохраняйте дистанцию, позволяющую среагировать до начала долгого заклинания.",
    matchup_resto_shaman_warrior_2 = "Запишите, какое решение о заклинании или движении определило исход размена.",
  },
}

function ForeverCounterbook.Text(key)
  local locale = "enUS"
  if type(GetLocale) == "function" and ForeverCounterbook.Locales[GetLocale()] then locale = GetLocale() end
  return ForeverCounterbook.Locales[locale][key] or ForeverCounterbook.Locales.enUS[key] or key
end

