#install.packages("tidyverse")
#install.packages("stringr")
#install.packages("corrr")
#install.packages("ggcorrplot")
#install.packages("gridExtra")
#install.packages("vcd")
#install.packages("MASS")

library(tidyverse)
library(stringr)
library(corrr)
library(ggcorrplot)
library(gridExtra)
library(vcd)
library(MASS)
library(vcd)

blue <- "#1E90FF"
red <- "#CC0000"

#Make sure you have data_train from the "main" file.

data_train <- read.csv('trainingdata.csv', header = TRUE, na.strings = c('NAN','NA'))
attach(data_train)
difference <- data.frame( data_train$max_price-data_train$min_price )
names(difference) <- "differences"
data_train <- cbind(data_train,difference)

##Lets start with some basic plots.
#Frequency plots

ggplot.bar <- function(DT, variable, xlab){
  ggplot(data = DT, aes(as.factor(variable))) + theme_bw() + 
    geom_bar(aes(y = (..count..)/sum(..count..) ), col = blue, fill = blue, alpha = 0.75,) +
    labs(y= "Abs frequency", x = xlab) +
    ggtitle(paste(xlab,"frequency plot"))
}
ggplot.hist <- function(DT, variable, xlab){
  ggplot(data = DT, aes(variable)) + theme_bw() + 
    geom_histogram(aes(y = (..count..)/sum(..count..) ), col = blue, fill = blue, alpha = 0.75, bins = 20) +
    labs(y= "Abs frequency", x = xlab) +
    ggtitle(paste(xlab,"frequency plot"))
}


ggplot.bar(data_train, data_train$brand, "brand")
ggplot.bar(data_train, data_train$screen_size,"screen_size")
ggplot.bar(data_train, data_train$pixels_x,"pixels_x")
ggplot.bar(data_train, data_train$pixels_y, "pixels_y")
ggplot.bar(data_train, data_train$screen_surface, "screen_surface")
ggplot.bar(data_train, data_train$touchscreen, "touchscreen")
ggplot.bar(data_train, data_train$cpu, "cpu")
ggplot.bar(data_train, data_train$cpu_GHZ, "cpu_GHZ")
ggplot.bar(data_train, data_train$cpu_core, "cpu_core")
ggplot.bar(data_train, data_train$threading, "threading")
ggplot.hist(data_train, data_train$cpu_benchmark, "cpu_benchmark")
ggplot.bar(data_train, data_train$discrete_gpu, "discrete_gpu")
ggplot.bar(data_train, data_train$gpu, "gpu")
ggplot.hist(data_train, data_train$gpu_benchmark, "gpu_benchmark")
ggplot.bar(data_train, data_train$os, "os")
ggplot.bar(data_train, data_train$os_details, "os_details")
ggplot.bar(data_train, data_train$ram, "ram")
ggplot.bar(data_train, data_train$ssd, "ssd")
ggplot.bar(data_train, data_train$storage, "storage")
ggplot.hist(data_train, data_train$weight, "weight")
ggplot.bar(data_train, data_train$cpu_brand, "cpu_brand")
ggplot.bar(data_train, data_train$cpu_type_name, "cpu_type_name")
ggplot.bar(data_train, data_train$gpu_brand, "gpu_brand")
ggplot.bar(data_train, data_train$gpu_type, "gpu_type")
ggplot.bar(data_train, data_train$os_details_2, "os_details_2")
ggplot.bar(data_train, data_train$cpu_details_2, "cpu_details_2")
ggplot.bar(data_train, data_train$pixel, "pixel")
ggplot.bar(data_train, data_train$detachable_keyboard, "detachable_keyboard")

#cpu_core frequency plot manueel om x-as in logische volgorde te hebben
herwerktecpucore <- data.frame(cores = c("Unknown","2","4","6","8"), number = c(5/357,158/357,139/357,54/357,1/357))
summary(herwerktecpucore)
ggplot(data = herwerktecpucore, aes(x = cores, y = number)) + theme_bw() + 
  geom_col(col = blue, fill = blue, alpha = 0.75,) +
  labs(y= "Abs frequency", x = "number of cores") +
  ggtitle("cpu_core frequency plot")


ggplot.point2 <- function(DT, variable, xlab){
  ggplot(data_train, aes(variable, min_price)) +
    geom_point(col=blue) + labs(x=xlab) + 
    theme_bw()
}

