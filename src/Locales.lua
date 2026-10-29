ForeverCounterbook.Locales = {
  enUS = {
    viewer_hint = "Use /fcb resto_shaman warrior",
    evidence_confirmed = "Confirmed", evidence_user = "Your note", evidence_assumption = "Assumption",
    matchup_resto_shaman_warrior_title = "Restoration Shaman vs Warrior",
    matchup_resto_shaman_warrior_1 = "Keep enough distance to react before committing to a long cast.",
    matchup_resto_shaman_warrior_2 = "Record which cast or movement decision decided the exchange.",
  },
  ruRU = {
    viewer_hint = "Команда: /fcb resto_shaman warrior",
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

