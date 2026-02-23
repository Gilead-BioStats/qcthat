#' Install a skill from qcthat into a package repo
#'
#' @inheritParams shared-params
#' @returns The path to the created skill file (invisibly).
#' @keywords internal
InstallSkill <- function(
  strSkillName,
  strTargetDir = ".github/skills",
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  envCall = rlang::caller_env()
) {
  strSkillName <- stringr::str_replace_all(tolower(strSkillName), "\\s+", "-")
  InstallFile(
    chrSourcePath = c("skills", strSkillName, "SKILL"),
    chrTargetPath = c(strTargetDir, strSkillName, "SKILL"),
    strExtension = "md",
    lglOverwrite = lglOverwrite,
    strPkgRoot = strPkgRoot,
    envCall = envCall
  )
}

#' Use an AI skill to tag tests with issues
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Install an AI skill into a package repository to help identify and tag tests
#' with their related GitHub issues. The skill guides the process of connecting
#' test cases to the features or bugs they address by adding issue references
#' (e.g., `(#123)`) to test descriptions.
#'
#' @inheritParams shared-params
#' @returns The path to the created skill file (invisibly).
#' @export
#' @examplesIf interactive()
#'
#'   Skill_TagTestsWithIssues()
Skill_TagTestsWithIssues <- function(
  strTargetDir = ".github/skills",
  lglOverwrite = FALSE,
  strPkgRoot = "."
) {
  InstallSkill(
    "tag tests with issues",
    strTargetDir = strTargetDir,
    lglOverwrite = lglOverwrite,
    strPkgRoot = strPkgRoot
  )
}
