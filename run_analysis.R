# Step 0. Download and unzip data
# Remove existing data an values in global environment.
rm(list=ls())

# load librariies
library(dplyr)

# Download data to data directory if not already downloaed
if(!file.exists("./data")){
  dir.create("./data")
  }
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# downloading data
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")

# unzip files containing data if not unzipped
if(!file.exists("./UCI HAR Dataset")) {
  unzip("finaldata.zip")
}

##############################################################################
# Part 1. 
##############################################################################

# Step . 
# Read data files in table format and create a data frame from it, with cases corresponding to lines and variables to fields in the file.

# Read testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Read trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read feature vector:
features <- read.table("./data/UCI HAR Dataset/features.txt", as.is = TRUE)

# Read activity labels:
activity_labels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Step 2. Merge the training and test sets to create one data set
trainData <- cbind(y_train, subject_train, x_train)
testData <- cbind(y_test, subject_test, x_test)
allData <- rbind(trainData, testData)

# Step 3. 
# Assign column names
colnames(allData) <- c("activityID", "subjectID", features[, 2])

# Step4.  Remove individual data tables to save memory
rm(x_test, y_test, subject_test, x_train, y_train, subject_train, trainData, testData)


##############################################################################
# Part 2. Extract only the measurements on the mean and standard deviation for each measurement
##############################################################################

# determine columns of data set to keep based on column name
cKeepers <- grepl("subject|activity|mean|std", colnames(allData))
allData <- allData[, cKeepers]


##############################################################################
# Part 3 - Use descriptive activity names to name the activities in the data set
##############################################################################

# replace activity values with named factor levels
allData$activityID <- factor(allData$activity, 
                                 levels = activity_labels[, 1], labels = activity_labels[, 2])


##############################################################################
# Step 4 - Appropriately label the data set with descriptive variable names
##############################################################################

# get column names
allDataCols <- colnames(allData)

# remove special characters
allDataCols <- gsub("[\\(\\)-]", "", allDataCols)

# extend abbreviations to full descriptive name
allDataCols <- gsub("^f", "frequencyDomain", allDataCols)
allDataCols <- gsub("^t", "timeDomain", allDataCols)
allDataCols <- gsub("Acc", "Accelerometer", allDataCols)
allDataCols <- gsub("Gyro", "Gyroscope", allDataCols)
allDataCols <- gsub("Mag", "Magnitude", allDataCols)
allDataCols <- gsub("Freq", "Frequency", allDataCols)
allDataCols <- gsub("mean", "Mean", allDataCols)
allDataCols <- gsub("std", "StandardDeviation", allDataCols)

# correct typo
allDataCols <- gsub("BodyBody", "Body", allDataCols)

# use new labels as column names
colnames(allData) <- allDataCols
names(allDataCols)


##############################################################################
# Part 5 - Create a second, independent tidy set with the average of each variable for each activity and each subject
##############################################################################


allDataMean <- allData %>% 
  group_by(subjectID, activityID) %>%
  summarise_all(funs(mean))

# output to file "tidy_data.txt"
write.table(allDataMean, file = "tidydata.txt",row.name=FALSE)

#  Alternate approach:  

# Use the function aggregate to split data into subsets by subject and activity, compute summary statistics using mean for each
# dot and tilde shortcut tricks sort of explained.  
# Note to self:  Like idioms in a new langauge, they are easier to learn through through habit and use
# than memorizing rules.

# The . is similar to ~ in that it is used to capture the name of variables, not their current value.
# From help(".) The dot quotes variables to create a list of unevaluated expressions for later evaluation.
# The dot looks at the variables in data.frame that you use in your model call, 
# sees which variables exist in the data.frame but aren't explicitly mentioned in your formula, and replaces the dot with those missing variables.
# This is used throughout plyr to specify the names of variables 
#
# The Tilde is used so speararte left and right-hand sides in a model formula
# The ~ in aggregate() separates, to the left side, what is being "aggregated", and to the right side, what is being used to "aggregate" the items.

# Data2 <- aggregate(. ~subjectId + activityId, allDataCols, mean)
# Data2<-Data2[order(Data2$subjectID,Data2$activityID),]