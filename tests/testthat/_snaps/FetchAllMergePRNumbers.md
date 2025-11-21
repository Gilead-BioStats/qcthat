# BuildCommitPRQuery creates the correct sub-query (#84)

    Code
      BuildCommitPRQuery("abc123def", 1)
    Output
      commit1: object(oid: "abc123def") {
        ... on Commit {
          associatedPullRequests(first: 100) { nodes { number } }
        }
      }

