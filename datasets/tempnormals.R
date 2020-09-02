library(tidyverse)
library(here)
library(dviz.supp)

month_names <- c(
  "01" = "Jan", "02" = "Feb", "03" = "Mar", "04" = "Apr", "05" = "May", "06" = "Jun",
  "07" = "Jul", "08" = "Aug", "09" = "Sep", "10" = "Oct", "11" = "Nov", "12" = "Dec"
)

month_days <- c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
month_days_cum <- c(0, cumsum(month_days))

temps_long <- ncdc_normals %>%
  filter(
    station_id %in% c(
      "USW00014819", # Chicago, IL 60638
      "USC00042319", # Death Valley, CA 92328 hottest point in the US
      "USW00093107", # San Diego, CA 92145
      "USW00012918" # Houston, TX 77061
    )
  ) %>%
  mutate(
    location = fct_recode(
      factor(station_id),
      "Chicago" = "USW00014819",
      "Death Valley" = "USC00042319",
      "San Diego" = "USW00093107",
      "Houston" = "USW00012918"
    )
  ) %>%
  mutate(
    location = factor(
      location, levels = c("Death Valley", "Houston", "San Diego", "Chicago")
    )
  ) %>%
  mutate(
    month_name = month_names[month]
  ) %>%
  mutate(
    month_name = factor(month_name, levels = unname(month_names))
  ) %>%
  mutate(
    day_of_year = month_days_cum[as.numeric(month)] + as.numeric(day)
  ) %>%
  select(
    location, station_id, temperature, month_name, month, day, date, day_of_year
  )

write_csv(temps_long, here("datasets", "tempnormals.csv"))

ggplot(temps_long, aes(x = day_of_year, y = temperature, color = location)) +
  geom_line(size = 1)

mean_temps <- temps_long %>%
  group_by(location, month) %>%
  summarize(mean = mean(temperature))

ggplot(mean_temps, aes(x = month, y = location, fill = mean)) + 
  geom_tile(width = .95, height = 0.95) + 
  scale_fill_viridis_c(
    option = "B", begin = 0.15, end = 0.98,
    name = "temperature (°F)"
  ) +
  coord_fixed(expand = FALSE)

  