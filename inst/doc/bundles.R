## -----------------------------------------------------------------------------
path <- orderly::orderly_example("demo")

## -----------------------------------------------------------------------------
id <- orderly::orderly_run("other", parameters = list(nmin = 0),
                           echo = FALSE, root = path)
orderly::orderly_commit(id, root = path)

## -----------------------------------------------------------------------------
path_bundles <- tempfile()

## -----------------------------------------------------------------------------
bundle <- orderly::orderly_bundle_pack(path_bundles, "use_dependency",
                                       root = path)
bundle

## -----------------------------------------------------------------------------
zip::zip_list(bundle$path)

## -----------------------------------------------------------------------------
workdir <- tempfile()
res <- orderly::orderly_bundle_run(bundle$path, workdir)

## -----------------------------------------------------------------------------
orderly::orderly_bundle_import(res$path, root = path)

## -----------------------------------------------------------------------------
orderly::orderly_list_archive(path)
orderly::orderly_graph("other", root = path)

