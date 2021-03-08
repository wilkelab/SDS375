library(here)
library(tidyverse)
library(cowplot)
library(lubridate)

preprints <- dviz.supp::preprint_growth %>%
  mutate(date_dec = decimal_date(date))

write_csv(preprints, here("datasets", "preprints.csv"))


biorxiv_growth <- preprints %>%
  filter(archive == "bioRxiv", count > 0)

expfit.out <- nls(
  count ~ a*exp(b*(date_dec-2014)),
  data = biorxiv_growth,
  start = c(a = 60.004, b = .773)
)
linfit.out <- nls(
  log(count) ~ log(a) + b*(date_dec-2014),
  data = biorxiv_growth,
  start = c(a = 42.576, b = .878)
)
date_seq = seq(min(biorxiv_growth$date_dec), max(biorxiv_growth$date_dec), by = 0.1)
expfit.df <- data.frame(
  date_dec = date_seq,
  count = predict(expfit.out, data.frame(date_dec = date_seq))
)
linfit.df <- data.frame(
  date_dec = date_seq,
  count = exp(predict(linfit.out, data.frame(date_dec = date_seq)))
)

ggplot(biorxiv_growth, aes(date_dec, count)) + 
  geom_line(data = expfit.df, aes(color = "expfit"), size = .5, linetype = 2) +
  geom_point(aes(fill = "expfit"), shape = NA, na.rm = TRUE) + # dummy for legend
  geom_line(aes(color = "data"), size = .5) +
  geom_point(aes(fill = "data"), color = "white", shape = 21, size = 2) +
  scale_y_continuous(
    limits = c(0, 1550),
    breaks = c(0, 500, 1000, 1500),
    expand = c(0, 0),
    name = "preprints / month"
  ) + 
  scale_x_continuous(name = NULL) +
  scale_color_manual(
    name = NULL,
    values = c(data = "#0072B2", expfit = "black"),
    breaks = c("data", "expfit"),
    labels = c("actual counts", "exponential fit"),
    guide = guide_legend(
      override.aes = list(
        color = c("white", "black"),
        shape = c(21, NA),
        size = c(2, 0.5),
        linetype = c(0, 2)
      )
    )
  ) +
  scale_fill_manual(
    name = NULL,
    values = c(data = "#0072B2", expfit = "black"),
    breaks = c("data", "expfit"),
    labels = c("actual counts", "exponential fit")
  ) +
  theme_half_open() +
  theme(
    legend.position = c(.05, 1),
    legend.justification = c(0, 1),
    legend.spacing.x = unit(3, "pt"),
    legend.title = element_blank(), 
    plot.margin = margin(7, 7, 3, 1.5)
  )
