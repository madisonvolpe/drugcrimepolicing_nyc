## We need the following datasets:

  ## drug arrest 
  ## zip shapefile 
  ## ems calls 
  ## demo by zip 

library(plyr)
library(tidyverse)
library(ggplot2)
library(sf)
library(maptools)
library(rgdal)
library(rgeos)
library(reshape2)

### DATASET ONE ###

# First we will get the count of the number of drug arrests that occured in each zipcode 
  
  # read in drug arrests 
  drugs <- read.csv("data/si_drugs_mod_arrests.csv")
  
  # read in zip shapefile 
  zip   <-readOGR(dsn = "shapefiles/ZipCode")
  
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
  points <- data.frame(x = drugs$longitude,  y = drugs$latitude, id = 1:nrow(drugs)) 
  points <- st_as_sf(points, coords = c("x", "y"), crs = 4326)
  
  # Intersection between polygon and points -
  intersection <- st_intersection(x = zip, y = points)

  # Counts 
  intresult <- intersection %>% 
                group_by(zip) %>% 
                count() %>%
                select(zip,n)

  final_arrest_counts_by_zip <- as.data.frame(intresult)[,-3] # lost some observations (4) but that is okay 
  final_arrest_counts_by_zip$zip <- as.numeric(as.character(final_arrest_counts_by_zip$zip))
  names(final_arrest_counts_by_zip)[2] <- 'no.drug.arrests.13.18'
  #also note no arrests were made in 10311, 10313 - this is bc these areas are not very populated
  
  
## get ems counts 
  
# emsorig   <- read.csv("data/ems_original.csv")
# 
# emisorig <- filter(emsorig, zipcode %in% c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
#                   10312, 10301, 10304, 10305, 10314, 10311, 10313))
# 
# !c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
#    10312, 10301, 10304, 10305, 10314, 10311, 10313) %in% unique(emisorig$zipcode)

ems <- read.csv("data/emsdrugs.csv")

final_ems_counts_by_zip <- ems %>%
                            group_by(zipcode) %>%
                            count() %>%
                            select(zipcode,n)

names(final_ems_counts_by_zip)[1] <- 'zip'
names(final_ems_counts_by_zip)[2] <- 'no.ems.calls.13.18'

# join arrests and ems counts
zip_model_dataset <- left_join(final_arrest_counts_by_zip, final_ems_counts_by_zip, by = 'zip')

# add demographics 

demo <- read.csv("data/ACS_Demo/ACS.14_17.csv")

demo <- filter(demo, zip %in% c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
                        10312, 10301, 10304, 10305, 10314, 10313))

demo <- filter(demo, year == 2017 ) # for lump sum estimates use (ACS 2017 5 year estimates)

demofinal <- demo %>%
            select(zip, Total.Population, Total.Population.Over18, White.Alone) %>%
            mutate(proportionWhite = (White.Alone/Total.Population),
                   proportionNonWhite = ((Total.Population-White.Alone)/
                                           Total.Population))%>%
            select(zip, Total.Population, Total.Population.Over18, proportionWhite, proportionNonWhite) 

# join demographics with data 
zip_model_dataset <- left_join(zip_model_dataset, demofinal, by = 'zip')
#write_csv(zip_model_dataset, "data/ModelDatasets/zipcodeModel1.csv")

#### DATASET THREE ####

# add in extra drug activity dataset 
zip.extra.drug <- read.csv("data/ZipCodeDrugStats.csv")
names(zip.extra.drug)[1] <- 'zip'
zip.extra.drug <- select(zip.extra.drug, zip, Total.Naxolone.Saves, Overdose.Death.Total)
zip_model_dataset2 <- left_join(zip_model_dataset, zip.extra.drug, by = 'zip')

# write to csv - this corresponds to our 3rd model
#write_csv(zip_model_dataset2, "data/ModelDatasets/zipcodeModel3.csv")

rm(list=ls())

### DATASET 2 ###

  # read in drug arrests 
  drugs <- read.csv("data/si_drugs_mod_arrests.csv")

  # read in zip shapefile 
  zip   <-readOGR(dsn = "shapefiles/ZipCode")

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
  points <- data.frame(x = drugs$longitude,  y = drugs$latitude, id = 1:nrow(drugs), year = drugs$year) 
  points <- st_as_sf(points, coords = c("x", "y"), crs = 4326)

  # Intersection between polygon and points -
  intersection <- st_intersection(x = zip, y = points)

  # Counts 
  intresult <- intersection %>% 
    group_by(zip, year) %>% 
    count() %>%
    select(zip,year,n)
  
  intresult <- intresult %>%
    filter(year, year %in% c(2014, 2015, 2016, 2017))

