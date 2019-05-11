library(plyr)
library(tidyverse)
library(ggplot2)
library(sf) # for shapefiles
library(maptools)
library(rgdal)
library(rgeos)
library(reshape2)

## Compare Marijuana v. Controlled Substance Arrests 
arrests <- read.socrata("https://data.cityofnewyork.us/resource/uip8-fykc.csv")
arrests$arrest_date <- lubridate::ymd(arrests$arrest_date)
arrests <- dplyr::filter(arrests, ofns_desc == "DANGEROUS DRUGS")

arrests_cat <- arrests %>%
                filter(grepl("CONTROLLED", pd_desc) | grepl("MARIJUANA",pd_desc)) %>%
                mutate(Drug.Cat = ifelse(grepl("CONTROLLED", pd_desc), "Controlled Substance", "Marijuana")) %>%
                select(Drug.Cat, pd_desc)

arrests_cat %>%
  group_by(Drug.Cat) %>%
  summarise(n=n()) %>%
  ggplot(aes(x=Drug.Cat, y= n)) +
    geom_bar(stat='identity', fill = 'blue') +
    labs(title = "Controlled Substance v. Marijuana Arrests",
       subtitle = "NYPD Arrests of 2018",
       x = 'Drug Arrest Classification',
       y = 'Number of Arrests',
       caption = "Source: NYC Open Data",
       fill = NULL)

## Spatial Map of Arrests in Zip code

# read in Zip code shapefile 
shp <- readOGR(dsn = "shapefiles/ZipCode")
shp@data$id = shp@data$zcta
shp.points = fortify(shp, region="id")
shp.df = plyr::join(shp.points, shp@data, by="id")

# filter shp for SI 
shp.df <- filter(shp.df, zcta %in% c(10302,10303,10310,10306,10307,10308,10309,10312,10301,10304,10305,10314))
shp.df$zcta <- as.numeric(as.character(shp.df$zcta))

# load in model dataset 
zip.results <- read.csv("./data/ModelDatasets/zipcodeModel3.csv")
shp.df <- left_join(shp.df, zip.results, by = c('zcta'='zip'))
