library(tidyverse)
library(here)

US_census <- dviz.supp::US_census %>%
   mutate(
     FIPS = sprintf("%05i", FIPS)
   )

write_csv(US_census, here("datasets", "US_census.csv"))

library(ggrepel)

set.seed(3878)
tx_counties <- US_census %>% 
  filter(state == "Texas") %>%
  select(name, pop2010) %>%
  extract(name, "county", regex = "(.+) County") %>%
  mutate(popratio = pop2010/median(pop2010)) %>%
  arrange(desc(popratio)) %>%
  mutate(
    index = 1:n(),
    label = ifelse(index <= 3 | index > n()-3 | runif(n()) < .04, county, ""),
    label_large = ifelse(index <= 6, county, "")
  )

ggplot(tx_counties, aes(x = index, y = popratio)) +
  geom_hline(yintercept = 1, linetype = 2, color = "grey40") +
  geom_point(size = 0.5, color = "#0072B2") +
  geom_text_repel(
    aes(label = label),
    size = 12/.pt,
    point.padding = .4, color = "black",
    min.segment.length = 0,
    max.overlaps = 1000
  ) +
  scale_y_log10(
    breaks = c(.01, .1, 1, 10, 100),
    name = "population number / median",
    labels = expression(10^-2, 10^-1, 10^0, 10^1, 10^2)
  ) +
  scale_x_continuous(
    limits = c(.5, nrow(tx_counties) + .5), expand = c(0, 0),
    breaks = NULL, #c(1, 50*(1:5)),
    name = "Texas counties, from most to least populous"
  ) +
  theme_minimal_hgrid(16) +
  theme(axis.line = element_blank())

ggplot(tx_counties, aes(x = index, y = popratio)) +
  geom_point(size = 0.5, color = "#0072B2") +
  geom_text_repel(
    aes(label = label_large),
    size = 12/.pt,
    point.padding = .4, color = "black",
    min.segment.length = 0,
    max.overlaps = 1000
  ) +
  scale_y_continuous(name = "population number / median") +
  scale_x_continuous(
    limits = c(.5, nrow(tx_counties) + .5), expand = c(0, 0),
    breaks = NULL, #c(1, 50*(1:5)),
    name = "Texas counties, from most to least populous"
  ) +
  theme_minimal_hgrid(16) +
  theme(axis.line = element_blank())
