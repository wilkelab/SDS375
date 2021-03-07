library(here)
library(tidyverse)
library(cowplot)

country_list = c("United States", "China", "India", "Japan", "Algeria",
                 "Brazil", "Germany", "France", "United Kingdom", "Italy", "New Zealand",
                 "Canada", "Mexico", "Chile", "Argentina", "Norway", "South Africa", "Kenya",
                 "Israel", "Iceland")

internet <- dviz.supp::internet %>%
  filter(country %in% country_list, year > 1993) %>%
  mutate(users = ifelse(is.na(users), 0, users))

write_csv(internet, here("datasets", "internet.csv"))

internet %>%
  mutate(
    country = fct_reorder(country, users, min)
  ) %>%
  ggplot(aes(x = year, y = country, fill = users)) +
  geom_tile(color = "white", size = 0.25) +
  scale_fill_viridis_c(
    option = "A", begin = 0.05, end = 0.98,
    limits = c(0, 100),
    name = "internet users / 100 people",
    guide = guide_colorbar(
      direction = "horizontal",
      label.position = "bottom",
      title.position = "top",
      ticks = FALSE,
      barwidth = grid::unit(3.5, "in"),
      barheight = grid::unit(0.2, "in")
    )
  ) +
  scale_x_continuous(expand = c(0, 0), name = NULL) +
  scale_y_discrete(name = NULL, position = "right") +
  theme_half_open(12) +
  theme(
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.ticks.length = grid::unit(1, "pt"),
    legend.position = "top",
    legend.justification = "left",
    legend.title.align = 0.5,
    legend.title = element_text(size = 12*12/14)
  )
