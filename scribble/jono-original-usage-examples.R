# Original usage examples from Jono
# Some of these take a long time to run!


library(datagovau)
library(dplyr)
library(mapview)

#----------------water-----------
# works now
res <- search_data("name:water", limit = 20)
water_data <- res %>% filter(can_use == "yes") %>% slice(2) %>% show_data
View(water_data[[1]])

#-------------fire---------------
# downloads data but parses columns wrong
res <- search_data("name:fire", limit = 20)
res %>% filter(can_use == "yes") %>% slice(3) %>% show_data() %>% head
#resource_row <- res %>% filter(can_use == "yes") %>% slice(3)
# works:
res %>% filter(can_use == "yes") %>% slice(4) %>% show_data %>% View

#--------------population---------------
res <- search_data("name:population", limit = 20)

# works iff library(mapview) loaded first...
res %>% filter(can_use == "yes") %>% slice(5) %>% show_data() 


#-----------------location-------------
res <- search_data("name:location", limit = 100)
res %>% filter(can_use == "yes", format == "SHP") %>% View

res %>% filter(can_use == "yes", format == "SHP") %>% slice(6) %>% show_data() %>% mapView()

# sorry can't work with this file yet (because only 6 rows of res have "yes" in can_use)
res %>% filter(can_use == "yes", format == "SHP") %>% slice(7) %>% show_data()

#------------------format shapefile--------------------
res <- search_data("format:SHP", limit = 100)
res %>% filter(can_use == "yes") %>% View

# works:
res %>% filter(can_use == "yes") %>% slice(4) %>% show_data()

# dowloads ok then takes 5+ minutes to render on screen so beware.
res %>% filter(can_use == "yes") %>% slice(22) %>% show_data()

# res <- search_data("description:QLD", limit = 100) ## BIG!
# res %>% filter(can_use == "yes", format == "SHP") %>% View
# res %>% filter(can_use == "yes", format == "SHP") %>% slice(2) %>% show_data()

## useful to search:
# name
# url
# licence_id
# description
# id
# format
#
