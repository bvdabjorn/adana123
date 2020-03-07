library(tidyverse)
library(dplyr)
library(stringr)

data_train <- read.csv('train.csv', header = TRUE, na.strings = c('','NA'))
data_test <- read.csv('test.csv', header = TRUE)

#Create dataframe with all entries that have missing values (26 missing data entries based on original dataset)
missing_data_train <- data_train[rowSums(is.na(data_train)) > 0,]
