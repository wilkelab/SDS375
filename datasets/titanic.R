library(tidyverse)
library(here)
library(dviz.supp)

# dviz.supp::titanic only contains information for passengers
# with known age, of which there are 756.
#
# originally taken from Stat2Data::Titanic (which has info on all passengers)

titanic <- dviz.supp::titanic %>%
  mutate(
    survived = ifelse(survived == 1L, "survived", "died")
  )

write_csv(titanic, here("datasets", "titanic.csv"))
