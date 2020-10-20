library(tidyverse)
library(here)

data(BlueJays, package = "Stat2Data")

blue_jays <- BlueJays %>%
  select(bird_id = BirdID, sex = KnownSex, bill_depth_mm = BillDepth, bill_width_mm = BillWidth,
         bill_length_mm = BillLength, head_length_mm = Head, body_mass_g = Mass, skull_size_mm = Skull)

write_csv(blue_jays, here("datasets", "blue_jays.csv"))

# A data frame with 123 observations on the following 9 variables.

# bird_id	ID tag for bird
# sex	Sex coded as F or M
# bill_depth_mm	Thickness of the bill measured at the nostril (in mm)
# bill_width_mm	Width of the bill (in mm)
# bill_length_mm	Length of the bill (in mm)
# head_length_mm	Distance from tip of bill to back of head (in mm)
# body_mass_g	Body mass (in grams)
# skull_size_mm	Distance from base of bill to back of skull (in mm)


library(GGally)

blue_jays %>%
  select(-bird_id) %>%
  ggpairs(aes(color = sex), columns = 2:7)


library(corrr)

bj_cor <- blue_jays %>%
  select(-bird_id, -sex) %>%
  correlate() %>%
  rearrange(absolute = FALSE) %>% 
  stretch()

ggplot(bj_cor, aes(y, x, fill = r)) + 
  geom_tile() +
  scale_fill_gradient2(mid = 0)

  