# FetchAllIssuePRRefsRaw generates the expected calls (#114)

    Code
      FetchAllIssuePRRefsRaw(intIssue = 123, strOwner = "owner", strRepo = "repo",
        strGHToken = "token")
    Output
      $strQuery
      issue(number: 123) {
        timelineItems(first: 100, itemTypes: [CROSS_REFERENCED_EVENT]) {
          nodes {
            ... on CrossReferencedEvent {
              source {
                ... on PullRequest {
                  number
                  state
                  headRefName
                  commits(last:1) {
                    nodes {
                      commit {
                        oid
                      }
                    }
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
      

# BuildIssuePRRefsQuery generates correct GQL (#114)

    Code
      BuildIssuePRRefsQuery(123)
    Output
      issue(number: 123) {
        timelineItems(first: 100, itemTypes: [CROSS_REFERENCED_EVENT]) {
          nodes {
            ... on CrossReferencedEvent {
              source {
                ... on PullRequest {
                  number
                  state
                  headRefName
                  commits(last:1) {
                    nodes {
                      commit {
                        oid
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

