library(sf)
library(rworldmap) # for getMap()


world_sf <- st_as_sf(getMap(resolution = "low"))


View(world_sf)

set.seed(1234)
n <- 10000 # number of points

points_sf <-tibble(
  x = runif(n, min = -180, max = 180),
  y = runif(n, min = -90, max = 90),
  row = 1:n
) %>%
  st_as_sf(
    coords = c("x", "y"),
    crs = 4326,
    remove = TRUE
  ) %>%
  st_join(world_sf, st_within) %>%
  filter(!is.na(continent)) %>%
  select(continent, name = NAME, geometry)

continent_cols <- c(
  Africa = "#009E73",
  Antarctica = "#56B4E9",
  Australia = "#D55E00",
  Eurasia = "#CC79A7",
  `North America` = "#E69F00",
  `South America` = "#0072B2"
)

ggplot(points_sf) + 
  geom_sf(aes(color = continent), size = 0.1) +
  scale_color_manual(values = continent_cols)

scattermap <- st_coordinates(points_sf) %>% 
  as_tibble() %>%
  rename(x = X, y = Y) %>%
  cbind(points_sf) %>%
  select(continent, name, x, y)

ggplot(scattermap, aes(x, y, color = continent)) + 
  geom_point(size = 0.2) +
  scale_color_manual(values = continent_cols)


pca_fit <- scattermap %>% 
  select(where(is.numeric)) %>% # retain only numeric columns
  scale() %>%       # scale to zero mean and unit variance
  prcomp()          # do PCA


library(broom)  # for augment(), tidy()

pca_fit %>%
  augment(scattermap) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = continent)) +
  geom_point(size = 0.2) +
  scale_color_manual(values = continent_cols)

library(poliscidata)
# see: https://rdrr.io/cran/poliscidata/man/world.html
world

world_fit <- world %>%
  select(where(is.numeric)) %>%
  mutate(across(.fns = ~ifelse(is.na(.x), mean(.x, na.rm = TRUE), .x))) %>%
  scale() %>%
  prcomp

world_fit %>%
  augment(world) %>% # add original dataset back in
  ggplot(aes(.fittedPC2, .fittedPC3, color = regionun)) +
  geom_point(size = 0.5)# +
  #scale_color_manual(values = continent_cols)
  