# PrepareGQLQuery constructs a query (#84)

    Code
      PrepareGQLQuery("line 1: <strVar>", "line 2", strVar = "test_value")
    Output
      line 1: test_value
      line 2

---

    Code
      PrepareGQLQuery("line 1: {{strVar}}", "line 2", strOpen = "{{", strClose = "}}",
        strVar = "test_value")
    Output
      line 1: test_value
      line 2

# GQLWrapper wraps a query correctly (#84)

    Code
      GQLWrapper(strQuery = "sub-query", strOwner = "owner", strRepo = "repo")
    Output
      query { repository(owner: "owner", name: "repo") {
      sub-query
      } }

