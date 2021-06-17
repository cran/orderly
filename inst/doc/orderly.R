## ----echo = FALSE, results = "hide"-------------------------------------------
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

owd <- getwd()
knitr::knit_hooks$set(with_path = function(before, options, envir) {
  if (before) {
    setwd(options$with_path_value)
  } else {
    setwd(owd)
  }
  invisible()
})

## ----comment = NA, echo = FALSE-----------------------------------------------
dir_tree(path)

## ----results = "asis", echo = FALSE-------------------------------------------
yaml_output(readLines(file.path(path_example, "orderly.yml")))

## ----results = "asis", echo = FALSE-------------------------------------------
r_output(readLines(file.path(path_example, "script.R")))

## -----------------------------------------------------------------------------
id <- orderly::orderly_run("example", root = path)

## -----------------------------------------------------------------------------
id

## ----comment = NA, echo = FALSE-----------------------------------------------
dir_tree(path)

## -----------------------------------------------------------------------------
orderly::orderly_list_drafts(root = path)

## ----collapse = TRUE----------------------------------------------------------
orderly::orderly_commit(id, root = path)

## ----comment = NA, echo = FALSE-----------------------------------------------
dir_tree(path)

## -----------------------------------------------------------------------------
orderly::orderly_new("new", root = path)

## ----comment = NA, echo = FALSE-----------------------------------------------
dir_tree(path)

## -----------------------------------------------------------------------------
orderly::orderly_use_gitignore(root = path, prompt = FALSE)

## ---- include = FALSE---------------------------------------------------------
path_new <- file.path(path, "src", "new")
local({
  yml <- c(
    "script: script.R",
    "",
    "artefacts:",
    "  - staticgraph:",
    "      description: Mean of the values",
    "      filenames: mean.txt",
    "",
    "depends:",
    "  example:",
    "    id: latest",
    "    use:",
    "      data.csv: mydata.csv")
  code <- c(
    'data <- read.csv("data.csv")',
    'writeLines(as.character(mean(data$y)), "mean.txt")')

  writeLines(yml, file.path(path_new, "orderly.yml"))
  writeLines(code, file.path(path_new, "script.R"))
})

## ----comment = NA, echo = FALSE-----------------------------------------------
dir_tree(path)

## ----results = "asis", echo = FALSE-------------------------------------------
yaml_output(readLines(file.path(path_new, "orderly.yml")))

## -----------------------------------------------------------------------------
orderly::orderly_develop_start("new", root = path)

## -----------------------------------------------------------------------------
orderly::orderly_develop_status("new", root = path)

## ---- with_path = TRUE, with_path_value = path_new----------------------------
orderly::orderly_develop_status()

## ---- with_path = TRUE, with_path_value = path_new----------------------------
source("script.R", echo = TRUE)

## ---- with_path = TRUE, with_path_value = path_new----------------------------
orderly::orderly_develop_status()

## ---- with_path = TRUE, with_path_value = path_new----------------------------
id <- orderly::orderly_run("example", root = path)
orderly::orderly_commit(id, root = path)
orderly::orderly_develop_start()

## ---- with_path = TRUE, with_path_value = path_new, collapse = TRUE-----------
orderly::orderly_develop_clean()
orderly::orderly_develop_status()

