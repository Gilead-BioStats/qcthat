# BuildPRIssuesQuery creates the correct sub-query (#84)

    Code
      BuildPRIssuesQuery(123)
    Output
      pr123: pullRequest(number: 123) {
      closingIssuesReferences(first: 20) { nodes { number } }
      }

