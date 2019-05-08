#### Exploratory Data Analysis of calls made to EMS (filtered for Drugs + for SI )

library(plyr)
library(tidyverse)
library(ggplot2)

## read in data 
ems <- read.csv("data/emsdrugs.csv")

## By year 

ems %>%
  group_by(year) %>%
  summarise(n=n()) %>%
  ggplot(aes(x=year, y=n)) +
    geom_line() +
    ggtitle("EMS calls Related to Drugs by Year")

## Which precinct is most prominent ? 

ems %>%
  group_by(policeprecinct) %>%
  summarise(n=n()) %>%
  ggplot(aes(x=policeprecinct, y = n)) +
    geom_bar(stat = 'identity') +
    geom_text(aes(label = n), position = position_dodge(width = 0.9)) +
    ggtitle("EMS calls w. Initial or Final Call Type Related to Drugs") 

## EMS calls by precinct and by year 

ems %>%
  group_by(year, policeprecinct) %>%
  summarise(n=n()) %>%
  ggplot(aes(x = year, y = n)) +
    geom_line()+ 
    facet_wrap(vars(policeprecinct))


## FROM WIKIPEDIA AND I KIND OF AGREE WITH IT 

##Generally, the North Shore is deemed to include the communities located within ZIP codes 10303, 10302 and 10310 in their 
## entirety, along with all of the area covered by 10301 except Sunnyside, and those parts of 
## 10304, 10305, 10314 that lie north of the Staten Island Expressway. 
## This definition includes Mariners Harbor, Port Richmond, Westerleigh, Meiers Corners, Graniteville, Castleton Corners, 
## West Brighton, New Brighton, St. George, Tompkinsville, Stapleton, Grymes Hill, Park Hill, Clifton, and Rosebank 
## among the North Shore's neighborhoods. 
## The Staten Island Expressway is considered by many to be a southern border.

## Analysis by zipcode 

ems %>%
  group_by(zipcode) %>%
  summarise(n=n()) %>%
  arrange(desc(n)) %>% 
  ggplot(aes(x=factor(zipcode), y=n)) +
    geom_bar(stat='identity') +
    geom_text(aes(label = n), position = position_dodge(width = 0.9)) + 
    ggtitle('EMS Calls Related to Drugs by Zipcode')

## Analysis by year + zip 
ems %>%
  group_by(year, zipcode) %>%
  summarise(n=n()) %>%
  ggplot(aes(x = year, y = n)) +
  geom_line()+ 
  facet_wrap(vars(zipcode))

## I will now label zipcodes by being on North Shore, South Shore, or Border (between North + South)

ems <- ems %>%
  mutate(ShoreIndicator = case_when(
    zipcode %in% c(10303, 10302, 10310) ~ "North Shore",
    zipcode %in% c(10304, 10305, 10314) ~ "Border",
    zipcode %in% c(10306, 10307,10308,10309, 10311, 10312, 10313, 10314) ~ "South Shore",
    zipcode == 10301 ~ 'Mostly North'
  ))

## Crimes by Label 

ems %>%
  group_by(ShoreIndicator) %>%
  summarise(n=n()) %>%
  ggplot(aes(x=ShoreIndicator, y = n)) +
    geom_bar(stat = 'identity') +
    geom_text(aes(label = n), position = position_dodge(width = 0.9)) + 
    ggtitle("EMS Calls Related to Drugs by Shore")

#10301 - should consider that the 10301 zipcode contains the St. George Terminal 


## Zipcode analysis with demographics 

demo <- read.csv("data/DemoByZipACS2017.csv")
names(demo)[2] <- "zipcode"

ems_demo <- left_join(ems, demo, by = 'zipcode')

zipWhite<-ems_demo %>%
  select(zipcode, Estimate..Total., Estimate..Total....White.alone) %>%
  mutate(percentWhite = (Estimate..Total....White.alone/Estimate..Total.)*100,
         percentnonWhite = ((Estimate..Total.-Estimate..Total....White.alone)/
                              Estimate..Total.)*100) %>%
  distinct(zipcode, percentWhite, percentnonWhite)

ems %>%
  group_by(zipcode) %>%
  summarise(n=n()) %>%
  arrange(desc(n)) %>% 
  left_join(zipWhite) %>%
  ggplot(aes(x = percentnonWhite, y = n)) +
    geom_point() + 
    geom_line() +
    labs(title = "Number of EMS calls v. Percent Nonwhite",
       subtitle = "By zip code",
       x = 'Percent Non White',
       y = 'EMS Calls 2013 - 2017',
       caption = "Source: NYC Open Data, 2017 ACS",
       fill = NULL) 

## Food for thought 

## On Staten Island, home is where the heroin is.
## Statistics from local law enforcement show that 80 of the 90 heroin-overdose victims in the borough last year died 
## inside their own homes and apartments.

























