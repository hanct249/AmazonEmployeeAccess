library(tidyverse)
library(tidymodels)
library(ggmosaic)
library(vroom)
library(embed)
library(skimr)

#1050 columns

trainData <- vroom("train.csv")
testData <- vroom("test.csv")
skim(trainData)
ggplot(data=trainData +
         geom_box(aes=(x=ACTION, fill=)))
