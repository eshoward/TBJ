install.packages("plyr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("tidyverse")
install.packages("randomForest")
install.packages("reshape2")
install.packages("ggpubr")

library(plyr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(tidyverse)
library(randomForest)
library(reshape2)

deploy <- read.csv("deploy.csv")
training <- read.csv("training.csv")

training$SpinRate <- as.numeric(training$SpinRate)
deploy$SpinRate <- as.numeric(deploy$SpinRate)

training <- na.omit(training)
deploy <- na.omit(deploy)

rows_to_remove <- 7
random_indices <- sample(nrow(training), rows_to_remove)
training <- training[-random_indices, ]

rf_model <- randomForest(InPlay ~ ., data = training, ntree = 100)

predictions <- predict(rf_model, newdata = deploy)

thresold <- 0.34
predicted_hits <- ifelse(predictions > thresold, 1, 0)

confusion_matrix <- table(predicted_hits, training$InPlay)
accuracy <- round((sum(diag(confusion_matrix)) / sum(confusion_matrix)) *100, 2)

deploy$Predicted_Hits <- predicted_hits
sum(deploy$Predicted_Hits)

write.csv(deploy, "EvanHoward_PredictedHits.csv")

ggplot(deploy, aes(x = HorzBreak, y = InducedVertBreak, color = Predicted_Hits))+
  geom_point(size = 2)

ggplot(deploy, aes(factor(Predicted_Hits), InducedVertBreak))+
  geom_boxplot()

counts <- table(deploy$Predicted_Hits)
counts

inducedDF <- deploy

breaks <- seq(0, max(inducedDF$InducedVertBreak) + 5, by = 5)
inducedDF$Interval <- cut(inducedDF$InducedVertBreak, breaks, right = FALSE)
induced_result <- table(inducedDF$Interval, inducedDF$Predicted_Hits)
colnames(induced_result) <- c("0", "1")
print(induced_result)














