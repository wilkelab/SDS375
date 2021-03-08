library(here)
library(tidyverse)
library(cowplot)

cars93 <- MASS::Cars93

write_csv(cars93, here("datasets", "cars93.csv"))

ggplot(cars93, aes(x = Price, y = Fuel.tank.capacity)) + 
  geom_point(color = "grey60") + 
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x, color = "#0072B2") +
  scale_x_continuous(
    name = "price (USD)",
    breaks = c(20, 40, 60),
    labels = c("$20,000", "$40,000", "$60,000")
  ) +
  scale_y_continuous(name = "fuel-tank capacity\n(US gallons)") +
  theme_minimal_grid()
