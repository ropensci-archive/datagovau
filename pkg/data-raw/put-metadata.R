
all_data.gov.au_data <-
  package_list[[3]]


all_ids <- unlist(all_data.gov.au_data)
metadata <- list(length(all_ids))

# use 1:length() so that time outs can be restarted from i
for (i in 1:length(all_ids)) {
  j <- all_ids[i]
  metadata[[i]] <-
    jsonlite::read_json(paste0("http://data.gov.au/api/3/action/package_show?id=", j))
}

devtools::use_data(metadata)

#
rm(i)


# We want a data table, with every row a dataset
# every column is a metadata element. However,
# some metadata elements are longer than others.
# At present, I don't know whether it's consistent
# at each nested level.

resources_by_id <-
  lapply(metadata,
         function(x) {
           mi <- x$result
           if ("resources" %in% names(mi) &&
               length(mi$resources) != 0) {
             as.data.table(mi$resources[[1]])
           } else {
             data.table()
           }
         }) %>%
  rbindlist(use.names = TRUE, fill = TRUE)

devtools::use_data(resources_by_id)


