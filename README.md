# Overview

This repo contains code and data for forecasting the US 2020 presidential election. It was created by Kar Hian Ong and Fadlan Arif. The purpose is to create a report that summarises the results of a statistical model that we built. Some data is unable to be shared publicly. We detail how to get that below. The sections of this repo are: data, outputs, scripts. Data folder will not be seen in this repository because git only track files. 

Data contain data that are unchanged from their original. We use two datasets: 

- [Survey data  - Steps to obtain Survey data

                 1. Fill in the form in https://www.voterstudygroup.org/publication/nationscape-data-set to obtain full data.

                 2. The full link to the full data will be sent via email provided
                 
                 3. For the purpose of this report we use ns20200625 in phase_2_v20200814 from the downloaded full data]

- [ACS data  - Steps to obtain ACS data 

              1. Skip to step 4 if already registered for an account

              2. Click register in https://usa.ipums.org/usa/index.shtml
              
              3. Click apply for access
              
              4. Login to your account
              
              5. Click on get data
              
              6. Select sample and variables of interest
              
                  - for the purpose of this report, we selected the 2018 sample 
                  
              7. Go to data cart
              
              8. Click on create data extract
              
              9. Change the data format to Stata and click submit
              
              10. Click submit extract
              
              11. You will recieved an email when the data is ready for download]

Outputs contain data that are modified from the input data, the report and supporting material. The section are: 

- cleaned data

  - running script 01-data_cleaning-post-strat.R and 01-data_cleaning-survey.R will write to this folder 
  
- paper
- statistics
  
  -this is where the statistics from the model will be located

Scripts contain R scripts that take inputs and outputs and produce outputs. These are:

- 01-data_cleaning-post-strat.R
- 01-data_cleaning-survey.R
- post-stratified model.R




