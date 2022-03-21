library(tidyverse)
library(usdata)
library(here)

US_state_stats <- usdata::state_stats %>%
  mutate(
    popdens2010 = pop2010/land_area
  ) %>%
  select(-abbr, -fips, -pop2000, -pop2010, -land_area)

write_csv(US_state_stats, here("datasets", "US_state_stats.csv"))

US_state_stats %>%
  column_to_rownames(var = "state") %>%
  scale() %>%
  dist(method = "euclidean") %>%
  hclust(method = "ward.D2") %>%
  ggdendrogram(rotate = TRUE)

US_regions <- read_csv(here("datasets", "US_regions.csv"))

dhc <- US_state_stats %>%
  column_to_rownames(var = "state") %>%
  scale() %>%
  dist(method = "euclidean") %>%
  hclust(method = "ward.D2") %>%
  as.dendrogram()

# Rectangular lines
ddata <- dendro_data(dhc, type = "rectangle")
segments <- segment(ddata)
labels <- label(ddata) %>%
  left_join(US_regions, by = c("label" = "state"))

ggplot() + 
  geom_segment(data = segments, aes(y, x, xend = yend, yend = xend)) + 
  geom_text(data = labels, aes(y, x, label = label, color = region), hjust = 1) +
  scale_x_continuous(limits = c(-10, 25)) +
  theme_void()

head(segment(ddata))
head(label(ddata))
