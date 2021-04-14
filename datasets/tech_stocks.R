library(tidyverse)
library(lubridate)
library(here)

tech_stocks <- dviz.supp::tech_stocks %>% ungroup()

write_csv(tech_stocks, here("datasets", "tech_stocks.csv"))

tech_stocks <- read_csv(here("datasets", "tech_stocks.csv")) %>%
  mutate(date = ymd(date))

ggplot(tech_stocks, aes(x = date, y = price_indexed, color = ticker)) +
  geom_line(size = 0.66, na.rm = TRUE) +
  scale_color_manual(
    values = c("#000000", "#E69F00", "#56B4E9", "#009E73"),
    name = "",
    breaks = c("GOOG", "AAPL", "FB", "MSFT"),
    labels = c("Alphabet", "Apple", "Facebook", "Microsoft")
  ) +
  scale_x_date(
    name = "year",
    limits = c(ymd("2012-06-01"), ymd("2017-05-31")),
    expand = c(0,0)
  ) + 
  scale_y_continuous(
    name = "stock price, indexed",
    limits = c(0, 560),
    expand = c(0,0)
  ) +
  theme_minimal()
