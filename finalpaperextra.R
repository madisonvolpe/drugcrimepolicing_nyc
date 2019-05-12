library(plyr)
library(tidyverse)
library(ggplot2)
library(sf) # for shapefiles
library(maptools)
library(rgdal)
library(rgeos)
library(reshape2)
library(scales)

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

rm(list=ls())

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

# read in arrest data 
arrests <- read_csv("./data/si_drugs_mod_arrests.csv")
arrests_map <- select(arrests, x_coord_cd, y_coord_cd, perp_race)
arrests_map <- arrests_map %>%
               mutate(race_cat = case_when(
                 perp_race == "BLACK" ~ "BLACK",
                 perp_race == "WHITE" ~ "WHITE",
                 perp_race == "HISPANIC" ~ "HISPANIC",
                 !perp_race %in% c("BLACK", "WHITE", "HISPANIC") ~ "OTHER"
               ))


arrests_map <- arrests_map %>%
               mutate(colorz = case_when(
                 race_cat == "BLACK" ~ "red",
                 race_cat == "WHITE" ~ "green",
                 race_cat == "HISPANIC" ~ "black",
                 race_cat == "OTHER" ~ "orange"
               ))

ggplot(shp.df) +
  aes(long,lat,group=group) + 
  geom_polygon(aes(fill = proportionNonWhite)) +
  scale_fill_gradient(low = "gray", high = muted("blue")) +
  geom_point(data = arrests_map, aes(x=x_coord_cd, y=y_coord_cd, col = factor(race_cat), shape = factor(race_cat)),
             inherit.aes=FALSE) +
  scale_colour_discrete(name  ="Offender's Race",
                        breaks=c("BLACK", "WHITE", "OTHER", "HISPANIC"),
                        labels=c("Black", "White", "Other", "Hispanic")) +
  scale_shape_discrete(name = "Offender's Race",
                       breaks=c("BLACK", "WHITE", "OTHER", "HISPANIC"),
                       labels=c("Black", "White", "Other", "Hispanic")) +
  theme_bw() +
  labs(title = "Drug Arrests on Staten Island",
       subtitle = "Offender's Race over Zip Code's Racial Composition",
       caption = "Source: NYC Open Data",
       fill = "Proportion Non-White") 

rm(list=ls())

## Drug Arrests in each Zip Code by Race 

# read in drug arrests 
drugs <- read.csv("./data/si_drugs_mod_arrests.csv")

# read in zip shapefile 
zip   <-readOGR(dsn = "./shapefiles/ZipCode")

# convert zip to sf 
zip <- st_as_sf(zip)
zip <- zip[,c(1,4)]

# filter for SI zip codes only 
zip <- filter(zip, zcta %in% c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
                               10312, 10301, 10304, 10305, 10314, 10311, 10313))

colnames(zip) <- c("zip", "geometry")

# transfom zip to 4326 
zip <- st_transform(zip, 4326)

# get points from drugs dataset 
points <- data.frame(x = drugs$longitude,  y = drugs$latitude, id = 1:nrow(drugs), race = drugs$perp_race) 
points <- st_as_sf(points, coords = c("x", "y"), crs = 4326)

# Intersection between polygon and points -
intersection <- st_intersection(x = zip, y = points)
intersection <- as.data.frame(intersection)
intersection <- intersection[1:3]
intersection <- as.data.frame(intersection)

# Counts 
race.results <- intersection %>%
                  select(zip,race) %>%
                  group_by(zip,race) %>%
                  count() %>%
                  spread(race,freq)
  
make.zero <- function(x){
  x[is.na(x)] <- 0
  return(x)
}
    
make.numeric <- function(x){
  x <- as.numeric(as.character(x))
  return(x)
}

race.results <- data.frame(apply(race.results, 2, make.zero))
race.results <- data.frame(apply(race.results, 2, make.numeric))

race.results <- race.results %>%
  mutate(OTHER = AMER.IND + AMERICAN.INDIAN.ALASKAN.NATIVE + ASIAN...PACIFIC.ISLANDER +
           ASIAN.PAC.ISL+ UNKNOWN,
         TOTAL = WHITE + BLACK + HISPANIC + OTHER) %>%
  select(zip, WHITE, BLACK, HISPANIC, OTHER, TOTAL)

zip.results <- read.csv("./data/ModelDatasets/zipcodeModel3.csv")

final <- left_join(race.results, zip.results, by = 'zip')

