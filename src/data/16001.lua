ForeverCounterbook.Data16001 = {
  schemaVersion = 1,
  datasetRevision = "2026.10.29.1",
  patchKey = "forever-1.60.1-interface-16001",
  supportedClientVersions = { "1.60.1" },
  supportedBuilds = {},
  supportedInterfaces = { 16001 },
  profiles = {
    resto_shaman = { nameKey = "profile_resto_shaman", searchTerms = { "restoration shaman", "resto shaman", "шаман исцеление" } },
    enhancement_shaman_leveling = { nameKey = "profile_enhancement_shaman_leveling", searchTerms = { "enhancement shaman", "leveling shaman", "шаман совершенствование", "шаман прокачка" } },
    slsl_warlock = { nameKey = "profile_slsl_warlock", searchTerms = { "sl/sl warlock", "warlock", "чернокнижник sl/sl" } },
    arms_warrior = { nameKey = "profile_arms_warrior", searchTerms = { "arms warrior", "воин оружие" } },
    resto_druid = { nameKey = "profile_resto_druid", searchTerms = { "restoration druid", "resto druid", "друид исцеление" } },
    resto_balance_druid = { nameKey = "profile_resto_balance_druid", searchTerms = { "restoration balance druid", "resto balance druid", "друид исцеление баланс" } },
  },
  opponentClasses = {
    druid = { nameKey = "class_druid", searchTerms = { "druid", "друид" }, sourceId = "forever_overview" },
    hunter = { nameKey = "class_hunter", searchTerms = { "hunter", "охотник" }, sourceId = "forever_overview" },
    mage = { nameKey = "class_mage", searchTerms = { "mage", "маг" }, sourceId = "forever_overview" },
    paladin = { nameKey = "class_paladin", searchTerms = { "paladin", "паладин" }, sourceId = "forever_overview" },
    priest = { nameKey = "class_priest", searchTerms = { "priest", "жрец" }, sourceId = "forever_overview" },
    rogue = { nameKey = "class_rogue", searchTerms = { "rogue", "разбойник" }, sourceId = "forever_overview" },
    shaman = { nameKey = "class_shaman", searchTerms = { "shaman", "шаман" }, sourceId = "forever_overview" },
    warlock = { nameKey = "class_warlock", searchTerms = { "warlock", "чернокнижник" }, sourceId = "forever_overview" },
    warrior = { nameKey = "class_warrior", searchTerms = { "warrior", "воин" }, sourceId = "forever_overview" },
  },
  briefings = {
    resto_shaman = { requirements = { gear = {}, trinkets = {}, consumables = {}, reagents = {}, abilities = {} } },
    enhancement_shaman_leveling = { requirements = { gear = {}, trinkets = {}, consumables = {}, reagents = {}, abilities = {} } },
    slsl_warlock = { requirements = { gear = {}, trinkets = {}, consumables = {}, reagents = {}, abilities = {} } },
    arms_warrior = { requirements = { gear = {}, trinkets = {}, consumables = {}, reagents = {}, abilities = {} } },
    resto_druid = { requirements = { gear = {}, trinkets = {}, consumables = {}, reagents = {}, abilities = {} } },
    resto_balance_druid = { requirements = { gear = {}, trinkets = {}, consumables = {}, reagents = {}, abilities = {} } },
  },
  sources = {
    project_method = { label = "Project-authored training guidance; gameplay verification pending", kind = "project" },
    dataset_revision_2026_10_29_1 = { label = "Dataset revision 2026.10.29.1 release notes", kind = "project" },
    forever_overview = { label = "Blizzard: World of Warcraft Forever overview (news 24304075)", kind = "official" },
  },
  changesByProfile = {
    resto_shaman = {
      { textKey = "patch_change_resto_initial_card", evidence = "confirmed", sourceId = "dataset_revision_2026_10_29_1" },
    },
  },
  matchups = {
    ["resto_shaman:warrior"] = {
      profileId = "resto_shaman", opponentClass = "warrior", titleKey = "matchup_resto_shaman_warrior_title",
      searchTerms = { abilities = {}, races = {} },
      countermeasures = {
        { textKey = "matchup_resto_shaman_warrior_1", evidence = "assumption" },
        { textKey = "matchup_resto_shaman_warrior_2", evidence = "user" },
      },
    },
  },
}

