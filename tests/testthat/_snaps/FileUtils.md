# InstallFile copies files as expected (#73)

    Code
      strReturnedPath <- withVisible(InstallFile(strSourceFileBase, c("targetdir",
        "targetfile"), strExtension = "txt", strPkgRoot = strPkgRoot))
    Message
      File installed. Edit at <target_path>

