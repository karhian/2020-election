#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://usa.ipums.org/usa/index.shtml
# Author: Fadlan Arif
# Date: 28 October 2020
# Contact: fadlan.fakhrunniam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to "data" folder
# or change line 18 if saved in different location
# - Create a folder called "cleaned data" in outputs folder
# - Don't forget to gitignore it!


#### Workspace setup ####
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
  mutate(age_range = if_else(as.numeric(age) <= 17,'Below 18', 
                    if_else(18 <= as.numeric(age) & as.numeric(age) <= 30, '18-30 years old', 
                            if_else(31 <= as.numeric(age) & as.numeric(age) <= 45, '31-45 years old',
                                    if_else(46 <= as.numeric(age) & as.numeric(age) <= 64, '46-64 years old',
                                            if_else(65<= as.numeric(age), '65+ years old', 'NA'))))))
                                          
  
rm(raw_data)
         
#write the reduced data into a csv file
write.csv(reduced_data,"outputs/cleaned data/poststratification_cleaned.csv")



         