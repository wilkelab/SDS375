library(tidyverse)
library(ggridges) # for lincoln_weather
library(cowplot)
library(ggforce)
library(lubridate)
library(here)

lincoln_temps <- lincoln_weather %>%
  mutate(
    date = ymd(CST),
    month_long = Month,
    month = fct_recode(
      Month,
      Jan = "January",
      Feb = "February",
      Mar = "March",
      Apr = "April",
      May = "May",
      Jun = "June",
      Jul = "July",
      Aug = "August",
      Sep = "September",
      Oct = "October",
      Nov = "November",
      Dec = "December"
    ),
    mean_temp = `Mean Temperature [F]`
  ) %>%
  select(date, month, month_long, mean_temp) %>%
  mutate(month = fct_rev(month)) # fct_recode() places levels in reverse order 

saveRDS(lincoln_temps, here("datasets", "lincoln_temps.rds"))

ggplot(lincoln_temps, aes(x = month, y = mean_temp)) +
  geom_boxplot(fill = "gray90") + 
  xlab("month") + 
  ylab("mean temperature (°F)") +
  theme_half_open()

ggplot(lincoln_temps, aes(x = month, y = mean_temp)) +
  geom_violin(fill = "gray90") + 
  xlab("month") + 
  ylab("mean temperature (°F)") +
  theme_half_open()

ggplot(lincoln_temps, aes(x = month, y = mean_temp)) +
  geom_point(
    position = position_jitter(width = .15, height = 0, seed = 320),
    size = 0.75
  ) +
  xlab("month") + 
  ylab("mean temperature (°F)") +
  theme_half_open()

ggplot(lincoln_temps, aes(x = month, y = mean_temp)) +
  geom_violin(color = NA, fill = "gray90") + 
  geom_sina(size = 0.75) + 
  xlab("month") + 
  ylab("mean temperature (°F)") +
  theme_half_open()

ggplot(lincoln_temps, aes(x = mean_temp, y = month_long)) +
  geom_density_ridges(
    scale = 3,
    rel_min_height = 0.01,
    bandwidth = 3.4,
    fill = lighten("#56B4E9", .3),
    color = "white"
  ) +
  scale_x_continuous(
    name = "mean temperature (°F)",
    expand = c(0, 0), breaks = c(0, 25, 50, 75)
  ) +
  scale_y_discrete(name = NULL, expand = expansion(add = c(0.2, 2.6))) +
  theme_minimal_grid() +
  theme(
    axis.text.y = element_text(vjust = 0)
  )

ggplot(lincoln_temps, aes(x = mean_temp, y = month_long)) +
  geom_density_ridges(
    scale = 3,
    rel_min_height = 0.01,
    bandwidth = 3.4
  )
