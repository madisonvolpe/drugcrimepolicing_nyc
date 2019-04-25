library(plyr)
library(tidyverse)
library(lubridate)

stopfrisk <- read.csv("data/sqf_08_16.csv")


stopfrisk_rel <- filter(stopfrisk, year > 2012)
stopfrisk_rel$city <- as.character(stopfrisk_rel$city)


stopfrisk_rel <- filter(stopfrisk_rel, city %in% c("STATEN IS", "STATEN ISLAND"))
stopfrisk_reldrugs  <- filter(stopfrisk_rel, stopped.bc.drugs == TRUE)
