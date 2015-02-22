## Set working directory and load packages
##setwd("./Desktop/Coursera")
library(plyr)
library(reshape2)
## Load data into R
## Training data
initial <- read.table("./UCI HAR Dataset/train/X_train.txt", nrows = 100)
classes <- sapply(initial, class)
trainingSet <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                          colClasses = classes)
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
subTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
## Test data
initial <- read.table("./UCI HAR Dataset/test/X_test.txt", nrows = 100)
classes <- sapply(initial, class)
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                          colClasses = classes)
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
subTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
## Common data
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("activity", "activityname")
## Merge data
dataTrain <- cbind(subTrain, trainLabels, trainingSet)
dataTest <- cbind(subTest, testLabels, testSet)
dataAll <- rbind(dataTrain, dataTest)
names(dataAll) <- c("subject", "activity", as.character(features[,2]))
## Subsetting
nameIndex <- grep("mean|std", names(dataAll))
dataSub <- dataAll[, c("subject", "activity", names(dataAll)[nameIndex])]
dataSubNew <- join(dataSub, activities)
## Get the average of each variable for each activity and each subject
dataMelt <- melt(dataSubNew, id = c("activity", "activityname", "subject"), 
                 measure.vars = names(dataAll)[nameIndex])
aveData <- dcast(dataMelt, activityname + subject ~ variable, mean)
write.table(aveData, file = "aveData.txt", row.names = FALSE)