ggplot.point(data_train, data_train$brand, "brand")
ggplot.point(data_train, data_train$screen_size, "screen_size")
ggplot.point(data_train, data_train$pixels_x, "pixels_x")
ggplot.point(data_train, data_train$pixels_y, "pixels_y")
ggplot.point(data_train, data_train$screen_surface, "screen_surface")
ggplot.point(data_train, data_train$touchscreen, "touchscreen")
ggplot.point(data_train, data_train$cpu, "cpu")
ggplot.point(data_train, data_train$discrete_gpu, "discrete_gpu")
ggplot.point(data_train, data_train$gpu, "gpu")
ggplot.point(data_train, data_train$os, "os")
ggplot.point(data_train, data_train$os_details, "os_details")
ggplot.point(data_train, data_train$ram, "ram")
ggplot.point(data_train, data_train$ssd, "ssd")
ggplot.point(data_train, data_train$storage, "storage")
ggplot.point(data_train, data_train$weight, "weight")
ggplot.point(data_train, data_train$cpu_brand, "cpu_brand")
ggplot.point(data_train, data_train$cpu_type_name, "cpu_type_name")
ggplot.point(data_train, data_train$gpu_brand, "gpu_brand")
ggplot.point(data_train, data_train$gpu_type, "gpu_type")
ggplot.point(data_train, data_train$os_details_2, "os_details_2")
ggplot.point(data_train, data_train$cpu_details_2, "cpu_details_2")
ggplot.point(data_train, data_train$pixel, "pixel")


#
mean(gpu_benchmark, na.rm = TRUE)
median(gpu_benchmark, na.rm = TRUE)
gpu_benchmark0 = data_train[which(data_train$discrete_gpu=="0"),]
gpu_benchmark1 = data_train[which(data_train$discrete_gpu=="1"),]
mean(gpu_benchmark0$gpu_benchmark, na.rm = TRUE)
median(gpu_benchmark0$gpu_benchmark, na.rm = TRUE)
mean(gpu_benchmark1$gpu_benchmark, na.rm = TRUE)
median(gpu_benchmark1$gpu_benchmark, na.rm = TRUE)

##################################################################
#Correlaties en rest met volledige trainingset
data_trainfull <- read.csv('datafile2.csv', header = TRUE, na.strings = c('NAN','NA'))

#correlatie
cor(data_trainfull$pixels_x, data_trainfull$pixels_y)
cor(data_trainfull$ssd, data_trainfull$storage)
cor(pixels_x, screen_size)
cor(touchscreen, detachable_keyboard, use = "complete.obs")
cor(ram, discrete_gpu)
cor(ram, touchscreen)
cor(discrete_gpu, gpu_benchmark)
cor(discrete_gpu, cpu_benchmark)
cor(gpu_benchmark, cpu_benchmark)
cor(cpu_GHZ, cpu_benchmark)
cor(threading, cpu_benchmark)
cor(threading, cpu_GHZ)

#corr screen surface en touchscreen
assocstats(cbind(data_train$cpu_core, data_train$cpu_type_name))
assocstats(cbind(data_train$screen_surface, data_train$touchscreen))
assocstats(cbind(data_trainfull$os, data_trainfull$os_details)[c(-311,-396),])
assocstats(cbind(data_train$cpu_core, data_train$threading))
assocstats(cbind(data_train$cpu_brand, data_train$cpu_type_name))

ggplot(data_train, aes(x = cpu_GHZ, y = cpu_core)) + theme_bw() +
         geom_jitter()

###############################################################################################################
#Price difference zoeken

ggplot(data = difference) +
  geom_histogram(aes(x = difference$data_train$differences), binwidth = 50) + theme_bw()


ggplot(data = data_train) + theme_bw() + 
  geom_point(aes(x = factor(threading), y = data_train$differences) , col=blue)+
  labs(x="threading", y="price difference")

ggplot.point2 <- function(DT, variable, xlab){
  ggplot(data_train, aes(variable, data_train$differences)) +
    geom_point(col=blue) + labs(x=xlab) + 
    theme_bw()
}

