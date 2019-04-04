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

demo <- read.csv("data/DemoByZipACS2017.csv")

demo <- filter(demo, Id2 %in% c(10302, 10303, 10310, 10306, 10307, 10308, 10309, 
                        10312, 10301, 10304, 10305, 10314, 10311, 10313))

demofinal <- demo %>%
            select(Id2, Estimate..Total., Estimate..Total....White.alone) %>%
            mutate(proportionWhite = (Estimate..Total....White.alone/Estimate..Total.),
                   proportionNonWhite = ((Estimate..Total.-Estimate..Total....White.alone)/
                                            Estimate..Total.))%>%
            select(Id2, Estimate..Total.,proportionWhite, proportionNonWhite) %>%
            filter(Id2 != 10311)

names(demofinal)[1] <- 'zip'

# join demographics with data 
zip_model_dataset <- left_join(zip_model_dataset, demofinal, by = 'zip')

write_csv(zip_model_dataset, "zipcodeModel1.csv")


