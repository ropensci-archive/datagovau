# Original usage examples from Jono
# Some of these take a long time to run!


#### USAGE:

library(datagovau)
library(dplyr)
res <- search_data("name:water", limit = 20)
res %>% filter(can_use == "yes") %>% slice(2) %>% show_data

res <- search_data("name:fire", limit = 20)
res %>% filter(can_use == "yes") %>% slice(3) %>% show_data %>% View
res %>% filter(can_use == "yes") %>% slice(4) %>% show_data

# res <- search_data("name:population", limit = 20)
# res %>% filter(can_use == "yes") %>% View
# res %>% filter(can_use == "yes") %>% slice(5) %>% show_data() %>% View

# res <- search_data("name:location", limit = 100)
# res %>% filter(can_use == "yes", format == "SHP") %>% View
# res %>% filter(can_use == "yes", format == "SHP") %>% slice(6) %>% show_data()
# res %>% filter(can_use == "yes", format == "SHP") %>% slice(7) %>% show_data()

res <- search_data("format:SHP", limit = 100)
res %>% filter(can_use == "yes") %>% View
res %>% filter(can_use == "yes") %>% slice(4) %>% show_data()
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
