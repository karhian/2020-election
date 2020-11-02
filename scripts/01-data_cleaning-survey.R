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
raw_data2 <- read_dta("data/ns20200625/ns20200625.dta")
# Add the labels
raw_data2 <- labelled::to_factor(raw_data2)
# Just keep some variables
reduced_data2 <- 
  raw_data2 %>% 
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
         age) %>%
  filter(!is.na(education))


#### What else???? ####
# Maybe make some age-groups?
reduced_data2 <- reduced_data2 %>%
mutate(age_groups = case_when(age > 65 ~ "Above 65 years old",
                             age >= 46  & age <= 65 ~ "46-65 years old",
                             age >= 31  & age <= 45 ~ "31-45 years old",
                             age >= 18  & age <= 30  ~ "18-30 years old",
                             age < 18 ~ "Below 18" 
))

reduced_data2 <- reduced_data2 %>%
  mutate(educ_level = case_when(education == '3rd Grade or less' | education == 'Middle School - Grades 4 - 8' ~ 'Grade School',
                                education == 'Completed some high school' | education == 'High school graduate' ~ 'Grade School',
                                education == 'Other post high school vocational training' ~ 'Grade School',
                                education == 'Completed some college, but no degree' | education == "Completed some college, but no degree" ~ 'College',
                                education == 'College Degree (such as B.A., B.S.)' | education == "Completed some graduate, but no degree" ~ 'College',
                                education == 'Associate Degree' ~ 'College', 
                                education == 'Masters degree' ~ "Master's or above bachelor's degree",
                                education == 'Doctorate degree' ~ 'Doctorate Degree'
    
  ))


# Since we want to predict who wins the election, we remove those who are not eligible to vote
reduced_data2 <- reduced_data2 %>%
  filter(vote_intention!="No, I am not eligible to vote") %>%
  filter(vote_2020 == "Joe Biden"| vote_2020 == "Donald Trump")
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?
#Vote is not binary but we can use probability on who they might vote for based on several predictor variables

reduced_data2 %>% group_by(age_groups) %>% count()


write.csv(reduced_data2,"outputs/cleaned data/survey_cleaned.csv")

reduced_data2 %>% 
  ggplot()+ geom_bar(aes(x=age_groups, fill = age_groups)) + labs(title = "Figure 1 Population of Age Groups", 
                                                                  x = "Age Groups", 
                                                                  y = "Number of People") 
