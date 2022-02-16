

library(tidyverse)
library(here)
library(Stat2Data)

data("NCbirths")

data <- NCbirths %>%
  mutate( # insert some problem cases
    Gained = replace_na(Gained, "#N/A"),
    Weeks = replace_na(Weeks, -999)
  )

write_csv(data, here("datasets", "NCbirths.csv"))


## documentation taken from Stat2Data package
#\name{NCbirths}
#\alias{NCbirths}
#\docType{data}
#\title{North Carolina Birth Records}
#\description{
#  Data from births in North Carolina in 2001
#}
#%\useage{data(NCbirths)}
#\format{
#  A dataset with 1450 observations on the following 15 variables.
#  \tabular{rl}{
#    \code{ID} \tab {Patient ID code}\cr
#    \code{Plural} \tab {\code{1}=single birth, \code{2}=twins, \code{3}=triplets}\cr
#    \code{Sex} \tab { Sex of the baby \code{1}=male \code{2}=female}\cr
#    \code{MomAge} \tab {Mother's age (in years)}\cr
#    \code{Weeks} \tab {Completed weeks of gestation}\cr
#    \code{Marital} \tab {Marital status: \code{1}=married or \code{2}=not married}\cr
#    \code{RaceMom} \tab {Mother's race: \code{1}=white, \code{2}=black, \code{3}=American Indian, \code{4}=Chinese}\cr
#    \tab {\code{5}=Japanese, \code{6}=Hawaiian, \code{7}=Filipino, or \code{8}=Other Asian or Pacific Islander}\cr
#    \code{HispMom} \tab {Hispanic origin of mother: \code{C}=Cuban, \code{M}=Mexican, \code{N}=not Hispanic}\cr
#    \tab {\code{O}=Other Hispanic, \code{P}=Puerto Rico, \code{S}=Central/South America}\cr
#    \code{Gained} \tab {Weight gained during pregnancy (in pounds)}\cr
#    \code{Smoke} \tab {Smoker mom? \code{1}=yes or \code{0}=no}\cr
#    \code{BirthWeightOz} \tab {Birth weight in ounces}\cr
#    \code{BirthWeightGm} \tab {Birth weight in grams}\cr
#    \code{Low} \tab {Indicator for low birth weight, \code{1}=2500 grams or less}\cr
#    \code{Premie} \tab {Indicator for premature birth, \code{1}=36 weeks or sooner}\cr
#    \code{MomRace} \tab {Mother's race: \code{black}, \code{hispanic}, \code{other}, or  \code{white}}\cr
#  }
#}
#\details{
#This dataset contains data on a sample of 1450 birth
#records that statistician John Holcomb selected from the North Carolina State Center for Health
#and Environmental Statistics.
#}
#\source{
#Thanks to John Holcomb at Cleveland State University for sharing these data.
#}
