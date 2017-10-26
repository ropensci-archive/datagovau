


#' Get data from http://data.gov.au
#' 
#' Downloads a specified data set from the Australian government website data.gov.au
#' 
#' @param resource_row A row of a dataframe specifying which dataset to download.  Must include at a 
#' minumum columns named \code{url} and \code{can_use}.  Usually created by \code{search_data()}.
#' @param destfile Name of a file to save the file downloaded from the data source
#' @param ... Other arguments to be passed through to \code{rio::import()}
#' @return Data from the original data source. See details.
#' @details At this point, \code{get_data} deals with three broad types of data - a single rectangle 
#' (eg csv, xls or xlsx); zip file with multiple rectangles in it; or zip file with a shapefile in it.
#' If a zip file with multiple rectangles, \7code{get_data()} will return a list of tibbles.  If
#' a single rectnagle, it will return a single tibble.  If a shapefile, it will return an object
#' of class SpatialPolygonsDataFrame.
#' @author Jonathan Carroll, Peter Ellis
#' @examples
#' 
#' \dontrun{
#' require(dplyr)
#' res <- search_data("name:water", limit = 20)
#' water_data <- res %>% filter(can_use == "yes") %>% slice(2) %>% get_data
#' head(water_data[[1]])
#' }
#'    
#' @export
get_data <- function(resource_row, destfile = tempfile(), ...) {
  
  #------------------argument checking-------------
  if (nrow(resource_row) > 1L){
    stop("Only one at a time, please.")
  }
  
  if (nrow(resource_row) == 0){
    stop("At least one row of metadata needed.")
  }
  
  
  #-------------------------------------
  ## extract the data URL
  resurl <- resource_row$url
  
  message(resurl)
  
  ## is this a file we can use?
  if (resource_row$can_use == "no"){
    stop("Sorry, can't work with this file yet.")
  }
  
  ## is this a .zip file?
  if (is_zip(resurl)) {
    
    message("Working with .zip file...")
    
    ## save the .zip to the temporary directory
    try(utils::download.file(resurl, destfile = destfile))
    
    ## unzip the folder
    zipfiles <- try(utils::unzip(destfile, exdir = tempdir()))
    
    ## read the shapefile, if there is one
    shpfile <- grep(".shp$", zipfiles, value = TRUE)
    
    ## sometimes there are 0 .shp files, sometimes too many
    if (length(shpfile) == 1) {
      message("Found a shapefile and importing it.")

            ## read the shapefile into a usable format
      shp <- try(rgdal::readOGR(shpfile))
      
      ## return the shapefile
      return(shp)
    } else {
      
      # look for csvs and stuff
      rectfiles <- zipfiles[grepl("\\.csv$", zipfiles) |
                              grepl("\\.xls$", zipfiles) |
                              grepl("\\.xlsx$", zipfiles)]
      
      rectangles <- lapply(rectfiles, function(x){try(rio::import(x, ...))})
      message(paste0("Found ", length(rectangles) , " zipped up csv or Excel files and imported them."))
      return(rectangles)
      
    }
  } else if (is_csv(resurl) || is_xls(resurl) || is_xlsx(resurl)) {
    
    message("Working with .[csv|xls|xlsx] file... Returning data.")
    
    ## use rio to import the data if it can
    rectangle <- try(rio::import(resurl, ...))
    
    return(rectangle)
    
  } else {
    
    message("Sorry, not sure how to work with this data.")
    
  }
  
}
