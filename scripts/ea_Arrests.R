#### Exploratory Analysis of Drug Arrests ####
library(tidyverse)
library(ggplot2)

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

#### Plots w. Frankie's data by crime (level)

si.drugs.mod <- read.csv("data/si_drugs_mod_arrests.csv")

