#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://www.voterstudygroup.org/publication/nationscape-data-set
# Author: Kar Hian Ong
# Date: 28 October 2020
# Contact: kar.ong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the survey data and save the folder that you're 
# interested in to "data" folder or change line 18 if saved in different location
# - Create a folder called "cleaned data" in outputs folder
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data (You might need to change this if you use a different dataset)
raw_data <- read_dta("data/ns20200625/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(interest,
         registration,
         vote_2016,
         vote_intention,
         vote_2020,
         ideo5,
         employment,
         foreign_born,
         gender,
         census_region,
         hispanic,
         race_ethnicity,
         household_income,
         education,
         state,
         congress_district,
         age)


#### What else???? ####
# Maybe make some age-groups?
reduced_data <- reduced_data %>%
mutate(age_groups = case_when(age > 65 ~ "Above 65",
                             age >= 46  & age <= 64 ~ "46-64",
                             age >= 31  & age <= 45 ~ "31-45",
                             age >= 18  & age <= 30  ~ "18-30",
                             age < 18 ~ "Below 18" 
))
# Since we want to predict who wins the election, we remove those who are not eligible to vote
reduced_data <- reduced_data %>%
  filter(vote_intention!="No, I am not eligible to vote")
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?
#Vote is not binary but we can use probability on who they might vote for based on several predictor variables

rm(raw_data)

write.csv(reduced_data,"outputs/cleaned data/survey_cleaned.csv")

