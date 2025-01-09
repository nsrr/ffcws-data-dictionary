ver="0.1.0"

library(dplyr)
library(readxl)
library(foreign)

data <- read.csv("/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_source/ffcws_yr15_demo_20240806.csv")
data$timepoint <-1
data<-data%>%mutate(ck6yagem = ifelse(ck6yagem == "-9", '', ck6yagem),ck6yagem = as.numeric(ck6yagem))
#write.csv(data,file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_releases/0.1.0.pre/ffcws-demo-dataset-0.1.0.pre.csv", row.names = FALSE, na='')


harmonized_data <- data[, c("idnum", "timepoint", "ck6yagem", "cm1bsex", "ck6ethrace")] %>% 
  dplyr::mutate(
    ck6yagem = ifelse(ck6yagem == "-9", '', ck6yagem),# replace -9 with empty string
    ck6yagem = as.numeric(ck6yagem),
    nsrrid = idnum,
    nsrr_age = round(ck6yagem / 12, 1),  # convert age from months to years with 1 decimal place
    nsrr_race = dplyr::case_when(
      ck6ethrace == 1 ~ "white",
      ck6ethrace == 2 ~ "black or african american",
      ck6ethrace == 3 ~ "hispanic",
      ck6ethrace == 5 ~ "multiple",
      ck6ethrace == 4 ~ "other",
      ck6ethrace == "-2" ~ "unknown",
      TRUE ~ "not reported"
    ),
    nsrr_sex = dplyr::case_when(
      cm1bsex == 1 ~ "male",
      cm1bsex == 2 ~ "female",
      TRUE ~ "not reported"
    )
  ) %>%
  select(nsrrid, timepoint, nsrr_age, nsrr_sex, nsrr_race)


write.csv(harmonized_data,file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_releases/0.1.0.pre/ffcws-harmonized-dataset-0.1.0.pre.csv", row.names = FALSE, na='')


act_data <- read.csv("/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_source/FFCWS_y15_personlevel_sleepactigraphy/ACT_wave62024v2.csv")
act_data$timepoint <-1

merged_data <- merge(act_data, data, 
                   by = c("idnum", "timepoint"), 
                   all = TRUE)

write.csv(merged_data,file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20240206-buxton-future-families/nsrr-prep/_releases/0.1.0.pre/ffcws-dataset-0.1.0.pre.csv", row.names = FALSE, na='')

