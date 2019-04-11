library(soql)
library(jsonlite)
library(tidyverse)
library(RSocrata)

# 311 Service Requests 
# FROM: https://data.cityofnewyork.us/resource/fhrw-4uyv.json

# API CALL 

# soql query to only get Staten Island entries
surl <- soql() %>%
  soql_add_endpoint('https://data.cityofnewyork.us/resource/fhrw-4uyv.json') %>%
  soql_simple_filter("borough", "STATEN ISLAND") %>%
  soql_limit(1006806)%>% # I figure out using soql that the number of rows in dataset pertaining to SI was 1006806
  #soql_offset(1000) %>%
  as.character()

# API token
token <- "kQZdHWZoaGCuyRTdOGcpm9hqs"

# Add API Token to URL
url <-validateUrl(url = surl, app_token = token)

# FROM API get data, converts to df 
x_311 <-fromJSON(url)

#Derelict Vehicle
#Derelict Vehicles
#Non-Emergency Police Matter
#Smoking
#Drug Activity
#Emergency Response Team (ERT)

x_311_drugs <- filter(x_311,complaint_type == 'Drug Activity')
x_311_drugs <- x_311_drugs[,-c(35:42)]

# clean created + closed date

cleandt <- function(x){
  x <- stringr::str_replace_all(string = x, pattern = 'T', replacement = " ")
  x <- lubridate::ymd_hms(x)
  return(x)
}

x_311_drugs$created_date <- cleandt(x_311_drugs$created_date)
x_311_drugs$closed_date  <- cleandt(x_311_drugs$closed_date)

x_311_drugs$createdYear <- lubridate::year(x_311_drugs$created_date)
x_311_drugs$closedYear <- lubridate::year(x_311_drugs$closed_date)

# does createdYear == closedYear
sum(x_311_drugs$createdYear == x_311_drugs$closedYear) == nrow(x_311_drugs)

## Analysis ## 

# agency 
unique(x_311_drugs$agency) # only NYPD 

# descriptor 
unique(x_311_drugs$descriptor) # Use Indoor, Use Outside
table(x_311_drugs$descriptor) # More Indoor than Outdoor 

# add in shore indicator 
x_311_drugs <- x_311_drugs %>% 
  mutate(ShoreIndicator = case_when(
  incident_zip %in% c(10303, 10302, 10310) ~ "North Shore",
  incident_zip %in% c(10304, 10305, 10314) ~ "Border",
  incident_zip %in% c(10306, 10307,10308,10309, 10311, 10312, 10313, 10314) ~ "South Shore",
  incident_zip == 10301 ~ 'Mostly North'
))

# by zip
x_311_drugs %>%
  group_by(incident_zip) %>%
  summarise(n=n())

# by shore 
x_311_drugs %>%
  group_by(ShoreIndicator) %>%
  summarise(n=n())

# shore indicator by inside/outside distinction
x_311_drugs %>%
  group_by(ShoreIndicator) %>%
  count(descriptor)



