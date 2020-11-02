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
raw_data1 <- read_dta("data/usa_00001.dta.gz")
# Add the labels
raw_data1 <- labelled::to_factor(raw_data1)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
names(raw_data1)

#selecting variables of interest
reduced_data1 <- 
  raw_data1 %>% 
  select(age,
         race,
         hcovany,
         educ,
         educd,
         schltype,
         vetstat) %>%
  filter(!is.na(educd))


#### What's next? ####
#grouping the ages
reduced_data1 <- reduced_data1 %>% 
  mutate(age_groups = if_else(as.numeric(age) <= 17,'Below 18', 
                    if_else(18 <= as.numeric(age) & as.numeric(age) <= 30, '18-30 years old', 
                            if_else(31 <= as.numeric(age) & as.numeric(age) <= 45, '31-45 years old',
                                    if_else(46 <= as.numeric(age) & as.numeric(age) <= 65, '46-65 years old',
                                            if_else(65< as.numeric(age), 'Above 65 years old', 'NA'))))))
                                          
reduced_data1 <- reduced_data1 %>%
  mutate(educ_level = case_when(educd == 'no schooling completed'  ~ "Grade School", #for the purpose of election prediction, we categorize no schooling completed under grade school    
                                educd == 'nursery school to grade 4'| educd == 'nursery school, preschool' ~ 'Grade School',
                                educd == 'kindergarten' | educd == 'grade 1, 2, 3, or 4' ~ 'Grade School',
                                educd == 'grade 1' | educd == 'grade 2' ~ 'Grade School',
                                educd == 'grade 3' | educd == 'grade 4' ~ 'Grade School',
                                educd == 'grade 5' | educd == 'grade 5, 6, 7, or 8' ~ 'Grade School',
                                educd == 'grade 5 or 6' | educd == 'grade 5' ~ 'Grade School',
                                educd == 'grade 6' | educd == 'grade 7 or 8' ~ 'Grade School',
                                educd == 'grade 7' | educd == 'grade 8' ~ 'Grade School',
                                educd == 'grade 9' | educd == 'grade 10' ~ 'Grade School',
                                educd == 'grade 11' | educd == 'grade 12' ~ 'Grade School',
                                educd == '12th grade, no diploma' | educd == 'high school graduate or ged' ~ 'Grade School',
                                educd == 'regular high school diploma' | educd == 'ged or alternative credential' ~ 'Grade School',
                                educd == '1 year of college' | educd == 'some college, but less than 1 year' ~ 'College',
                                educd == '1 or more years of college credit, no degree' | educd == '2 years of college' ~ 'College',
                                educd == "associate's degree, type not specified" | educd == "associate's degree, occupational program" ~ 'College',
                                educd == "associate's degree, academic program" | educd == '3 years of college' ~ 'College',
                                educd == '4 years of college' | educd == "bachelor's degree" ~ 'College',
                                educd == '5+ years of college' | educd == '6 years of college (6+ in 1960-1970)' ~ 'College',
                                educd == '7 years of college' | educd == '8+ years of college' ~ 'College',
                                educd == "master's degree" | educd == "professional degree beyond a bachelor's degree" ~ "Master's or above bachelor's degree",
                                educd == "doctoral degree" ~ 'Doctorate Degree'
                                
  ))

reduced_data1 <- reduced_data1 %>% filter(age_groups != 'Below 18')
         
#write the reduced data into a csv file
write.csv(reduced_data1,"outputs/cleaned data/poststratification_cleaned.csv")

reduced_data1 %>% 
  ggplot()+ geom_bar(aes(x=age_groups, fill = age_groups)) + labs(title = "Figure 1 Population of Age Groups", 
                                                               x = "Age Groups", 
                                                               y = "Number of People") 


#```{r bills, fig.cap="Bills of penguins", echo = FALSE}
#ggplot(penguins, aes(x = island, fill = species)) +
# geom_bar(alpha = 0.8) +
#  scale_fill_manual(values = c("darkorange","purple","cyan4"),
#                    guide = FALSE) +
#  theme_minimal() +
#  facet_wrap(~species, ncol = 1) +
#  coord_flip()
#```
         