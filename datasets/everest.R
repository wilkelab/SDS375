library(tidyverse)
library(here)

# dataset from tidy tuesday:
# https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-09-22/readme.md
# Also: https://www.himalayandatabase.com/.

members <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-22/members.csv')

everest <- members %>%
  filter(peak_name == "Everest")

write_csv(everest, here("datasets", "everest.csv"))
