install.packages("plyr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("tidyr")
install.packages("tidyverse")
install.packages("randomForest")

library(plyr)
library(ggplot2)
library(tidyr)
library(dplyr)
library(tidyverse)
library(randomForest)

deploy <- read.csv("deploy.csv")
training <- read.csv("training.csv")

rf_model <- randomForest(InPlay ~ ., data = training, ntree = 1000)


