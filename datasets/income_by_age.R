library(tidyverse)
library(here)

income_by_age <- dviz.supp::income_by_age %>%
  filter(race %in% c("white", "asian", "black", "hispanic")) %>%
  mutate(
    race = fct_relevel(race, c("asian", "white", "hispanic", "black")),
    race = fct_recode(race, Asian = "asian", Hispanic = "hispanic"),
    age = fct_recode(age, "≥ 75" = "> 74"),
    age_brief = fct_recode(
      age,
      "15–24" = "15 to 24",
      "25–34" = "25 to 34",
      "35–44" = "35 to 44",
      "45–54" = "45 to 54",
      "55–64" = "55 to 64",
      "65–74" = "65 to 74"
    )
  )

saveRDS(income_by_age, here("datasets", "income_by_age.rds"))
