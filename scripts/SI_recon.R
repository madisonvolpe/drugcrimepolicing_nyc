library(tidyverse)

stat.is<-read.csv("data/si_drugs_arrests.csv")
pl <- read.csv("data/PDCODE_PenalLaw.csv")

# join with penal codes

  # clean codes, remove punc etc.   
  pl$LAW_NYS <- gsub("\\.", "", pl$LAW_NYS)
  pl$LAW_NYS <- gsub("\\s{2,}", "",pl$LAW_NYS)
  names(pl)[2] <- "law_code"
  
  #join with penal codes
  joined <- left_join(stat.is, pl, by = c("law_code"))
  
  #find failed ones, reason: some have extra 0s at the end
  failed <- joined[is.na(joined$PDCODE_VALUE) & is.na(joined$LIT_LONG) & is.na(joined$CATEGORY) & is.na(joined$LIT_SHORT),]
  failed <- unique(failed$law_code)
  
  #for those that failed originally, remove the padded 0s, rematch with the penal law codes
  joined <- joined %>%
    mutate(law_code = ifelse(law_code %in% failed, gsub("00$", "", law_code), law_code)) %>%
    left_join(pl, by = c("law_code")) %>%
    select(-CATEGORY.x, -LIT_LONG.x, -LIT_SHORT.x, -X, -PDCODE_VALUE.x)

  joined$LIT_SHORT.y <- as.character(joined$LIT_SHORT.y)
  sum(is.na(joined$LIT_SHORT.y)) #can confirm that there is only 10 not matched 
  
# Frankie's old code 
  
  # stat.is$arrest_date<-as.Date(stat.is$arrest_date)
  # range(stat.is$arrest_date)
  # stat.is$ofns_desc<-as.character(stat.is$ofns_desc)
  # str(stat.is)
  # stat.is$Marijuana<-ifelse(grepl("MARIJUANA",stat.is$pd_desc,ignore.case = T),1,0)
  # stat.is$Sale<-ifelse(grepl("SALE",stat.is$pd_desc,ignore.case = T),1,0)
  # stat.is$Intent<-ifelse(grepl("SELL",stat.is$pd_desc,ignore.case = T),1,0)
  # stat.is$School<-ifelse(grepl("SCHOOL",stat.is$pd_desc,ignore.case = T),1,0)

joined$law_cat_cd <- as.character(joined$law_cat_cd)

joined <- joined %>% 
  mutate(MP_Mis = ifelse(grepl("marijuana", pd_desc,ignore.case = T) & 
                          grepl("possession", pd_desc, ignore.case = T) &
                          law_cat_cd == "M" , 1,0),
         MP_Fel = ifelse(grepl("marijuana", pd_desc,ignore.case = T) & 
                           grepl("possession", pd_desc, ignore.case = T) &
                           law_cat_cd == "F" , 1,0),
         MS_Mis = ifelse(grepl("marijuana", pd_desc,ignore.case = T) & 
                           grepl("sale", pd_desc, ignore.case = T) &
                           law_cat_cd == "M" , 1,0),
         MS_Fel = ifelse(grepl("marijuana", pd_desc,ignore.case = T) & 
                           grepl("sale", pd_desc, ignore.case = T) &
                           law_cat_cd == "F" , 1,0), 
         CSP_Mis = ifelse(grepl("controlled", pd_desc,ignore.case = T) & 
                            grepl("possess", pd_desc, ignore.case = T) &
                            law_cat_cd == "M" , 1,0),
         CSP_Fel = ifelse(grepl("controlled", pd_desc,ignore.case = T) & 
                            grepl("possess", pd_desc, ignore.case = T) &
                            law_cat_cd == "F" , 1,0),
         CSS_Mis = ifelse(grepl("controlled", pd_desc,ignore.case = T) & 
                            grepl("sale", pd_desc, ignore.case = T) &
                            law_cat_cd == "M" , 1,0),
         CSS_Fel = ifelse(grepl("controlled", pd_desc,ignore.case = T) & 
                            grepl("sale", pd_desc, ignore.case = T) &
                            law_cat_cd == "F" , 1,0),
         CSIS_Mis = ifelse(grepl("controlled", pd_desc,ignore.case = T) & 
                            grepl("intent", pd_desc, ignore.case = T) &
                            law_cat_cd == "M" , 1,0),
         CSIS_Fel = ifelse(grepl("controlled", pd_desc,ignore.case = T) & 
                             grepl("intent", pd_desc, ignore.case = T) &
                             law_cat_cd == "F" , 1,0),
         School = ifelse(grepl("school", pd_desc,ignore.case = T),1,0)
         ) %>%
        select(-CSS_Mis, -CSIS_Mis)
  
write.csv(joined,file="si_drugs_mod_arrests.csv")
