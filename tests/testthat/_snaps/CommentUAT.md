# CommentUAT generates the expected call (#115, #185)

    Code
      cat(test_result$strBody)
    Output
      These UAT issues have been accepted:
      
      - [x] [Description of 2](https://github.com/owner/repo/issues/6)
      
      <hr>
      
      Click through to these issues and follow the instructions to accept them as complete (or to log additional details about changes that are needed before they can be accepted):
      
      - [ ] [Description of 1](https://github.com/owner/repo/issues/5)
      - [ ] [Description of 3](https://github.com/owner/repo/issues/7)
      
      The qcthat PR-associated issues report will re-run when all of these issues are accepted.

# FormatUATGH works for errors (#137, #185, #230)

    Code
      cat(FormatUATGH(1:4))
    Output
      These issues had unknown processing errors during UAT checks:
      
      - UAT for #3: Description of 3
      
      You may want to re-run the qcthat action, or possibly edit these tests.
      
      <hr>
      
      These issues should have UAT issues, but the child issues were not created:
      
      - UAT for #4: Description of 4
      
      You may want to re-run the qcthat action, or debug why the issue could not be created.
      
      <hr>
      
      These UAT issues have been accepted:
      
      - [x] [Description of 2](https://github.com/owner/repo/issues/6)
      
      <hr>
      
      Click through to these issues and follow the instructions to accept them as complete (or to log additional details about changes that are needed before they can be accepted):
      
      - [ ] [Description of 1](https://github.com/owner/repo/issues/5)
      
      The qcthat PR-associated issues report will re-run when all of these issues are accepted.

