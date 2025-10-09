library(tidyverse)
library(tidymodels)
library(ggmosaic)
library(vroom)
library(embed)
library(skimr)

#1050 columns

trainData <- vroom("train.csv") %>%
  mutate(ACTION=factor(ACTION))
testData <- vroom("test.csv")
skim(trainData)
ggplot(data=trainData, aes(x=ACTION,y=RESOURCE)) +
         geom_boxplot()
ggplot(data=trainData, aes(x=ACTION, y=MGR_ID)) +
  geom_boxplot()

amazonRecipe <- recipe(ACTION~., data=trainData) %>%
  step_mutate_at(all_predictors(), fn= factor) %>%
  step_other(all_predictors(), threshold = .001) %>%
  step_dummy(all_predictors())

prepped <- prep(amazonRecipe)
baked <- bake(prepped, new_data=trainData)
  
logRegModel <- logistic_reg() %>%
  set_engine("glm")

logRegwf <- workflow() %>%
  add_recipe(amazonRecipe) %>%
  add_model(logRegModel) %>%
  fit(data=trainData)
  
amazon_predictions <- predict(logRegwf, new_data=testData, type="prob")

kaggle_submission <- amazon_predictions %>%
  select(.pred_1)

vroom_write(x=kaggle_submission, file="./logPreds.csv", delim=",")

  