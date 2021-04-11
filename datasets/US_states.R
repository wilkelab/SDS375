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

US_states_AKsmall <- dviz.supp::US_states_geoms$albers_revised %>%
  left_join(state_codes)

label_coords <- US_states_AKsmall$geometry %>%
  sf::st_zm() %>%
  sf::st_point_on_surface() %>%
  sf::st_coordinates()

US_states_AKsmall$label_x <- label_coords[, 1]
US_states_AKsmall$label_y <- label_coords[, 2]

# manually adjust label positions
US_states_AKsmall <- US_states_AKsmall %>%
  mutate(
    label_x = case_when(
      state_code == "HI" ~ label_x + 180000,
      state_code == "MI" ~ label_x + 180000,
      TRUE ~ label_x
    ),
    label_y = case_when(
      state_code == "AK" ~ label_y + 50000,
      state_code == "ID" ~ label_y - 150000,
      state_code == "MI" ~ label_y - 300000,
      TRUE ~ label_y  
    )
  )

saveRDS(US_states_AKsmall, here("datasets", "US_states_AKsmall.rds"))

US_states <- dviz.supp::US_states_geoms$us_albers %>%
  left_join(state_codes)
saveRDS(US_states, here("datasets", "US_states.rds"))

US_counties_AKsmall <- dviz.supp::US_counties_geoms$us_albers %>%
  left_join(state_codes, by = c(STATEFP = "GEOID"))
saveRDS(US_counties_AKsmall, here("datasets", "US_counties_AKsmall.rds"))

US_counties <- dviz.supp::US_counties_geoms$albers_revised %>%
  left_join(state_codes, by = c(STATEFP = "GEOID"))
saveRDS(US_counties, here("datasets", "US_counties.rds"))

ggplot(US_states_AKsmall) + 
  geom_sf() +
  geom_text(
    aes(x = label_x, y = label_y, label = state_code),
    size = 9/.pt
  ) +
  theme_void()

ggplot(US_states) + 
  geom_sf() +
  theme_void()

ggplot(US_counties_AKsmall) + 
  geom_sf() +
  theme_void()

ggplot(US_counties) + 
  geom_sf() +
  theme_void()





