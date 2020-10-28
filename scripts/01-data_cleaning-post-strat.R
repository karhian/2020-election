#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from [...UPDATE ME!!!!!]
# Author: Rohan Alexander and Sam Caetano [CHANGE THIS TO YOUR NAME!!!!]
# Data: 22 October 2020
# Contact: rohan.alexander@utoronto.ca [PROBABLY CHANGE THIS ALSO!!!!]
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(math)
library(haven)
library(tidyverse)
# Read in the raw data. 
raw_data <- read_dta("data/usa_00001.dta.gz")
# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
names(raw_data)

#selecting variables of interest
reduced_data <- 
  raw_data %>% 
  select(age,
         race,
         hcovany,
         educ,
         educd,
         schltype,
         vetstat)


#### What's next? ####
#grouping the ages
reduced_data <- reduced_data %>% 
  mutate(age_range = if_else(1 <= as.numeric(age) & as.numeric(age) <= 17,'0-17 years old', 
                    if_else(18 <= as.numeric(age) & as.numeric(age) <= 30, '18-30 years old', 
                            if_else(31 <= as.numeric(age) & as.numeric(age) <= 45, '31-45 years old',
                                    if_else(46 <= as.numeric(age) & as.numeric(age) <= 64, '46-64 years old',
                                            if_else(65<= as.numeric(age), '65+ years old', 'less than 1 year old'))))))
                                          
  
rm(raw_data)
         





         