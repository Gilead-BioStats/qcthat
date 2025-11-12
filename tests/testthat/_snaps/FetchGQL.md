# PrepareGQLQuery constructs a query (#84)

    Code
      test_result
    Output
      line 1: test_value
      line 2

# PrepareGQLQuery works with different delimiters (#84)

    Code
      test_result
    Output
      line 1: test_value
      line 2

# GQLWrapper wraps a query correctly (#84)

    Code
      test_result
    Output
      query { repository(owner: "owner", name: "repo") {
      sub-query
      } }

