# Inspired by:
# https://github.com/amrrs/animated_bar_charts_in_R

library(tidyverse)
library(here)

# downloaded from https://data.worldbank.org/indicator/NY.GDP.MKTP.CD
# on 05/05/2021
# License: CC BY-4.0 
# Indicator:
# NY.GDP.MKTP.CD	GDP (current US$)	GDP at purchaser's prices is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the products. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in current U.S. dollars. Dollar figures for GDP are converted from domestic currencies using single year official exchange rates. For a few countries where the official exchange rate does not reflect the rate effectively applied to actual foreign exchange transactions, an alternative conversion factor is used.	World Bank national accounts data, and OECD National Accounts data files.

gdp_tidy <- read_csv(here("datasets", "gdp_raw.csv"), skip = 3) %>%
  select(-`Indicator Name`, -`Indicator Code`, -`2020`) %>%
  rename(country = `Country Name`, country_code = `Country Code`) %>%
  pivot_longer(cols = c(-country, -country_code), names_to = "year", values_to = "gdp") %>%
  mutate(year = as.numeric(year))

# to filter out non-country entities
gdp_non_country <- read_csv(here("datasets", "gdp_non_countries.csv"))

top_10_countries = gdp_tidy %>%
  na.omit() %>%
  filter(year == 2019, !country_code %in% gdp_non_country$country_code) %>%
  arrange(desc(gdp)) %>%
  slice(1:10) %>%
  pull(country)

gdp_ranked <- gdp_tidy %>%
  filter(country %in% top_10_countries) %>%
  filter(year >= 1970) %>% 
  group_by(year) %>%
  mutate(
    rank = rank(-gdp),
    gdp = signif(gdp / 1e9, 3), # express gdp in billions
    gdp_rel = gdp/gdp[rank == 1]
  ) %>%
  ungroup()

write_csv(gdp_ranked, here("datasets", "gdp_ranked.csv"))

# Animation

library(gganimate)

# minimal example
gdp_ranked %>%
  filter(year %% 4 == 0) %>%
  mutate(
    rank = fct_rev(factor(rank))
  ) %>%
  ggplot(aes(gdp, rank, group = country, fill = country)) +
  geom_col() +
  #facet_wrap(vars(year)) + NULL
  transition_states(year)

# example with labels, improved design
p <- gdp_ranked %>%
  filter(year %% 2 == 0) %>%
  mutate(
    rank = fct_rev(factor(rank)),
    label = scales::comma(gdp, 1),
    highlight = ifelse(country == "China", "China", "other")
  ) %>%
  ggplot(
    aes(
      gdp, rank, group = country,
      color = highlight, fill = highlight
    )
  ) +
  geom_col(alpha = 0.8) +
  geom_text(
    aes(x = -200, label = country),
    hjust = 1, size = 12/.pt
  ) +
  geom_text(
    aes(x = gdp + 200, label = label),
    hjust = 0, size = 12/.pt
  ) +
  scale_color_manual(
    aesthetics = c("color", "fill"),
    values = c(
      other = "gray35", China = "#AB4A39"
    ),
    guide = "none"
  ) +
  scale_x_continuous(
    name = "GDP (billions USD)",
    limits = 1000*c(-7, 23),
    breaks = 1000*c(0, 5, 10, 15, 20),
    labels = scales::comma
  ) +
  labs(
    title = "China's rise in GDP",
    subtitle = "Year: {closest_state}"
  ) +
  theme_minimal_vgrid(12, rel_small = 1) +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.y = element_blank(),
    axis.title.x = element_text(hjust = 1)
  ) +
  #facet_wrap(vars(year)) + NULL
  transition_states(year, transition_length = 5)

animate(p, width = 96*6, height = 96*6, res = 96)
anim_save("~/Desktop/bar_race.gif")

library(ggrepel)

p <- gdp_ranked %>%
  filter(
    #TRUE
    country %in% c("China", "Japan", "United States", "Germany", "Brazil")
  ) %>%
  mutate(
    label = glue::glue(" {country}")
  ) %>%
  ggplot(aes(year, gdp, color = country)) +
  geom_line() +
  geom_point(size = 3) +
  geom_text_repel(
    aes(label = label),
    hjust = 0,
    nudge_x = 1,
    direction = "y",
    xlim = c(NA, Inf),
    size = 14/.pt
  ) +
  scale_y_log10(name = "GDP (billion USD)", labels = scales::comma) +
  scale_color_manual(
    values = c("#009E73", "#404040", "#0072B2", "#D55E00", "#CC79A7"),
    guide = "none"
  ) +
  coord_cartesian(clip = "off") +
  theme_minimal_hgrid(14, rel_small = 1) +
  theme(plot.margin = margin(7, 100, 7, 7)) +
  transition_reveal(year)

animate(p, width = 96*8, height = 96*0.618*8, res = 96)
anim_save("~/Desktop/line_race.gif")
