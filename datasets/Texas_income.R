library(tidyverse)
library(sf)
library(here)

texas_income <- practicalgg::texas_income %>%
  st_drop_geometry() %>% 
  extract(NAME, into = "county", regex = "(.+) County, Texas") %>%
  select(-variable) %>%
  rename(median_income = estimate, FIPS = GEOID) %>%
  st_set_geometry(st_geometry(practicalgg::texas_income))

saveRDS(texas_income, here("datasets", "Texas_income.rds"))

ggplot(texas_income, aes(fill = median_income)) + 
  geom_sf() +
  coord_sf(crs = 3083)

ggplot(texas_income, aes(fill = median_income)) + 
  geom_sf() +
  coord_sf(crs = 3338) # Alaska

ggplot(texas_income, aes(fill = median_income)) + 
  geom_sf() +
  coord_sf(crs = 32139)

ggplot(texas_income, aes(fill = median_income)) + 
  geom_sf() +
  coord_sf(crs = 3857)

ggplot(texas_income, aes(fill = median_income)) + 
  geom_sf() +
  coord_sf(crs = 4326)
