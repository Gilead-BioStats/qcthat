# Install a file from qcthat into a package repo

Install a file from qcthat into a package repo

## Usage

``` r
InstallFile(
  chrSourcePath,
  chrTargetPath,
  strExtension,
  lglOverwrite = FALSE,
  strPkgRoot = ".",
  envCall = rlang::caller_env()
)
```

## Arguments

- chrSourcePath:

  (`character`) Components of a path to a source file. The file
  extension should be included in the filename or omitted (NOT sent as a
  separate piece of the vector).

- chrTargetPath:

  (`character`) Components of a path to a target file. The file
  extension should be included in the filename or omitted (NOT sent as a
  separate piece of the vector).

- strExtension:

  (`length-1 character`) The file extension to use for the target file.
  If the target path already includes an extension, it will be replaced
  with this value. If the value is already correct, this won't have any
  effect.

- lglOverwrite:

  (`length-1 logical`) Whether to overwrite files if they already exist.

- strPkgRoot:

  (`length-1 character`) The path to a directory in the package. Will be
  expanded using
  [`gert::git_find()`](https://docs.ropensci.org/gert/reference/git_repo.html).

- envCall:

  (`environment`) The environment to use for error reporting. Typically
  set to
  [`rlang::caller_env()`](https://rlang.r-lib.org/reference/stack.html).

## Value

The path to the created file (invisibly).
