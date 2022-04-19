library(tidyverse)
library(here)

# Data from World Happiness report taken from:
# https://www.kaggle.com/datasets/unsdsn/world-happiness. 

# loading data
happiness_raw <- read.csv(file = here("datasets", "happiness-raw.csv"), header=TRUE, sep=",")

# data prep:
happiness <- happiness_raw %>%
  select(Country, Happiness.Score.1, Economy..GDP.per.Capita..1, Family, Health..Life.Expectancy..1, Freedom, Trust..Government.Corruption..1, Generosity, Dystopia.Residual.1, year) %>%
  rename(
    "country" = Country,
    "happiness_score" = Happiness.Score.1,
    "GDP" = Economy..GDP.per.Capita..1,
    "family_score" = Family,
    "health_life_expectancy_score" = Health..Life.Expectancy..1,
    "freedom_score" = Freedom,
    "government_trust_score" = Trust..Government.Corruption..1,
    "generosity_score" = Generosity,
    "dystopia_score" = Dystopia.Residual.1) %>%
  na.omit() %>%
  filter(year == 2015) %>%
  select(-year) %>%
  filter(country %in%
           c("Switzerland", "Denmark", "Canada", "Finland", "Netherlands", "Canada", "Iceland", "United States", "Australia",
             "Peru", "Argentina", "Germany", "Saudi Arabia", "Nicaragua", "Turkey", "Vietnam", "Jordan", "China",
             "Afghanistan", "Japan", "Madagascar", "Burundi", "Chad", "Togo", "Yemen"))

write_csv(happiness, here("datasets", "happiness.csv"))

