#### Exploratory Analysis of Drug Arrests ####
library(plyr)
library(tidyverse)
library(ggplot2)
library(sf) # for shapefiles
library(maptools)
library(rgdal)
library(rgeos)
library(reshape2)

si.drugs <- read.csv("data/si_drugs_arrests.csv")
si.drugs <- si.drugs[-1]

##### Arrests by Precinct 

si.drugs %>%
  group_by(arrest_precinct) %>%
  summarise(n=n()) %>%
  ggplot(aes(x=arrest_precinct, y = n, fill = factor(arrest_precinct))) +
  geom_bar(stat = 'identity') +
  geom_text(aes(label = n), position = position_dodge(width = 0.9))+
  ggtitle("Number of Drug Arrests by Precinct (20173-YTD)") +
  xlab("Precinct") +
  ylab("Number Arrests")

# we can see that the majority of drug arrests are happening in 120 precinct, followed by 121, then 
# 122 and #123 had the least. 

# 120 - Sunnyside, West Brighton, Livingston, Randall Manor, New Brighton, St. George, Ward Hill, Stapleton,
# Clifton, Silver Lake, Gyrmes Hill, Fox Hills, Shore Acres, and Rosebank 

# 121 - Willowbrook, Westerleigh, Port Richmond, Mariner's Harbor, Elm Park, Port Ivory, Chelsea, and Bloomfield

# 122 - Eltingville, Great Kills, Bay Terrace, Oakwood Heights, Oakwood Beach, Lighthouse Hill, New Dorp, Grant City,
# Midland Beach, South Beach, Todt Hill, Old Town, Grasmere and Dongan Hills

# 123 - Tottenville, Huguenot, Rossville, Annadale, and Arden Heights

#### Drug Arrests Year 

si.drugs %>%
  group_by(year) %>%
  summarise(n=n()) %>%
  filter(year != 2018) %>%  # filtering out  2018 bc not full year only until 6/30/2018
  ggplot(aes(x=year,y=n))+
  geom_line() +
  ggtitle("Drug Arrests by Year") +
  ylab("Arrests")

# we can see a peak in 2014, and a decline since then 

#### Drug Arrest by Month facet wrap year 

si.drugs %>%
  group_by(month,year)%>%
  summarise(n=n())%>%
  mutate(mycol = ifelse(n>250,">250", "<250")) %>%
  ggplot(aes(x=factor(month), y = n, fill = mycol)) +
  geom_bar(stat = 'identity')+
  facet_wrap(vars(year)) 

## nothing really telling here! I thought maybe we would see more traffic in summer months but this doesnt 
## appear to be the case. 

# Arrests by Precinct by Race 

si.drugs %>%
  group_by(arrest_precinct,perp_race) %>%
  summarise(n=n()) %>%
  ggplot(aes(x=perp_race, y = n, fill = factor(perp_race)))+
           geom_bar(stat='identity')+
           facet_wrap(vars(arrest_precinct))+
           theme(text = element_text(size = 10),
                 axis.text.x = element_text(angle=90, hjust=1)) + 
  ggtitle("Drug Arrests in each Precinct by Race") +
  xlab("Perpatrator_Race")+
  ylab("Arrests") + 
  guides(fill=guide_legend(title="Race"))
  

##### Precinct Mapping #####

# cleaning 

  # read in precinct shapefile 
  shp <- readOGR(dsn = "shapefiles/Police_Precincts")
  shp@data$id = shp@data$precinct
  
  # transform shape for ggplot2
  shp <- gBuffer(shp, byid=TRUE, width=0) #fixes some problem
  shp.points = fortify(shp, region="id")
  shp.df = plyr::join(shp.points, shp@data, by="id")
  
  # join the drugs data with shp .df by precinct 
  names(si.drugs)[5] <- "precinct"
  
  # filter just do staten island precincts 
  shp.si <- filter(shp.df, precinct %in% c(120, 121, 122,123))
  
# Map showing arrests by race (precinct)
  
  ggplot(shp.si) + 
    aes(long,lat,group=group) + 
    geom_polygon() +
    geom_path(color="white") +
    geom_point(data = si.drugs,aes(x=longitude, y=latitude, col= factor(perp_race)), alpha=0.2, inherit.aes=FALSE) +
    theme_bw() +
    ggtitle("Arrests by Race in each Precinct")
  
# Map showing arrests by age  (precinct)
  
  ggplot(shp.si) + 
    aes(long,lat,group=group) + 
    geom_polygon() +
    geom_path(color="white") +
    geom_point(data = si.drugs,aes(x=longitude, y=latitude, col= factor(age_group)), alpha=0.2, inherit.aes=FALSE) +
    theme_bw() +
    ggtitle("Arrests by Age in each Precinct")

#### Plots w. Classification data by crime (level)

si.drugs.mod <- read.csv("data/si_drugs_mod_arrests.csv")

## Crime Category by Precinct 

si.drugs.mod %>%
  group_by(arrest_precinct) %>%
  summarise(MP_Mis = sum(MP_Mis), MP_Fel = sum(MP_Fel), MS_Mis = sum(MS_Mis), MS_Fel = sum(MS_Fel),
            CSP_Mis = sum(CSP_Mis), CSP_Fel = sum(CSP_Fel), CSS_Fel = sum(CSS_Fel), CSIS_Fel = sum(CSIS_Fel),
            School = sum(School)) %>%
  melt(id.vars = "arrest_precinct") %>%
  ggplot(aes(x=variable, y = value, fill=factor(variable)))+
    geom_bar(stat="identity") +
    facet_wrap(vars(arrest_precinct)) + 
    theme(text = element_text(size = 10),
        axis.text.x = element_text(angle=90, hjust=1)) + 
    ggtitle("Crime Type by Precinct") + 
    xlab("Crime Type")+
    ylab("Arrests") + 
    guides(fill=guide_legend(title="Crime Type"))

## Map for Crime Category by Precinct

ggplot(shp.si) + 
  aes(long,lat,group=group) + 
  geom_polygon() +
  geom_path(color="white") +
  geom_point(data = si.drugs.mod,aes(x=longitude, y=latitude, col= factor()), alpha=0.2, inherit.aes=FALSE) +
  theme_bw() +
  ggtitle("Arrests by Age in each Precinct")    
    
    
    

