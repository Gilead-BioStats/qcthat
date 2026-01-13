# BuildCommitPRQuery builds the expected query (#133)

    Code
      BuildCommitPRQuery(c("sha1", "sha2"))
    Output
      commitsha1: object(oid: "sha1") {
      ... on Commit {
      associatedPullRequests(first: 1) { nodes { number } }
      }
      }
      commitsha2: object(oid: "sha2") {
      ... on Commit {
      associatedPullRequests(first: 1) { nodes { number } }
      }
      }

