# exploration of the data.gov.au datasets that contain anything on "trees"
# Peter Ellis, 27 October 2017

library(datagovau)
library(mapview)
library(dplyr)
library(sp)
library(ggplot2)
library(scales)
library(forcats)
library(viridis)
library(ggmap)
library(ggthemes)

# search for datasets with "trees" in their name:
trees_md <- search_data("name:trees", limit = 1000)
dim(trees_md) # 87 datasets about trees

# what datasets do we have?:
trees_md[, "name"]

# The trees data seems to be nearly entirely databases of trees in particular cities
# and districts.  Formats include MapInfo, shapefiles, KML, DBF, CSV, WMS, JSON and GeoJSON.

# choose one of those shapefile ones:
burnside <- trees_md %>% 
  filter(name == 'Burnside Trees - Shapefile') %>% 
  get_data()

# leaflet map:                             
mapView(burnside)

# fails because it wants a json:
wyndham <- trees_md %>% 
  filter(name == 'Wyndham Trees and latest inspection') %>%
  slice(1) %>%
  get_data()

# downloads a shapefile:
wyndham <- trees_md %>% 
  filter(name == 'Wyndham Trees and latest inspection') %>%
  slice(2) %>%
  get_data()

plot(wyndham)


# fails because it wants a kml:
brimbank <- trees_md %>%
  filter(name == "Brimbank Street Trees - Google kml") %>%
  get_data()

geelong <- trees_md %>%
  filter(name == "Geelong Trees GeoJSON") %>%
  get_data()


#---------------------facet plot of burnside trees by species---------------
# download data
burnside2 <- trees_md %>%
  filter(name == "Burnside Trees - CSV") %>%
  get_data()

# get the background map
m <- get_map(location = c(mean(burnside2$X), mean(burnside2$Y)), 
             source = "stamen",
             maptype = "toner",
             zoom = 13)

# tidy up our data:
heights <- c("less than 5m", "5m", "5-10m", "10-20m", "greater than 20m")
d <- burnside2 %>%
  mutate(type = fct_lump(BotanicalN, 8),
         height = factor(TreeHeight, levels = heights)) 

# draw map
ggmap(m) +
  geom_point(data = d, aes(x = X, y = Y, colour = height)) +
  facet_wrap(~type) +
  scale_colour_viridis(discrete = TRUE) +
  ggtitle("Burnside trees") +
  coord_map() +
  theme_map() +
  theme(legend.position = "right")




