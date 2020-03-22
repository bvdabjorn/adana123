install.packages("tidyverse")
install.packages("stringr")
install.packages("corrr")
install.packages("ggcorrplot")
install.packages("gridExtra")
install.packages("vcd")
install.packages("MASS")

library(tidyverse)
library(stringr)
library(corrr)
library(ggcorrplot)
library(gridExtra)
library(vcd)
library(MASS)

blue <- "#1E90FF"

#Make sure you have data_train from the "main" file.

attach(data_train)

##Lets start with some basic plots.
#Frequency plots

ggplot.bar <- function(DT, variable, xlab){
  ggplot(data = DT, aes(as.factor(variable))) + theme_bw() + 
    geom_bar(aes(y = (..count..)/sum(..count..)), col = blue, fill = blue, alpha = 0.5) +
    labs(y= "Abs frequency", x = xlab)
}

ggplot.bar(data_train, data_train$brand, "brand")
ggplot.bar(data_train, data_train$screen_size,"screen_size")
ggplot.bar(data_train, data_train$pixels_x,"pixels_x")
ggplot.bar(data_train, data_train$pixels_y, "pixels_y")
ggplot.bar(data_train, data_train$screen_surface, "screen_surface")
ggplot.bar(data_train, data_train$touchscreen, "touchscreen")
ggplot.bar(data_train, data_train$cpu, "cpu")
ggplot.bar(data_train, data_train$discrete_gpu, "discrete_gpu")
ggplot.bar(data_train, data_train$gpu, "gpu")
ggplot.bar(data_train, data_train$os, "os")
ggplot.bar(data_train, data_train$os_details, "os_details")
ggplot.bar(data_train, data_train$ram, "ram")
ggplot.bar(data_train, data_train$ssd, "ssd")
ggplot.bar(data_train, data_train$storage, "storage")
ggplot.bar(data_train, data_train$weight, "weight")
ggplot.bar(data_train, data_train$cpu_brand, "cpu_brand")
ggplot.bar(data_train, data_train$cpu_type_name, "cpu_type_name")
ggplot.bar(data_train, data_train$gpu_brand, "pu_brand")
ggplot.bar(data_train, data_train$gpu_type, "gpu_type")
ggplot.bar(data_train, data_train$os_details_2, "os_details_2")
ggplot.bar(data_train, data_train$cpu_details_2, "cpu_details_2")
ggplot.bar(data_train, data_train$pixel, "pixel")



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

#Linear model maken
#Min_price

data_no_missing = data_train[-(missing_data_train$X-1),]

leegmodel <- lm(min_price ~ 1, data=data_no_missing)
leegmodel
BIC(leegmodel)
ssdmodel <- lm(min_price ~ ssd, data = data_no_missing)
ssdmodel
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