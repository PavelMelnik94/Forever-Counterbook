ForeverCounterbook.Data16001 = {
  schemaVersion = 1,
  datasetRevision = "2026.10.29.1",
  patchKey = "forever-1.60.1-interface-16001",
  supportedClientVersions = { "1.60.1" },
  supportedBuilds = {},
  supportedInterfaces = { 16001 },
  sources = {
    project_method = { label = "Project-authored training guidance; gameplay verification pending", kind = "project" },
    dataset_revision_2026_10_29_1 = { label = "Dataset revision 2026.10.29.1 release notes", kind = "project" },
  },
  changesByProfile = {
    resto_shaman = {
      { textKey = "patch_change_resto_initial_card", evidence = "confirmed", sourceId = "dataset_revision_2026_10_29_1" },
    },
  },
  matchups = {
    ["resto_shaman:warrior"] = {
      profileId = "resto_shaman", opponentClass = "warrior", titleKey = "matchup_resto_shaman_warrior_title",
      countermeasures = {
        { textKey = "matchup_resto_shaman_warrior_1", evidence = "assumption" },
        { textKey = "matchup_resto_shaman_warrior_2", evidence = "user" },
      },
    },
  },
}

