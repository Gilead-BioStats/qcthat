# FetchRepoIssueClosersRawBatch generates the expected calls (#133)

    Code
      FetchRepoIssueClosersRawBatch(strOwner = "owner", strRepo = "repo", strGHToken = "token")
    Output
      [[1]]
      issues(first: 100, states: CLOSED,  orderBy: {field: CREATED_AT, direction: ASC}) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          number
          timelineItems(last: 10, itemTypes: [CLOSED_EVENT, CONNECTED_EVENT, DISCONNECTED_EVENT]) {
            nodes {
              __typename
              ... on ClosedEvent {
                createdAt
                closer {
                  __typename
                  ... on Commit {
                    oid
                  }
                  ... on PullRequest {
                    number
                    merged
                    mergeCommit { oid }
                    repository {
                      nameWithOwner
                    }
                  }
                }
              }
              ... on ConnectedEvent {
                createdAt
                subject {
                  __typename
                  ... on PullRequest {
                    number
                    merged
                    mergeCommit { oid }
                    repository {
                      nameWithOwner
                    }
                  }
                }
              }
              ... on DisconnectedEvent {
                subject {
                  __typename
                  ... on PullRequest {
                    number
                    repository { nameWithOwner }
                  }
                }
              }
            }
          }
        }
      }
      
      $strOwner
      [1] "owner"
      
      $strRepo
      [1] "repo"
      
      $strGHToken
      [1] "token"
      

---

    Code
      FetchRepoIssueClosersRawBatch(strOwner = "owner", strRepo = "repo", strGHToken = "token",
        strCursor = "not-null")
    Output
      [[1]]
      issues(first: 100, states: CLOSED, after: "not-null",  orderBy: {field: CREATED_AT, direction: ASC}) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          number
          timelineItems(last: 10, itemTypes: [CLOSED_EVENT, CONNECTED_EVENT, DISCONNECTED_EVENT]) {
            nodes {
              __typename
              ... on ClosedEvent {
                createdAt
                closer {
                  __typename
                  ... on Commit {
                    oid
                  }
                  ... on PullRequest {
                    number
                    merged
                    mergeCommit { oid }
                    repository {
                      nameWithOwner
                    }
                  }
                }
              }
              ... on ConnectedEvent {
                createdAt
                subject {
                  __typename
                  ... on PullRequest {
                    number
                    merged
                    mergeCommit { oid }
                    repository {
                      nameWithOwner
                    }
                  }
                }
              }
              ... on DisconnectedEvent {
                subject {
                  __typename
                  ... on PullRequest {
                    number
                    repository { nameWithOwner }
                  }
                }
              }
            }
          }
        }
      }
      
      $strOwner
      [1] "owner"
      
      $strRepo
      [1] "repo"
      
      $strGHToken
      [1] "token"
      

