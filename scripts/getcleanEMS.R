library(soql)
library(jsonlite)
library(tidyverse)
library(RSocrata)

# EMS Incident Dispatch Data
# FROM: https://dev.socrata.com/foundry/data.cityofnewyork.us/66ae-7zpy

# API CALL 

# soql query to only get Staten Island entries
surl <- soql() %>%
  soql_add_endpoint('https://data.cityofnewyork.us/resource/66ae-7zpy.json') %>%
  soql_simple_filter("borough", "RICHMOND / STATEN ISLAND") %>%
  soql_limit(351448)%>% # I figure out using soql that the number of rows in dataset pertaining to SI was 351448
  #soql_offset(1000) %>%
  as.character()

# API token
token <- "kQZdHWZoaGCuyRTdOGcpm9hqs"

# Add API Token to URL
url <-validateUrl(url = surl, app_token = token)

# FROM API get data, converts to df 
ems <-fromJSON(url)

# write to csv 

# upload 
ems <- read.csv("data/ems_original.csv")
ems <- ems[-1]

# CLEANING  
str(ems)

 #change borough to SI 
 ems$borough <- as.character(ems$borough)
 ems$borough <- "SI"
 
 # ems add a year column, based off incident year 
 ems$year <- lubridate::year(ems$incident_datetime)
 
 #see if incident id is completely unique 
 length(unique(ems$cad_incident_id)) == nrow(ems) # each incident is truly unique
 
 #clean datetime variables - remove characters and convert to date,hms 
 
    # create function
    cleandt <- function(x){
      x <- stringr::str_replace_all(string = x, pattern = 'T', replacement = " ")
      x <- lubridate::ymd_hms(x)
      return(x)
    }
    
    # apply to columns ending with date time 
    
    ems <- ems %>%
           mutate_at(vars(ends_with("datetime")), list(cleandt))
  
   #check incident range 
   range(ems$incident_datetime) #we have from Jan 1, 2013 to Dec 31, 2018 (# 4 years of data)
      
 # initial call type / final call type (these are subjective - based on the caller, we should note that
   #final call type does not change based on ambulance crew (always based on the caller))
   
   unique(ems$initial_call_type)
   unique(ems$final_call_type)

 # initial/ final severity level code 
   unique(ems$initial_severity_level_code)
   unique(ems$final_severity_level_code)  
 
 # VALID_DISPATCH_RSPNS_TIME_INDC / DISPATCH_RESPONSE_SECONDS_QY
   unique(ems$valid_dispatch_rspns_time_indc)
   str(ems$dispatch_response_seconds_qy)

 # VALID_INCIDENT_RSPNS_TIME_INDC / INCIDENT_RESPONSE_SECONDS_QY
   unique(ems$valid_incident_rspns_time_indc)
   str(ems$incident_response_seconds_qy)
   
 # INCIDENT_TRAVEL_TM_SECONDS_QY
   str(ems$incident_travel_tm_seconds_qy)

 # HELD_INDICATOR
   str(ems$held_indicator)

# INCIDENT_DISPOSITION_CODE 
   # 82	transporting patient
   # 83	patient pronounced dead
   # 87	cancelled
   # 90	unfounded
   # 91	condition corrected
   # 92	treated not transported
   # 93	refused medical aid
   # 94	treated and transported
   # 95	triaged at scene no transport
   # 96	patient gone on arrival
   # CANCEL	cancelled
   # DUP	duplicate incident
   # NOTSNT	unit not sent
   # ZZZZZZ	no disposition
   
   unique(ems$incident_disposition_code)
   ems <- filter(ems, ems$incident_disposition_code != 87) # filter out cancelled EMS dispatches 
   
# atom
   unique(ems$atom)
   table(ems$atom)

# incident dispatch area / police precints 
   unique(ems$incident_dispatch_area)
   table(ems$incident_dispatch_area) # it appears that some incident dispatch areas are outside SI, if I am assessing
                                     # this properly
   
# found good webiste that breaks it down to precincts / fire battalions 
   # S1 - links to 120 precinct 
   # S2 - links to 122 precinct
   # S3 - links to 123 precinct 
    
   table(ems$incident_dispatch_area) # some fall out of SI we should filter these out 
   table(ems$policeprecinct) # some fall out 
   
   ems <- filter(ems, incident_dispatch_area %in% c("S1", "S2", "S3")) #filter only on SI dispatch area 
   ems <- filter(ems, policeprecinct %in% c(120,121,122,123)) #filter only on SI police precincts 

# CALL TYPE DESCRIPTIONS 
   
   # DRUG - DRUG ALCOHOL ABUSE
   # DRUGFC - DRUG ALCOHOL ABUSE, FEVER + COUGH 
   
   ems.drugs <- filter(ems, initial_call_type %in% c("DRUG", "DRUGFC") | final_call_type %in% c("DRUG", "DRUGFC"))
   
# one last thing check initial call type versus final call type, I will create indicator variable decide on
# if we drop them later 
   ems.drugs <- ems.drugs %>% 
     mutate(initial_call_type = as.character(initial_call_type)) %>%
     mutate(final_call_type = as.character(final_call_type)) %>%
     mutate(indic = case_when(
       initial_call_type == final_call_type ~ "No Drop",
       !initial_call_type %in% c("DRUG", "DRUGFC") & final_call_type %in% c("DRUG", "DRUGFC") ~ "No Drop",
       initial_call_type  %in% c("DRUG", "DRUGFC") & !final_call_type %in% c("DRUG", "DRUGFC") ~ "Drop"
     ))

# write to csv 

write_csv(ems.drugs, "emsdrugs.csv")
