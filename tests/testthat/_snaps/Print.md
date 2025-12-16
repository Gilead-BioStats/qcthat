# Printing a generic qcthat_object returns input invisibly (#39)

    Code
      test_result <- withVisible(print(obj))
    Output
      Object printed successfully

# MakeKeyItem works (#39)

    Code
      MakeKeyItem("open")
    Output
      [o] = open

# FinalizeTree adds tree characters correctly (#39)

    Code
      cat(test_result, sep = "\n")
    Output
      ├─Item 1
      ├─Item 2
      └─Item 3

