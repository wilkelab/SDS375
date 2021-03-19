library(here)
library(tidyverse)

BA_degrees <- dviz.supp::BA_degrees %>%
  select(-year_str)

write_csv(BA_degrees, here("datasets", "BA_degrees.csv"))
