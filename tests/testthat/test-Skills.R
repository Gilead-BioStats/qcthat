test_that("InstallSkill calls InstallFile with expected parts (#53)", {
  local_mocked_bindings(
    InstallFile = function(
      chrSourcePath,
      chrTargetPath,
      strExtension,
      lglOverwrite,
      strPkgRoot,
      envCall
    ) {
      expect_identical(chrSourcePath, c("skills", "test-skill", "SKILL"))
      expect_identical(
        chrTargetPath,
        c(".github/skills", "test-skill", "SKILL")
      )
      expect_identical(strExtension, "md")
      expect_identical(lglOverwrite, FALSE)
      expect_identical(strPkgRoot, ".")
      expect_type(envCall, "environment")
      "mocked_path"
    }
  )
  expect_identical(
    InstallSkill(strSkillName = "Test Skill"),
    "mocked_path"
  )
})

test_that("Skill_TagTestsWithIssues targets the expected skill (#53, #233)", {
  local_mocked_bindings(
    InstallSkill = function(strSkillName, ...) strSkillName
  )
  expect_identical(Skill_TagTestsWithIssues(), "tag tests with issues")
})
