library(haven)
library(tidyverse)

death_ct<-read_sas("data/ctract10_14.sas7bdat")

# deaths due to use of or poisoning by psychoactive substance (excluding alcohol, tobacco) 2010-2014
# all tracts that begin with 085 are Staten Island! 

drug_CT <-death_ct %>%
  select(CTRACT, "_10")%>%
  filter(grepl("^085", CTRACT))

# census tracts with total number of deaths under 25 for 5 years have been censored.

write.csv(drug_CT, "death_psychoactive_CT.csv")
