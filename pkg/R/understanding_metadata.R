
#--------------------utility functions-----------------------
is_zip <- function(x) endsWith(x, ".zip")


is_xlsx <- function(x) endsWith(x, ".xlsx")


is_xls <- function(x) endsWith(x, ".xls")


is_csv <- function(x) endsWith(x, ".csv")


is_xml <- function(x) endsWith(x, ".xml")


is_web <- function(x) {
  endsWith(x, ".php") || endsWith(x, ".html") || endsWith(x, ".html") || endsWith(x, ".htm")
}


multi.sapply <- function(...) {
  # http://rsnippets.blogspot.com.au/2011/11/applying-multiple-functions-to-data.html
  arglist <- match.call(expand.dots = FALSE)$...
  var.names <- sapply(arglist, deparse)
  has.name <- (names(arglist) != "")
  var.names[has.name] <- names(arglist)[has.name]
  arglist <- lapply(arglist, eval.parent, n = 2)
  x <- arglist[[1]]
  arglist[[1]] <- NULL
  result <- sapply(arglist, function (FUN, x) sapply(x, FUN), x)
  colnames(result) <- var.names[-1]
  return(result)
}

# Because of the eval.parent argument in the multi.sapply definition, we need
# matched in characterise_data to be globally available.
globalVariables(c("matched", "."))

#---------------------------------search and characterise metadata-------------

characterise_data <- function(resources) {

  multi.sapply(resources$url, is_csv, is_web, is_xls, is_xlsx, is_xml, is_zip) %>%
    as.data.frame() %>%
    dplyr::mutate(matched = rowSums(.)) %>%
    tibble::rownames_to_column(var = "url") %>%
    dplyr::mutate(can_use = ifelse(matched == 1, "yes", "no"))

}


#' Search the data.gov.au metadata
#'
#' Search the data.gov.au metadata
#'
#' @param query character string of field to be searched and string to search it for, separated by a colon.
#' @param limit number of rows of metadata to return (each row represents a single package of datasets).
#'
#' @return A tibble of metadata with 30 columns
#' @details Good fields to search include name, description, format, url, licence_id
#' @author Jonathan Carroll
#' @examples
#'
#' \dontrun{
#' if (requireNamespace("dplyr", quietly = TRUE)) {
#' res <- search_data("name:water", limit = 20)
#' water_data <- res %>% filter(can_use == "yes") %>% slice(2) %>% get_data
#' head(water_data[[1]])
#' }
#' }
#' @export
search_data <- function(query = "name:location", limit = 10) {

  if (nzchar(Sys.getenv("CKANR_DEFAULT_URL"))) {
    old_CKANR_DEFAULT_URL <- Sys.getenv("CKANR_DEFAULT_URL")
    on.exit(Sys.setenv("CKANR_DEFAULT_URL" = old_CKANR_DEFAULT_URL))
  }
  Sys.setenv("CKANR_DEFAULT_URL" = "http://www.data.gov.au")

  ## obtain the result of the search
  ## and check if they can be processed
  query_results <- ckanr::resource_search(q = query, as = "table", limit = limit)
  all_res <- magrittr::use_series(query_results, "results")

  ## add a column stating whether or not we can use this data yet
  all_res$can_use <- characterise_data(all_res)$can_use

  return(all_res)

}


