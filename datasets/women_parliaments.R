# Proportion of seats held by women in national parliaments (%)
# Women in parliaments are the percentage of parliamentary seats in a single or lower chamber held by women.
#
# Source: Inter-Parliamentary Union ( IPU ) ( ipu.org ).

library(tidyverse)
library(here)

women_parliaments <- dviz.supp::women_parliaments

write_csv(women_parliaments, here("datasets", "women_parliaments.csv"))
