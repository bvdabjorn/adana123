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

blue <- "#1E90FF"
red <- "#CC0000"

#Make sure you have data_train from the "main" file.

data_train <- read.csv('trainingdata.csv', header = TRUE, na.strings = c('NAN','NA'))
attach(data_train)

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
ggplot(data = data_train, aes(as.factor(data_train$cpu_core))) + theme_bw() + 
  geom_bar(aes(y = (..count..)/sum(..count..), x = c("","DUAL-CORE","QUAD-CORE","HEXA-CORE","OCTA-CORE")  ), col = blue, fill = blue, alpha = 0.75,) +
  labs(y= "Abs frequency", x = xlab) +
  ggtitle("cpu_core frequency plot")


ggplot.point <- function(DT, variable, xlab){
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


###############################################################################################################

#Linear model maken
#Min_price

data_no_missing = data_train[-(missing_data_train$X-1),]

leegmodel <- lm(min_price ~ 1, data=data_no_missing)
leegmodel
BIC(leegmodel)
ssdmodel <- lm(min_price ~ ssd, data = data_no_missing)
summary(ssdmodel)
screensurfacemodel <- lm(min_price ~ screen_surface, data = data_no_missing)
summary(screensurfacemodel)
BIC(ssdmodel)
volmodel <- lm(min_price ~ ., data=data_no_missing)
volmodel
BIC(volmodel)
summary(volmodel)
#BrandRazor, cpuIntelcoreI9,cpuIntelXeon, ssd Zijn significant, zelfs in het overvolle model!



stepAIC(volmodel, k=log(nrow(data_no_missing)), direction = "both", scope=list(upper=~. , data=data_no_missing, lower=~1 ))





Basiscomponentenmodel <- lm(min_price ~ pixels_x + factor(discrete_gpu) + os + ram + ssd + storage  , data=data_train)

BIC(Basiscomponentenmodel)

summary(Basiscomponentenmodel)
