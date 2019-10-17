## ----echo = FALSE, results = "hide"--------------------------------------
lang_output <- function(x, lang) {
  writeLines(c(sprintf("```%s", lang), x, "```"))
}
r_output <- function(x) lang_output(x, "r")
yaml_output <- function(x) lang_output(x, "yaml")
plain_output <- function(x) lang_output(x, "plain")
orderly_file <- function(...) {
  system.file(..., package = "orderly", mustWork = TRUE)
}

path <- orderly:::prepare_orderly_example("nodata")
path_example <- file.path(path, "src", "example")
## Even simpler
unlink(file.path(path, "archive"), recursive = TRUE)
unlink(file.path(path, "draft"), recursive = TRUE)
unlink(file.path(path, "data"), recursive = TRUE)
unlink(file.path(path, "README.md"))
unlink(file.path(path, "src", "README.md"))

dir_tree <- function(path) {
  withr::with_dir(path, fs::dir_tree("."))
}

## ----comment = NA, echo = FALSE------------------------------------------
dir_tree(path)

## ----results = "asis", echo = FALSE--------------------------------------
yaml_output(readLines(file.path(path_example, "orderly.yml")))

## ----results = "asis", echo = FALSE--------------------------------------
r_output(readLines(file.path(path_example, "script.R")))

## ------------------------------------------------------------------------
id <- orderly::orderly_run("example", root = path)

## ------------------------------------------------------------------------
id

## ----comment = NA, echo = FALSE------------------------------------------
dir_tree(path)

## ------------------------------------------------------------------------
orderly::orderly_list_drafts(root = path)

## ----collapse = TRUE-----------------------------------------------------
orderly::orderly_commit(id, root = path)

## ----comment = NA, echo = FALSE------------------------------------------
dir_tree(path)

## ------------------------------------------------------------------------
orderly::orderly_new("new", root = path)

## ----comment = NA, echo = FALSE------------------------------------------
dir_tree(path)

