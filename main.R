install.packages("tidyverse")
install.packages("dplyr")
install.packages("stringr")
install.packages("fastDummies")

library(tidyverse)
library(dplyr)
library(stringr)
library(fastDummies)

data_train <- read.csv('datafile2.csv', header = TRUE, na.strings = c('NAN','NA'))
data_test <- read.csv('test.csv', header = TRUE)

#Create dataframe with all entries that have missing values (26 missing data entries based on original dataset)
missing_data_train <- data_train[rowSums(is.na(data_train)) > 0,]

#Combine pixelinformation
data_train$pixel = data_train$pixels_x*data_train$pixels_y

#Dataframe for neural network (test approach)
#Check for discreet GPU variable !
net_data <- data_frame(as.numeric(data_train$brand), data_train$screen_size, as.numeric(data_train$screen_surface), data_train$pixel,
                       data_train$touchscreen, data_train$detachable_keyboard, as.numeric(data_train$os), as.numeric(data_train$os_details_2), 
                       data_train$ram, data_train$ssd, data_train$storage, data_train$weight, as.numeric(data_train$cpu_brand), as.numeric(data_train$cpu_type_name),
                       as.numeric(data_train$cpu_details_2), as.numeric(data_train$gpu_brand), as.numeric(data_train$gpu_type), data_train$min_price, data_train$max_price)
x <- c('brand', 'screen_size', 'screen_surface', 'pixels', 'touchscreen', 'detachable_keyboard', 'os', 'os_details', 'ram', 'ssd', 'storage', 'weight',
       'cpu_brand', 'cpu_type', 'cpu_details', 'gpu_brand', 'gpu_type', 'min_price', 'max_price')
names(net_data) <- x
