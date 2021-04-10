#############################################################
#                                                           #
#  Run this script line-by-line in RStudio and follow the   #
#  instructions laid out in the comments.                   #
#                                                           #
#############################################################

# load the require libraries and data
library(tidyverse)
library(palmerpenguins)
library(colorspace)
library(sf)

texas_income <- readRDS(url("https://wilkelab.org/SDS375/datasets/Texas_income.rds"))

# make a scatter plot of the penguin dataset, using default colors
ggplot(penguins, aes(body_mass_g, bill_length_mm, color = species)) +
  geom_point(na.rm = TRUE) +
  theme_bw()

# manually pick three colors for a qualitative color scale
colorspace::hcl_color_picker()

ggplot(penguins, aes(body_mass_g, bill_length_mm, color = species)) +
  geom_point(na.rm = TRUE) +
  theme_bw() +
  scale_color_manual(
    values = ___ # your colors here 
  )

# make a choropleth plot of median income in Texas counties
ggplot(texas_income) +
  geom_sf(aes(fill = median_income)) 

# manually pick four to six colors for a sequential color scale
colorspace::hcl_color_picker()

ggplot(texas_income) +
  geom_sf(aes(fill = median_income)) +
  scale_fill_gradientn(
    colours = ___ # your colors here 
  )

