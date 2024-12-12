ver="0.1.0"

library(dplyr)
library(readxl)
library(foreign)

data <- read.csv("/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_releases/0.1.0/ffcws-demo-dataset-0.1.0.csv")
data$timepoint <-1



harmonized_data<-data[,c("idnum", "timepoint","ck6yagem","cm1bsex","ck6ethrace")]%>%
  dplyr::mutate(nsrrid=idnum,
                nsrr_age=ck6yagem,
                nsrr_race=dplyr::case_when(
                  ck6ethrace==1 ~ "white",
                  ck6ethrace==2 ~ "black or african american",
                  ck6ethrace==3 ~ "hispanic",
                  ck6ethrace==5 ~ "multiple",
                  ck6ethrace==4 ~ "other",
                  ck6ethrace=="-2"~"unknown",
                  TRUE ~ "not reported"
                ),
                nsrr_sex=dplyr::case_when(
                  cm1bsex==1 ~ "male",
                  cm1bsex==2 ~ "female",
                  TRUE ~ "not reported"
                ))
write.csv(harmonized_data,file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_releases/0.1.0/ffcws-harmonized-dataset-0.1.0.csv", row.names = FALSE, na='')