ggplot.point2(data_train, data_train$brand, "brand")
ggplot.point2(data_train, data_train$screen_size, "screen_size")
ggplot.point2(data_train, data_train$pixels_x, "pixels_x")
ggplot.point2(data_train, data_train$pixels_y, "pixels_y")
ggplot.point2(data_train, data_train$screen_surface, "screen_surface")
ggplot.point2(data_train, data_train$touchscreen, "touchscreen")
ggplot.point2(data_train, data_train$cpu, "cpu")
ggplot.point2(data_train, data_train$cpu_GHZ, "cpu_GHZ")
ggplot.point2(data_train, data_train$cpu_core, "cpu_core")
ggplot.point2(data_train, data_train$threading, "threading")
ggplot.point2(data_train, data_train$cpu_benchmark, "cpu_benchmark")
ggplot.point2(data_train, data_train$cpu_type_name, "cpu_type")
ggplot.point2(data_train, data_train$discrete_gpu, "discrete_gpu")
ggplot.point2(data_train, data_train$gpu, "gpu")
ggplot.point2(data_train, data_train$gpu_benchmark, "gpu_benchmark")
ggplot.point2(data_train, data_train$os, "os")
ggplot.point2(data_train, data_train$os_details, "os_details")
ggplot.point2(data_train, data_train$ram, "ram")
ggplot.point2(data_train, data_train$ssd, "ssd")
ggplot.point2(data_train, data_train$storage, "storage")
ggplot.point2(data_train, data_train$weight, "weight")
ggplot.point2(data_train, data_train$cpu_brand, "cpu_brand")
ggplot.point2(data_train, data_train$cpu_type_name, "cpu_type_name")
ggplot.point2(data_train, data_train$gpu_brand, "gpu_brand")
ggplot.point2(data_train, data_train$gpu_type, "gpu_type")
ggplot.point2(data_train, data_train$os_details_2, "os_details_2")
ggplot.point2(data_train, data_train$cpu_details_2, "cpu_details_2")
ggplot.point2(data_train, data_train$pixel, "pixel")
ggplot.point2(data_train, data_train$detachable_keyboard, "detachable keyboard")

#########################################################################################################
#Scatterplot
testresults <- read.csv('testingdata_results.csv', header = TRUE, na.strings = c('NAN','NA'))

#min_price
ggplot(testresults, aes(x = act_min_price, y = pred_min_price, color = brand)) +
  geom_point() + theme_bw() +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  ggtitle("Actual vs Predicted Minimum Price")
#Python: sns.relplot(x='pred_min_price',y='act_min_price',hue='brand',data=df)

#max_price
ggplot(testresults, aes(x = act_max_price, y = pred_max_price, color = brand)) +
  geom_point() + theme_bw() +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  ggtitle("Actual vs Predicted Maximum Price")
#Python: sns.relplot(x='pred_max_price',y='act_max_price',hue='brand',data=df)

#Mean Summed Absolute Error
ggplot(testresults, aes(x = act_max_price, y = (abs(pred_max_price-act_max_price) + abs(pred_min_price-act_min_price))/2, color = brand)) +
  geom_point() + theme_bw() +
  geom_abline(intercept = 310, slope = 0, linetype = 2) +
  labs(title = "MSAE of every instance", x = "actual maximum price", y = "MSAE")

##########################################################################################################
#Why lenovo and asus
Originaltrainset <- read.csv('datafile2.csv', header = TRUE, na.strings = c('NAN','NA'))
lenovo <- Originaltrainset[which(Originaltrainset$brand == "LENOVO"),]
ggplot(lenovo, aes(x = max_price, y = pc_name, color = max_price)) + theme_bw() +
  geom_point()

asus <- Originaltrainset[which(Originaltrainset$brand == "ASUS"),]
ggplot(asus, aes(x = max_price, y = pc_name, color = max_price)) + theme_bw() +
  geom_point()

##################################################################################################################
# Hidden leaderbord results

privatelbresults <- read.csv('Private_LB_Results.csv', header = TRUE, na.strings = c('NAN','NA'))

#min_price
ggplot(privatelbresults, aes(x = act_min_price, y = pred_min_price, color = brand)) +
  geom_point() + theme_bw() +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  ggtitle("Actual vs Predicted Minimum Price LB")
#Python: sns.relplot(x='pred_min_price',y='act_min_price',hue='brand',data=df)

#max_price
ggplot(privatelbresults, aes(x = act_max_price, y = pred_max_price, color = brand)) +
  geom_point() + theme_bw() +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  ggtitle("Actual vs Predicted Maximum Price LB")
#Python: sns.relplot(x='pred_max_price',y='act_max_price',hue='brand',data=df)

#Mean Summed Absolute Error
ggplot(privatelbresults, aes(x = act_max_price, y = (abs(pred_max_price-act_max_price) + abs(pred_min_price-act_min_price))/2, color = brand)) +
  geom_point() + theme_bw() +
  geom_abline(intercept = 310, slope = 0, linetype = 2) +
  labs(title = "MSAE of every instance LB", x = "actual maximum price", y = "MSAE")

View()