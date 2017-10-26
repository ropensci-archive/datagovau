

#' @export
show_data <- function(resource_row, destfile = tempfile()) {
  
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
      
      rectangles <- lapply(rectfiles, function(x){try(rio::import(x))})
      message(paste0("Found ", length(rectangles) , " zipped up csv or Excel files and imported them."))
      return(rectangles)
      
    }
  } else if (is_csv(resurl) || is_xls(resurl) || is_xlsx(resurl)) {
    
    message("Working with .[csv|xls|xlsx] file... Returning data.")
    
    ## use rio to import the data if it can
    return(try(rio::import(resurl)))
    
  } else {
    
    message("Sorry, not sure how to work with this data.")
    
  }
  
}
