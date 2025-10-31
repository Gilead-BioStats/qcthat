# Printing a generic qcthat_object returns input invisibly

    Code
      test_result <- withVisible(print(obj))
    Output
      Object printed successfully

# MakeKeyItem works

    Code
      MakeKeyItem("open")
    Output
      📥 = open

# FinalizeTree adds tree characters correctly

    Code
      cat(test_result, sep = "\n")
    Output
      ├─Item 1
      ├─Item 2
      └─Item 3

