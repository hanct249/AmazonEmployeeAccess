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
ggplot(data=trainData, aes(x=ACTION,y=RESOURCE)) +
         geom_boxplot()
ggplot(data=trainData, aes(x=ACTION, y=MGR_ID)) +
  geom_boxplot()

amazonRecipe <- recipe(ACTION~., data=trainData) %>%
  step_mutate_at(all_predictors(), fn= factor) %>%
  step_other(all_predictors(), threshold = .001)
  step_dummy(all_predictors())