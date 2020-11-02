#### Preamble ####
# Purpose: Create Model from survey data and postratify the model
# Author: Kar Hian Ong
# Date: 31 October 2020
# Contact: kar.ong@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have ran 01-data_cleaning-post-strat.r and 01-data_cleaning-survey.R
# - Don't forget to gitignore it!

library(tidyverse)
library()
survey_data <- read.csv("outputs/cleaned data/survey_cleaned.csv")
survey_data <-  survey_data %>% mutate(vote2020_bin = case_when(vote_2020 == "Joe Biden" ~ 1,
                                                                vote_2020 == "Donald Trump" ~ 0))
# select variable of interest 
modeling_interest<-survey_data %>% select(vote_2020,vote2020_bin,age_groups,educ_level)

# partition the data to 80% training and 20% testing
training_size <- round(0.8*dim(modeling_interest)[1])
training_data <- modeling_interest[1:training_size,] 

testing_data <- modeling_interest[(training_size+1):dim(modeling_interest)[1],]

model <- glm(vote2020_bin ~ age_groups + educ_level ,na.action="na.exclude" ,data=modeling_interest,family="binomial")

coef_labels <- c("Intercept","age_groups31-45 years old","age_groups46-65 years old","age_groupsAbove 65 years old","educ_levelDoctorate Degree","educ_levelGrade School","educ_levelMaster's or above bachelor's degree")
coef_model <- coef(model)
coeficients_table <- rbind(coef_labels,coef_model)
write(coeficients_table,"outputs/Statistics/modelcoef.csv")


training_data <- training_data %>% mutate(Probability=predict(model,training_data,type="response"))
# Classification based on probability. Those with propability greater then 0.5 will classify as voting for Joe biden 
# while those less than or equals to 0.5 will classify as voting for trump
training_data <- training_data %>% mutate(Predicted_vote_2020 = ifelse(Probability > 0.5, "Joe Biden", "Donald Trump"))
# 1 for correctly predicting 0 for wrongly predicted
training_data <- training_data %>% mutate(Correct_prediction = ifelse(vote_2020==Predicted_vote_2020, 1, 0))

Training_accuracy <- mean(training_data$Correct_prediction)*100

testing_data <- testing_data %>% mutate(Probability=predict(model,testing_data,type="response"))
testing_data <- testing_data %>% mutate(Predicted_vote_2020 = ifelse(Probability > 0.5, "Joe Biden", "Donald Trump"))
testing_data <- testing_data %>% mutate(Correct_prediction = ifelse(vote_2020==Predicted_vote_2020, 1, 0))

Testing_accuracy <- mean(testing_data$Correct_prediction)*100


accuracy <- rbind(c("Training Accuracy (%)","Testing Accuracy (%)"),c(round(Training_accuracy,digits=2),round(Testing_accuracy,digits = 2)))
write.csv(accuracy,"outputs/Statistics/model_accuracy.csv")


#make predicton using postratification data
postratification_data <- read.csv("outputs/cleaned data/poststratification_cleaned.csv")

postratification_interest <- postratification_data %>% select(age_groups,educ_level)
postratification_interest$prediction_probability <-
  model %>%
  predict(newdata = postratification_interest, type="response")

# Classification based on probability. Those with propability greater then 0.5 will classify as voting for Joe biden 
# while those less than or equals to 0.5 will classify as voting for trump
postratification_interest <- postratification_interest %>% mutate(Predicted_vote = ifelse(prediction_probability > 0.5, "Joe Biden", "Donald Trump"))

results<-round(prop.table(table(postratification_interest$Predicted_vote)),digit=2)

# Write the percentage vote into "output/statistics" 
write.csv(results,"outputs/statistics/percentage_vote.csv")
# Writing the prediction into "outputs/cleaned data" 
write.csv(postratification_interest,"outputs/cleaned data/prediction.csv")





postratification_interest %>% 
ggplot()+ geom_bar(aes(x=Predicted_vote,fill=educ_level))

postratification_interest %>% 
  ggplot()+ geom_bar(aes(x=Predicted_vote,fill=age_groups))

