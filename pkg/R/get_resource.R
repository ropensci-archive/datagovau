#' Get a resource from data.gov.au
#' @description A function mainly for internal use, that retrieves the resource
#' (such as a table of data) and returning an object for analysis in the R
#' session (as opposed to downloading the file for later access)
#' @param id,url The id from \url{https://data.gov.au} specifying the resource,
#' or the URL for the direct download. Either the \code{id} or and only or the \code{url} must be given; if both
#' are provided, the url is used, with a warning.
#' @param return.type In what format should the data be returned.
#' Currently, only \code{NULL} is supported, which returns the data
#' in whatever form the underlying function for the particular resource
#' format returns. (For example, \code{csv}'s are returned as \code{data.table}s;
#' \code{xlsx} files are returned as \code{tibbles}.)
#' @param ... Passed to the function which reads the resource, once downloaded.
#' @export

get_resource <- function(id = NULL,
                         url = NULL,
                         return.type = NULL,
                         ...) {

  if (is.null(id) && is.null(url)) {
    stop("`id` and `url` are both NULL. ",
         "Provide one or the other (but only one).")
  }


  if (!is.null(id)) {
    stopifnot(length(id) == 1)
    .ID <- id

    # The resource list has a format column from
    # the data.gov.au API; however, there are a lot
    # of misspellings / inconsistencies that I'm just
    # going to use the file extension of the url.

    # TODO: when the file extension doesn't exist; refer
    # to the format.

    resource_url <-
      resources_by_id %>%
      .[id == .ID, .(url)] %>%
      .[["url"]]

    url_format <-
      tools::file_ext(resource_url)
  } else {
    if (!is.null(url)) {
      warning("Both `id` and `url` are provided. Ignoring `id`.")
    }
    stopifnot(length(url) == 1)

    resource_url <- url
  }

  # Can't access xlsx file remotely via
  # read_excel
  get_xlsx <- function(url, ...) {
    tempf.xlsx <- tempfile(fileext = ".xlsx")
    download_failed <-
      download.file(url,
                    destfile = tempf.xlsx,
                    mode = "wb")

    if (download_failed) {
      stop("Download from ", url, " failed.")
    }

    readxl::read_xlsx(tempf.xlsx, ...)
  }

  get_xls <- function(url, ...) {
    tempf.xls <- tempfile(fileext = ".xls")
    download_failed <-
      download.file(url,
                    destfile = tempf.xls,
                    mode = "wb")

    if (download_failed) {
      stop("Download from ", url, " failed.")
    }

    readxl::read_xls(tempf.xls, ...)
  }


  switch(url_format,
         # Alphabetical order please.
         "csv" = fread(input = resource_url, ...),
         "xls" = get_xls(resource_url, ...),
         "xlsx" = get_xlsx(resource_url, ...),
         stop("Unknown format (file extension missing or not supported)."))

}
