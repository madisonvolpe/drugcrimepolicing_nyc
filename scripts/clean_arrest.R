#################################
###### Combine NYPD Arrest Data #########
#################################

## Loading libraries 
library(RSocrata)
library(plyr)
library(tidyverse)
library(lubridate)

## Pull in data from Socrata
  
  ## Arrest Data YTD 
  arrestYTD <- read.socrata(url = "https://data.cityofnewyork.us/resource/uip8-fykc.csv")
  ## Convert Date 
  arrestYTD$arrest_date <- lubridate::ymd(arrestYTD$arrest_date)
  ## Add year column 
  arrestYTD$year <- lubridate::year(arrestYTD$arrest_date)
  ## Add month column
  arrestYTD$month <- lubridate::month(arrestYTD$arrest_date)

  ## filter for SI 
  arrestYTD$arrest_boro <- trimws(arrestYTD$arrest_boro)
  arrestYTD.SI <- filter(arrestYTD, arrest_boro == "S")
  
  ## further filter for drug crimes 
  arrestYTD.SI.drugs <- filter(arrestYTD.SI, ofns_desc == "DANGEROUS DRUGS" | pd_desc == "MARIJUANA, POSSESSION" |
                                 pd_desc == "UNLAWFUL SALE SYNTHETIC MARIJUANA" |
                                 pd_desc == "IMPAIRED DRIVING, DRUGS")

        ## most drug releated crimes are under the offense code DANGEROUS DRUGS, but some are hidden in other offense
        ## codes, I identified these hidden values and put them in the filter. 
  
  ## Arrest Data Historic
  arrestHistoric <-read.socrata(url = "https://data.cityofnewyork.us/resource/8h9b-rp9u.csv")
  ## Convert Date 
  arrestHistoric$arrest_date <- lubridate::ymd(arrestHistoric$arrest_date)
  ## Add year column 
  arrestHistoric$year <- lubridate::year(arrestHistoric$arrest_date)
  ## Add month column
  arrestHistoric$month <- lubridate::month(arrestHistoric$arrest_date)

  ## filter for SI 
  arrestHistoric$arrest_boro <- trimws(arrestHistoric$arrest_boro)
  arrestHistoric.SI <- filter(arrestHistoric, arrest_boro == "S")
  
  ## further filter for drug crimes 
  arrestHistoric.SI.drugs <- filter(arrestHistoric.SI, ofns_desc == "DANGEROUS DRUGS" | 
                                 pd_desc == "MARIJUANA, POSSESSION" |
                                 pd_desc == "UNLAWFUL SALE SYNTHETIC MARIJUANA" |
                                 pd_desc == "IMPAIRED DRIVING, DRUGS")
  
## Combine YTD w. Historic Drug Arrests for one dataset
  
  names(arrestHistoric.SI.drugs) == names(arrestYTD.SI.drugs)
  
  si.drugs <- rbind(arrestHistoric.SI.drugs, arrestYTD.SI.drugs)

  ## clean up pd_desc
  
  si.drugs$pd_desc <- str_remove_all(pattern="\\s{2,}", string = si.drugs$pd_desc)
  si.drugs$pd_desc <- str_remove_all(pattern="\\.", string = si.drugs$pd_desc)


  