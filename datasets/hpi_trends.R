library(here)
library(tidyverse)
library(lubridate)
library(cowplot)

hpi_trends <- dviz.supp::house_prices %>%
  filter(year(date) >= 1980) %>%
  mutate(
    date_numeric = as.numeric(date),
    hpi = house_price_index,
    log_hpi = log(hpi)
  ) %>%
  group_by(state) %>%
  mutate(
    hpi_trend = {
      coefs <- coef(lm(log_hpi ~ date_numeric))
      exp(coefs[1] + coefs[2]*date_numeric)
    },
    hpi_detrended = hpi/hpi_trend
  ) %>%
  select(-house_price_index, -log_hpi)

write_csv(hpi_trends, here("datasets", "hpi_trends.csv"))


hpi_trends %>%
  filter(state %in% c("California", "Nevada", "West Virginia", "Texas")) %>%
  ggplot(aes(date, hpi)) +
  geom_line(aes(y = hpi_trend), color = "grey50", size = 0.4) +
  geom_line(color = "#0072B2", size = 0.75) +
  scale_x_date(name = NULL) +
  scale_y_log10(name = "House Price Index (Dec. 2000 = 100)") +
  facet_wrap(~state, scales = "free_x") +
  theme_minimal_hgrid() +
  theme(
    strip.text = element_text(size = 12),
    strip.background = element_rect(fill = "grey85"),
    axis.line.x = element_line(color = "grey50"),
    axis.ticks.x = element_line(color = "grey50"),
    axis.ticks.y = element_blank(),
    axis.text.y = element_text(margin = margin(0, 0, 0, 0))
  )

hpi_trends %>%
  filter(state %in% c("California", "Nevada", "West Virginia", "Texas")) %>%
  ggplot(aes(date, hpi_detrended)) +
  geom_hline(yintercept = 1, color = "grey50", size = 0.4) +
  geom_line(color = "#0072B2", size = 0.75) +
  scale_x_date(name = NULL) +
  scale_y_log10(
    name = "House Price Index (detrended)",
    breaks = c(0.752, 1, 1.33, 1.77),
    labels = c("0.75", "1.00", "1.33", "1.77")
  ) +
  facet_wrap(~state, scales = "free_x") +
  theme_minimal_hgrid() +
  theme(
    strip.text = element_text(size = 12),
    strip.background = element_rect(fill = "grey85"),
    axis.line.x = element_line(color = "grey50"),
    axis.ticks.x = element_line(color = "grey50"),
    axis.ticks.y = element_blank(),
    axis.text.y = element_text(margin = margin(0, 0, 0, 0))
  )
