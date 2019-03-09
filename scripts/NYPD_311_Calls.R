#################################
###### 311 Service Requests #########
#################################

library(plyr)
library(lubridate)
library(tidyverse)
library(RSocrata)

token <- "kQZdHWZoaGCuyRTdOGcpm9hqs"
NYPD_311 <- read.socrata("https://data.cityofnewyork.us/resource/fhrw-4uyv.json?agency=NYPD", app_token = token)

NYPD_311 <- read.csv("data/NYPD_311.CSV")