final_arrest_counts_by_zip_year <- as.data.frame(intresult)[,-4] # lost some observations (4) but that is okay 
final_arrest_counts_by_zip_year$zip <- as.numeric(as.character(final_arrest_counts_by_zip_year$zip))
names(final_arrest_counts_by_zip_year)[3] <- 'no.drug.arrests.14.17'

ems <- read.csv("data/emsdrugs.csv")

final_ems_counts_by_zip_year <- ems %>%
  group_by(zipcode,year) %>%
  count() %>%
  select(zipcode,year,n)

final_ems_counts_by_zip_year <- filter(final_ems_counts_by_zip_year, 
                                          year %in% c(2014,2015,2016,2017))

names(final_ems_counts_by_zip_year)[1] <- 'zip'
names(final_ems_counts_by_zip_year)[3] <- 'no.ems.calls.14.17'

# join arrests and ems counts
zip_model_dataset_year <- left_join(final_arrest_counts_by_zip_year, final_ems_counts_by_zip_year, by = c('zip','year'))

# add demographics 

demo <- read.csv("data/ACS_Demo/ACS.14_17.csv")

demo <- filter(demo, zip %in% c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
                                10312, 10301, 10304, 10305, 10314, 10311, 10313))

demofinal <- demo %>%
            select(zip, Total.Population, Total.Population.Over18, White.Alone,year) %>%
            mutate(proportionWhite = (White.Alone/Total.Population),
                   proportionNonWhite = ((Total.Population-White.Alone)/
                                 Total.Population))%>%
            select(zip, Total.Population, Total.Population.Over18, proportionWhite, proportionNonWhite,year) 


# join demographics with data 
zip_model_dataset_year <- left_join(zip_model_dataset_year, demofinal, by = c('zip','year'))

write_csv(zip_model_dataset_year, "data/ModelDatasets/zipcodeModel2.csv")

#### Dataset Four #### - Some multilevel model 

# read in drug arrests 
drugs <- read.csv("data/si_drugs_mod_arrests.csv")

# read in zip shapefile 
zip <- readOGR(dsn = "shapefiles/ZipCode")

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
points <- data.frame(x = drugs$longitude,  y = drugs$latitude, id = 1:nrow(drugs), year = drugs$year,
                     race = drugs$perp_race)

points <- st_as_sf(points, coords = c("x", "y"), crs = 4326)

# Intersection between polygon and points -
intersection <- st_intersection(x = zip, y = points)

intresult <- intersection %>% 
  group_by(zip, race) %>% 
  count() %>%
  select(zip,race,n)

intresult <- as.data.frame(intresult[,-4])
intresult$race <- as.character(intresult$race)
  
intresult <- intresult %>%
  filter(race %in% c('BLACK', 'HISPANIC', 'WHITE'))

names(intresult)[3] <- 'no.drug.arrests.13.18'

# ems calls
ems <- read.csv("data/emsdrugs.csv")

final_ems_counts_by_zip <- ems %>%
  group_by(zipcode) %>%
  count() %>%
  select(zipcode,n)

names(final_ems_counts_by_zip)[1] <- 'zip'
names(final_ems_counts_by_zip)[2] <- 'no.ems.calls.13.18'
intresult$zip <- as.numeric(as.character(intresult$zip))

# join arrests and ems counts
zip_model_multilevel_race <- left_join(intresult, final_ems_counts_by_zip, by = 'zip')

#demo data
demo <- read.csv("data/ACS_Demo/ACS.14_17.csv")

demo <- filter(demo, zip %in% c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
                                10312, 10301, 10304, 10305, 10314, 10313))

demo <- filter(demo, year == 2017 ) # for lump sum estimates use (ACS 2017 5 year estimates)

demofinal <- demo %>%
  select(zip, Total.Population, Total.Population.Over18, White.Alone) %>%
  mutate(proportionWhite = (White.Alone/Total.Population),
         proportionNonWhite = ((Total.Population-White.Alone)/
                                 Total.Population))%>%
  select(zip, Total.Population, Total.Population.Over18, proportionWhite, proportionNonWhite) 

# join demographics with data 
zip_model_multilevel_race <- left_join(zip_model_multilevel_race, demofinal, by = 'zip')

