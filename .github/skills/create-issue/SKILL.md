---
name: create-issue
description: Creates GitHub issues for the package repository. Use when asked to create, file, or open a GitHub issue, or when planning new features or functions that need to be tracked.
compatibility: Requires the `gh` CLI and an authenticated GitHub session.
---

# Create a GitHub issue

Use `gh api graphql` with the `createIssue` mutation to create issues. This sets the issue type in a single step. Write the body to a temp file first, then pass it via `$(cat ...)`.

## Looking up IDs

The hardcoded IDs below are correct for this repo as of 2026-03-10. If they ever change, or if you're working in a fork or a repo other than "Gilead-BioStats/qcthat", re-run these queries to get fresh values (updating owner and name if necessary).

```bash
# Repository node ID
gh api graphql -f query='{ repository(owner: "Gilead-BioStats", name: "qcthat") { id } }'

# Available issue type IDs
gh api graphql -f query='{ repository(owner: "Gilead-BioStats", name: "qcthat") { issueTypes(first: 20) { nodes { id name } } } }'
```

## Issue type

Choose the type that best fits the issue:

| Type | ID | Use for |
|---|---|---|
| Feature | `IT_kwDOA9N6Lc4AusS5` | New exported functions or capabilities |
| Bug | `IT_kwDOA9N6Lc4AusS2` | Something broken or incorrect |
| Documentation Task | `IT_kwDOA9N6Lc4BtSpc` | Docs-only changes |
| Technical Task | `IT_kwDOA9N6Lc4AusS0` | Maintenance, refactoring, chores |
| Requirement | `IT_kwDOA9N6Lc4BtSpm` | Formal requirements or specifications |

## Issue title

Titles use conventional commit prefixes:

- `feat: MyFunction()` — new exported function or feature
- `fix: short description` — bug fix
- `docs: short description` — documentation
- `chore: short description` — maintenance or task

## Issue body structure

Which sections to include depends on the issue type:

| Section | Feature | Bug | Documentation | Task |
|---|---|---|---|---|
| `## Summary` | ✓ | ✓ | ✓ | ✓ |
| `## Details` | optional | optional | optional | optional |
| `## Proposed signature` | ✓ | — | — | — |
| `## Behavior` | ✓ | ✓ | — | — |
| `## References` | optional | optional | optional | optional |

### `## Summary` (all types)

A single user story sentence (no other content in this section):

```markdown
> As a [role], in order to [goal], I would like to [feature].
```

Example:

```markdown
## Summary

> As a package developer, in order to verify test coverage across my release, I would like to generate a QC report linking tests to GitHub issues.
```

### `## Details` (optional, all types)

For information that's important to capture but doesn't fit naturally into any other section. Use sparingly — if the content belongs in `## Behavior`, `## Proposed signature`, or `## References`, put it there instead.

### `## Proposed signature` (Feature only)

The proposed R function signature, arguments table, and return value description:

````markdown
## Proposed signature

```r
FunctionName(strArg1, intArg2)
```

**Arguments**

- `strArg1` (`length-1 character`) — Description.
- `intArg2` (`length-1 integer`) — Description.

**Returns** a `qcthat_ClassName` with description.
````

### `## Behavior` (Feature and Bug)

- **Feature**: bullet points describing expected behavior, edge cases, and any internal helpers to implement as part of this issue.
- **Bug**: describe the current (broken) behavior, the expected behavior, and steps to reproduce if known.

### `## References` (optional, all types)

Only include when there are specific reference implementations, external URLs, or related code to link to. Omit it entirely when there are none.

## Creating the issue

```bash
gh api graphql \
  -f query='mutation($repoId:ID!, $title:String!, $body:String!, $typeId:ID!) {
    createIssue(input:{repositoryId:$repoId, title:$title, body:$body, issueTypeId:$typeId}) {
      issue { url }
    }
  }' \
  -f repoId="R_kgDOLDtfIw" \
  -f title="feat: MyFunction()" \
  -f body="$(cat /tmp/issue_body.md)" \
  -f typeId="IT_kwDOA9N6Lc4AusS5"
```
