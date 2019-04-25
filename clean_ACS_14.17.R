library(tidyverse)

ACS.17 <- read.csv("data/ACS_Demo/ACS_2017.csv")
ACS.16 <- read.csv("data/ACS_Demo/ACS_2016.csv")
ACS.15 <- read.csv("data/ACS_Demo/ACS_2015.csv")
ACS.14 <- read.csv("data/ACS_Demo/ACS_2014.csv")

# select relevant variables

ACS.17.c <- select(ACS.17, Id2, Estimate..SEX.AND.AGE...Total.population, Estimate..SEX.AND.AGE...18.years.and.over,
        Estimate..RACE...One.race...White, Estimate..RACE...One.race...Black.or.African.American,
        Estimate..RACE...Two.or.more.races,Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Hispanic.or.Latino..of.any.race.,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...White.alone,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Black.or.African.American.alone,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...American.Indian.and.Alaska.Native.alone,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Asian.alone,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Native.Hawaiian.and.Other.Pacific.Islander.alone,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Some.other.race.alone,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Two.or.more.races,
        Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.housing.units) %>%
        mutate(year=2017)

ACS.16.c <- select(ACS.16, Id2, Estimate..SEX.AND.AGE...Total.population, Estimate..SEX.AND.AGE...18.years.and.over,
                   Estimate..RACE...One.race...White, Estimate..RACE...One.race...Black.or.African.American,
                   Estimate..RACE...Two.or.more.races,Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Hispanic.or.Latino..of.any.race.,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...White.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Black.or.African.American.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...American.Indian.and.Alaska.Native.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Asian.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Native.Hawaiian.and.Other.Pacific.Islander.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Some.other.race.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Two.or.more.races,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.housing.units)%>%
                   mutate(year=2016)

ACS.15.c <- select(ACS.15, Id2, Estimate..SEX.AND.AGE...Total.population, Estimate..SEX.AND.AGE...18.years.and.over,
                   Estimate..RACE...One.race...White, Estimate..RACE...One.race...Black.or.African.American,
                   Estimate..RACE...Two.or.more.races,Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Hispanic.or.Latino..of.any.race.,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...White.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Black.or.African.American.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...American.Indian.and.Alaska.Native.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Asian.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Native.Hawaiian.and.Other.Pacific.Islander.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Some.other.race.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Two.or.more.races,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.housing.units) %>%
                   mutate(year=2015)

ACS.14.c <- select(ACS.14, Id2, Estimate..SEX.AND.AGE...Total.population, Estimate..SEX.AND.AGE...18.years.and.over,
                   Estimate..RACE...One.race...White, Estimate..RACE...One.race...Black.or.African.American,
                   Estimate..RACE...Two.or.more.races,Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Hispanic.or.Latino..of.any.race.,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...White.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Black.or.African.American.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...American.Indian.and.Alaska.Native.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Asian.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Native.Hawaiian.and.Other.Pacific.Islander.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Some.other.race.alone,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.population...Not.Hispanic.or.Latino...Two.or.more.races,
                   Estimate..HISPANIC.OR.LATINO.AND.RACE...Total.housing.units) %>%
                   mutate(year=2014)

# join in relevant dataset 
ACS <- rbind(ACS.14.c, ACS.15.c, ACS.16.c, ACS.17.c)

# change names of df
names(ACS) <- c('zip', 'Total.Population', 'Total.Population.Over18',
                'White', 'Black', 'Two.Races', 'Hispanic.Latino', 'Not.Hispanic.Latino',
                'White.Alone', 'Black.Alone', 'Native.Alone',
                'Asian.Alone', 'PacificIslander.Alone',
                'Some.Other.Race.Alone', 'Two.More.Races.Alone',
                'Total.Housing.Units', 'year')

# filter for SI zipcodes
ACS  <- filter(ACS, zip %in% c(10304, 10305, 10306, 10307, 10301, 10302, 10303, 10308,
                               10309, 10310, 10311, 10312, 10313, 10314))

write_csv(ACS, "data/ACS_Demo/ACS.14_17.csv")
