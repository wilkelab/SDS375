library(tidyverse)
library(here)

#csv downloaded from kaggle
# Found here: https://www.kaggle.com/datasets/kamilpytlak/personal-key-indicators-of-heart-disease?resource=download
heart_data <- read_csv(here("datasets", "heart_2020_cleaned.csv"))

set.seed(11859)
new_heart <- heart_data %>%
  select(HeartDisease, BMI, PhysicalHealth, MentalHealth, AgeCategory, SleepTime, Smoking, AlcoholDrinking, PhysicalActivity) %>%
  mutate(ApproximateAge = case_when( # Turning AgeCategory into a numeric variable
    AgeCategory == "18-24" ~ 21,
    AgeCategory == "25-29" ~ 27,
    AgeCategory == "30-34" ~ 32,
    AgeCategory == "35-39" ~ 37,
    AgeCategory == "40-44" ~ 42,
    AgeCategory == "45-49" ~ 47,
    AgeCategory == "50-54" ~ 52,
    AgeCategory == "55-59" ~ 57,
    AgeCategory == "60-64" ~ 62,
    AgeCategory == "65-69" ~ 67,
    AgeCategory == "70-74" ~ 72,
    AgeCategory == "75-79" ~ 77,
    AgeCategory == "80 or older" ~ 85
  )) %>%
  mutate(PhysicalActivity = case_when( # Turning PhysicalActivity into a numeric variable
    PhysicalActivity == "Yes" ~ 1,
    PhysicalActivity == "No" ~ 0,
  )) %>%
  mutate(Smoking = case_when( # Turning Smoking into a numeric variable
    Smoking == "Yes" ~ 1,
    Smoking == "No" ~ 0,
  )) %>%
  mutate(AlcoholDrinking = case_when( # Turning AlcoholDrinking into a numeric variable
    AlcoholDrinking == "Yes" ~ 1,
    AlcoholDrinking == "No" ~ 0,
  )) %>%
  select(-AgeCategory) %>%
  group_by(HeartDisease) %>%
  slice_sample(n = 2000) %>% # keeping 500 random participants with Heart Disease and 500 without Heart Disease.
  ungroup()

new_heart

write_csv(new_heart, here('datasets', "heart_disease_data.csv"))
