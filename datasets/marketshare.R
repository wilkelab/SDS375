# Example recreated after:
# https://en.wikipedia.org/wiki/File:Piecharts.svg
# Original example by: https://commons.wikimedia.org/wiki/User:Schutz

library(tidyverse)
library(here)

marketshare <- tibble(
  percent = c(17, 18, 20, 22, 23, 20, 20, 19, 21, 20, 23, 22, 20, 18, 17),
  company = rep(LETTERS[1:5], 3),
  year = rep(c("2015", "2016", "2017"), each = 5)
)

write_csv(marketshare, here("datasets", "marketshare.csv"))