final <- final %>%
  select(zip, WHITE, BLACK, HISPANIC, OTHER, TOTAL, Total.Population.Over18, proportionWhite, proportionNonWhite) %>%
  mutate(MajorityNonWhite = ifelse(proportionNonWhite > .5, "Yes", "No")) %>%
  mutate(DrugArrestRate = (TOTAL/Total.Population.Over18)*100) %>%
  select(zip, WHITE, BLACK, HISPANIC, OTHER, TOTAL, MajorityNonWhite, DrugArrestRate) %>%
  arrange(desc(DrugArrestRate))

final$MajorityNonWhite <- factor(final$MajorityNonWhite)

rm(list=ls())

### EDA graphs
zip.results <- read.csv("./data/ModelDatasets/zipcodeModel3.csv")

zip.results <- zip.results %>%
  mutate(MajorityNonWhite = ifelse(proportionNonWhite > .50, 'Yes', 'No'))

rates <- select(zip.results, zip, no.drug.arrests.13.18, no.ems.calls.13.18, Total.Population.Over18,
                Total.Naxolone.Saves, Overdose.Death.Total, MajorityNonWhite)

rates <- rates %>%
  mutate(Drug.Arrest.Rate = (no.drug.arrests.13.18/Total.Population.Over18)*100,
         Ems.Dispatches.Rate = (no.ems.calls.13.18/Total.Population.Over18)*100,
         Naloxone.Rate = (Total.Naxolone.Saves/Total.Population.Over18)*100,
         Overdose.Death.Rate = (Overdose.Death.Total/Total.Population.Over18)*100
         )

a1 <- ggplot(rates, aes(x = Ems.Dispatches.Rate, y = Drug.Arrest.Rate, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Within each zip code",
       x = 'EMS Dispatch Rate (2013-2018)',
       y = 'Drug Arrest Rate (2013-2018)',
       caption = "Source: NYC Open Data, 2017 ACS",
       color = "Non-White Majority",
       fill = NULL) 

a2 <- ggplot(rates, aes(x = Naloxone.Rate, y = Drug.Arrest.Rate, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Within each zip code",
       x = 'Naloxone Saves Rate (2016-2018)',
       y = 'Drug Arrest Rate (2013-2018)',
       caption = "Source: NYC Open Data, SI Drug Prevention Dashboard",
       color = "Non-White Majority",
       fill = NULL) 

a3 <- ggplot(rates, aes(x = Overdose.Death.Rate, y = Drug.Arrest.Rate, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Within each zip code",
       x = 'Overdose Death Rate (2016-2018)',
       y = 'Drug Arrest Rate (2013-2018)',
       caption = "Source: NYC Open Data, SI Drug Prevention Dashboard",
       color = "Non-White Majority",
       fill = NULL) 

gridExtra::grid.arrange(a1,a2,a3)

## Arrests by Racial Composition  - But individual years to add more points to the graph

zip.arrest.by.year <- read.csv("./data/ModelDatasets/zipcodeModel2.csv")

zip.arrest.by.year <- filter(zip.arrest.by.year, year %in% c(2016,2017))

zip.arrest.by.year <- select(zip.arrest.by.year, zip, year, no.drug.arrests.14.17,proportionNonWhite,
                             Total.Population.Over18)

zip.arrest.by.year$naxsaves <- c(72,98,17,15,16,24,46,58,55,63,59,77,18,26,15,19,25,27,20,25,26,54,37,54)

zip.arrest.by.year$overdose <- c(6,8,7,13,4,2,7,5,11,14,14,21,4,4,4,6,5,10,5,7,9,6,16,13)

zip.arrest.by.year$MajorityNonWhite <- ifelse(zip.arrest.by.year$proportionNonWhite > .50, 'Yes', 'No')

zip.arrest.by.year$Overdose.Death.Rate <- (zip.arrest.by.year$overdose/zip.arrest.by.year$Total.Population.Over18)*100
zip.arrest.by.year$Drug.Arrest.Rate <- (zip.arrest.by.year$no.drug.arrests.14.17/zip.arrest.by.year$Total.Population.Over18)*100

ggplot(zip.arrest.by.year, aes(x = Overdose.Death.Rate, y = Drug.Arrest.Rate, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Not Aggregated",
       x = 'Overdose Death Rate (2016 - 2017)',
       y = 'Drug Arrest Rate (2016 - 2017)',
       caption = "Source: NYC Open Data, SI Drug Prevention Dashboard",
       color = "Non-White Majority",
       fill = NULL) 



