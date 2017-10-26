

#' @export
show_data <- function(resource_row) {
  
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
  if (resource_row$can_use == "no")
    stop("Sorry, can't work with this file yet.")
  
  ## is this a .zip file?
  if (is_zip(resurl)) {
    
    message("Working with .zip (shp) file... Evaluate returned object.")
    
    ## create a temporary file for the .zip
    tf <- tempfile()
    
    ## save the .zip to the temporary directory
    try(utils::download.file(resurl, destfile = tf))
    
    ## unzip the folder
    shpfiles <- try(utils::unzip(tf, exdir = tempdir()))
    
    ## read the shapefile
    shpfile <- grep(".shp$", shpfiles, value = TRUE)
    
    ## sometimes there are 0 .shp files, sometimes too many
    if (length(shpfile) != 1) stop("Unexpected unzipping of files.")
    
    ## read the shapefile into a usable format
    shp <- try(rgdal::readOGR(shpfile))
    
    ## plot the shapefile on exit
    return(mapview::mapview(shp))
    
  } else if (is_csv(resurl) || is_xls(resurl) || is_xlsx(resurl)) {
    
    message("Working with .[csv|xls|xlsx] file... Returning data.")
    
    ## use rio to import the data if it can
    return(try(rio::import(resurl)))
    
  } else {
    
    message("Sorry, not sure how to work with this data.")
    
  }
  
}
