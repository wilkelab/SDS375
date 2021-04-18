library(tidyverse)
library(sf)
library(ggrepel)
library(here)

state_codes <- read_csv(file = 
"name,state_code,GEOID
Alabama,AL,01
Alaska,AK,02
Arizona,AZ,04
Arkansas,AR,05
California,CA,06
Colorado,CO,08
Connecticut,CT,09
Delaware,DE,10
District of Columbia,DC,11
Florida,FL,12
Georgia,GA,13
Hawaii,HI,15
Idaho,ID,16
Illinois,IL,17
Indiana,IN,18
Iowa,IA,19
Kansas,KS,20
Kentucky,KY,21
Louisiana,LA,22
Maine,ME,23
Maryland,MD,24
Massachusetts,MA,25
Michigan,MI,26
Minnesota,MN,27
Mississippi,MS,28
Missouri,MO,29
Montana,MT,30
Nebraska,NE,31
Nevada,NV,32
New Hampshire,NH,33
New Jersey,NJ,34
New Mexico,NM,35
New York,NY,36
North Carolina,NC,37
North Dakota,ND,38
Ohio,OH,39
Oklahoma,OK,40
Oregon,OR,41
Pennsylvania,PA,42
Rhode Island,RI,44
South Carolina,SC,45
South Dakota,SD,46
Tennessee,TN,47
Texas,TX,48
Utah,UT,49
Vermont,VT,50
Virginia,VA,51
Washington,WA,53
West Virginia,WV,54
Wisconsin,WI,55
Wyoming,WY,56
American Samoa,AS,60
Guam,GU,66
Northern Mariana Islands,MP,69
Puerto Rico,PR,72
Virgin Islands,VI,78")

US_states_AKsmall <- dviz.supp::US_states_geoms$us_albers %>%
  left_join(state_codes)

label_coords <- US_states_AKsmall$geometry %>%
  sf::st_zm() %>%
  sf::st_point_on_surface() %>%
  sf::st_coordinates()

US_states_AKsmall$label_x <- label_coords[, 1]
US_states_AKsmall$label_y <- label_coords[, 2]

# manually adjust label positions
labels_pos <- read_csv(
  file="state_code,xoff,yoff,hjust,vjust,segment
AK,  30000,   70000,  0.5, 0.5, FALSE
CT, 450000, -140000,  0, 0.5, TRUE
DC, 450000, -390000,  0, 0.5, TRUE
DE, 150000,  -70000,  0, 0.5, TRUE
HI, 150000,       0,  0, 0.5, FALSE
ID,      0, -180000,  0.5, 0.5, FALSE
MA, 450000,  150000,  0, 0.5, TRUE
MD, 450000,  -230000,  0, 0.5, TRUE
MI, 180000, -300000,  0.5, 0.5, FALSE
NH, -160000,  240000, 0.5, -.1, TRUE
NJ, 400000,  -100000,  0, 0.5, TRUE
RI, 450000,   20000, 0, 0.5, TRUE
VT, -290000, 140000,  1, 0.5, TRUE
")

US_states_AKsmall2 <- US_states_AKsmall %>%
  left_join(labels_pos, by = "state_code") %>%
  mutate(
    label_xend = label_x,
    label_yend = label_y,
    label_x = ifelse(is.na(xoff), label_x, label_x + xoff),
    label_y = ifelse(is.na(yoff), label_y, label_y + yoff),
    hjust = ifelse(is.na(hjust), 0.5, hjust),
    vjust = ifelse(is.na(vjust), 0.5, vjust),
    segment = ifelse(is.na(segment), FALSE, segment)
  )

ggplot(US_states_AKsmall2) + 
  geom_sf() +
  geom_text(
    aes(x = label_x, y = label_y, label = state_code, hjust = hjust, vjust = vjust),
    size = 9/.pt
  ) +
  geom_segment(
    data = filter(US_states_AKsmall2, segment == TRUE),
    aes(x = label_x, y = label_y, xend = label_xend, yend = label_yend)
  ) +
  theme_void() +
  coord_sf(default_crs = NULL)

saveRDS(US_states_AKsmall2, here("datasets", "US_states_AKsmall.rds"))

US_states <- dviz.supp::US_states_geoms$albers_revised %>%
  left_join(state_codes)
saveRDS(US_states, here("datasets", "US_states.rds"))

US_counties_AKsmall <- dviz.supp::US_counties_geoms$us_albers %>%
  left_join(state_codes, by = c(STATEFP = "GEOID"))
saveRDS(US_counties_AKsmall, here("datasets", "US_counties_AKsmall.rds"))

US_counties <- dviz.supp::US_counties_geoms$albers_revised %>%
  left_join(state_codes, by = c(STATEFP = "GEOID"))
saveRDS(US_counties, here("datasets", "US_counties.rds"))

ggplot(US_states) + 
  geom_sf() +
  theme_void()

ggplot(US_counties_AKsmall) + 
  geom_sf() +
  theme_void()

ggplot(US_counties) + 
  geom_sf() +
  theme_void()



US_states <- readRDS(url("https://wilkelab.org/SDS375/datasets/US_states_AKsmall.rds"))

ggplot(US_states) + 
  geom_sf() +
  geom_text(
    aes(x = label_x, y = label_y, label = state_code, hjust = hjust, vjust = vjust),
    size = 9/.pt
  ) +
  geom_segment(
    data = filter(US_states, segment == TRUE),
    aes(x = label_x, y = label_y, xend = label_xend, yend = label_yend)
  ) +
  theme_void() +
  coord_sf(default_crs = NULL)


