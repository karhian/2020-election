#### Preamble ####
# Purpose: Create Model from stratified data
# Author: Fadlan Arif
# Date: 31 October 2020
# Contact: fadlan.fakhrunniam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the survey data and save the folder that you're 
# interested in to "data" folder or change line 18 if saved in different location
# - Create a folder called "cleaned data" in outputs folder
# - Don't forget to gitignore it!

#creating seperate tables for each age group
age1 <- reduced_data2 %>% filter(age_groups == '18-30 years old')
age2 <- reduced_data2 %>% filter(age_groups == '31-45 years old')
age3 <- reduced_data2 %>% filter(age_groups == '46-65 years old')
age4 <- reduced_data2 %>% filter(age_groups == 'Above 65 years old')

#selecting from each age group's table proportionate to population
set.seed(1)
stratified_age1 <- 
  sample_n(age1, 392, replace = FALSE)

stratified_age2 <- 
  sample_n(age2, 438, replace = FALSE)

stratified_age3 <- 
  sample_n(age3, 680, replace = FALSE)

stratified_age4 <- 
  sample_n(age4, 490, replace = FALSE)

full_stratified_table <- rbind(stratified_age1, stratified_age2, stratified_age3, stratified_age4)

full_stratified_table <- full_stratified_table %>%
  mutate(vote2020_bin = case_when(vote_2020 == "Joe Biden" ~ 1,
                                  vote_2020 == "Donald Trump" ~ 0)) 


first_logit <- glm(vote2020_bin ~ age + educ_level, data = full_stratified_table,
                   na.action="na.exclude", family = "binomial")

summary(first_logit)
b0 <- first_logit$coef[1] #intercept
age  <- first_logit$coef[2]
doctorate <- first_logit$coef[3]
gradeschool <- first_logit$coef[4]
masters <- first_logit$coef[5]

age_range <- seq(from=min(full_stratified_table$age), to=max(full_stratified_table$age), by=0.1)

#college
a_logits <- b0 + age*age_range + doctorate*0 + gradeschool*0 + masters*0

#Doctorate
b_logits <- b0 + age*age_range + doctorate*1 + gradeschool*0 + masters*0

#Grade School
c_logits <- b0 + age*age_range + doctorate*0 + gradeschool*1 + masters*0

#Masters
d_logits <- b0 + age*age_range + doctorate*0 + gradeschool*0 + masters*1

a_probs <- exp(a_logits)/(1 + exp(a_logits))
b_probs <- exp(b_logits)/(1 + exp(b_logits))
c_probs <- exp(c_logits)/(1 + exp(c_logits))
d_probs <- exp(d_logits)/(1 + exp(d_logits))


plot.data <- data.frame(A=a_probs, B= b_probs, C=c_probs, D=d_probs, Age=age_range)
plot.data <- gather(plot.data, key=group, value=prob, A:D)
graph1 <- ggplot(plot.data, aes(x=Age, y= prob, color= group)) + 
  geom_line(lwd=1, lty=1) +
  labs(x="Age", y="Probability", title="Figure 1: Probability of Voting For Biden", color = 'Level of Education')
graph1
