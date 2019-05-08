library(plyr)
library(tidyverse)
library(ggplot2)
library(sf) # for shapefiles
library(maptools)
library(rgdal)
library(rgeos)
library(reshape2)

## Motivation One: Race Map of zipcodes 

# read in Census Tract shapefile 
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

# racial composition map 
ggplot(shp.df) +
  aes(long,lat,group=group) + 
  geom_polygon(aes(fill = proportionNonWhite)) +
  scale_fill_gradient(low = "black", high = "red") +
  geom_path(color="white") + 
  theme_bw() +
  labs(title = "Racial Makeup of Staten Island",
       subtitle = "The proportion of non-white people in each zip code",
       caption = "Source: ACS 2017",
       fill = NULL) 

# naxolone saves by zip code 
ggplot(shp.df) +
  aes(long,lat,group=group) + 
  geom_polygon(aes(fill = Total.Naxolone.Saves)) +
  scale_fill_gradient(low = "black", high = "red") +
  geom_path(color="white") + 
  theme_bw() +
  labs(title = "The Drug Epidemic on Staten Island ",
       subtitle = "Total naxolone saves (2016-2018) in each zip code",
       caption = "Source: Staten Island Drug Prevention Portal",
       fill = NULL) 
  
# fatal overdoses by zip code
ggplot(shp.df) +
  aes(long,lat,group=group) + 
  geom_polygon(aes(fill = Overdose.Death.Total)) +
  scale_fill_gradient(low = "black", high = "red") +
  geom_path(color="white") + 
  theme_bw() +
  labs(title = "The Drug Epidemic on Staten Island ",
       subtitle = "Total overdose deaths (2016-2018) in each zip code",
       caption = "Source: Staten Island Drug Prevention Portal",
       fill = NULL) 

# examining the nypd arrest dataset to explain in pres 

arrests <- read.csv("./data/si_drugs_mod_arrests.csv")

arrests <- arrests %>%
  mutate(cat = case_when(
    grepl("MARIJUANA, POSSESSION", pd_desc) ~ 'Marijuana Possession',
    grepl("MARIJUANA, SALE", pd_desc) ~ 'Marijuana Sale',
    grepl("CONTROLLED SUBSTANCE,POSSESS", pd_desc) | 
      grepl("CONTROLLED SUBSTANCE, POSSESSION", pd_desc) | 
      grepl("CONTROLLED SUBSTANCE, POSSESSI", pd_desc)~ "Controlled Substance Possession",
    grepl("CONTROLLED SUBSTANCE,SALE", pd_desc) |
      grepl("CONTROLLED SUBSTANCE, SALE", pd_desc) |
      grepl("CONTROLLED SUBSTANCE,INTENT TO SELL", pd_desc) |
      grepl("CONTROLLED SUBSTANCE, INTENT TO SELL", pd_desc) ~ "Controlled Substance Sell",
    !grepl("MARIJUANA", pd_desc) | !grepl("CONTROLLED SUBSTANCE", pd_desc) ~ 'Misc'
  ))

arrests %>%
  filter(cat != 'Misc') %>%
  group_by(pd_desc, cat) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = pd_desc, y = n)) +
    geom_bar(stat = 'identity') +
    facet_wrap(~cat, scales = 'free') +
    coord_flip() +
    labs(title = "Drug Arrests on Staten Island",
       subtitle = "Distribution of Categories",
       caption = "Source: NYC Open Data",
       fill = NULL) 

# Examining the EMS dispatch data to explain in pres  
ems2 <- read.csv("./data/emsdrugs.csv")


# EDA for Final Presentation

## Arrests v. by Racial Composition

zip.results <- zip.results %>%
                mutate(MajorityNonWhite = ifelse(proportionNonWhite > .50, 'Yes', 'No'))

ggplot(zip.results, aes(x = no.ems.calls.13.18, y = no.drug.arrests.13.18, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Within each zip code",
       x = 'EMS Calls 2013 - 2018',
       y = 'Drug Arrests 2013 - 2018',
       caption = "Source: NYC Open Data, 2017 ACS",
       fill = NULL) 
  
ggplot(zip.results, aes(x = Total.Naxolone.Saves, y = no.drug.arrests.13.18, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Within each zip code",
       x = 'Naxolone Saves 2016 - 2018',
       y = 'Drug Arrests 2013 - 2018',
       caption = "Source: NYC Open Data, SI Drug Prevention Dashboard",
       fill = NULL) 

ggplot(zip.results, aes(x = Overdose.Death.Total, y = no.drug.arrests.13.18, color=MajorityNonWhite)) +
  geom_point() + 
  labs(title = "Drug Arrests v. Drug Activity",
       subtitle = "Within each zip code",
       x = 'Overdose Deaths 2016 - 2018',
       y = 'Drug Arrests 2013 - 2018',
       caption = "Source: NYC Open Data, SI Drug Prevention Dashboard",
       fill = NULL) 



# Poisson Regression Explanation Final Pres

mod1 <- read.csv("./data/ModelDatasets/zipcodeModel1.csv")

ggplot(data = mod1, aes(x=reorder(factor(zip),-no.drug.arrests.13.18), y=no.drug.arrests.13.18, group =1))+
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(size = 10, angle = 25, hjust = 1)) +
  labs(title = "Skewed Distribution of Drug Arrests",
       subtitle = "Within each zip code",
       x = 'Zip code',
       y = 'Drug Arrests 2013 - 2018',
       caption = "Source: NYC Open Data",
       fill = NULL) 

ggplot(data = mod1, aes(x=reorder(factor(zip),-no.drug.arrests.13.18), y=no.drug.arrests.13.18, group =1))+
  geom_bar(stat = 'identity') +
  theme(axis.text.x = element_text(size = 10, angle = 25, hjust = 1)) +
  stat_smooth(method = 'glm', method.args = list(family = poisson)) +
  labs(title = "Skewed Distribution of Drug Arrests",
       subtitle = "With Logarithmic Smoother",
       x = 'Zip code',
       y = 'Drug Arrests 2013 - 2018',
       caption = "Source: NYC Open Data",
       fill = NULL)





