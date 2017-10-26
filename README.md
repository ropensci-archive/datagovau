# datagovau

R package for accessing data.gov.au.

## Intro

There are many high quality data sets that are freely available for Australia. Unfortunately they can be difficult to obtain and analyse.  Here we provide tools to programmatically import and explore Australian data sets.  Data can be obtained from the official Australian government portal, which contains over 40,000 data sets
    (<https://data.gov.au>).  
    
This project 

- started as part of the `ozdata` package from the [2017 BURGr R UnConference](https://github.com/AU-BURGr/UnConf2017)
- focused on just data.gov.au and getting CRAN-ready at the [2017 rOpenSci OzUnconf](http://ozunconf17.ropensci.org/)

## Installation


```R
devtools::install_github("ropenscilabs/datagovau/pkg")
```

## Usage

```R
library(dplyr)
library(datagovau)

# download details of datasets with 'water' in their name:
res <- search_data("name:water", limit = 20)

# download the datasets in the second pacakge listed their:
water_data <- res %>% filter(can_use == "yes") %>% slice(2) %>% get_data

# look at the first rectangle of data (at time of writing there were four such rectangles)
head(water_data[[1]])

```
