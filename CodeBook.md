# Code book for Coursera Getting and Cleaning Data course project
## Download the data to a clean directory

Remove existing data and values in global environment to save memory and avoid confusion.

Load the dplyr library

Download data to data directory if not already downloaded.  The data can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Unzip the data to a local directory.

### The dataset includes the following files: 
1.  activity_labels.txt: Links the class labels with their activity name.
2.  features.txt: List of all features.
3.  features_info.txt: Shows information about the variables used on the feature vector.
4.  README.txt: Shows originators information for data

and the directories /test and /train.

### Files in the directory /test:
5. subject_test.txt
6. x_test.txt: Test set
7. y_text.txt: Test labels

and the directory /inertial signals.

### Files in the directory /train
8. subject_train.txt
9. x_train.txt: Training set
10. y_train.txt: Training lables

and the directory /inertial signals

## Part 1. Read data

Step 1.  Read data files in table format and create a data frame from it, with cases corresponding to lines and variables to fields in the file.

Step 2. Merge the training and test sets to create one data set

- trainData: Concatenates (combines) columns of data in directory /train (files 5, 6, 7)

- testData: Concatenates (combines) columns of data in directory /test (files 8, 9, 10)

- allData: Concatenates (combines) rows of data trainData and testData


Step 3. Assign column names to the data allData

−	activityID, 
-subjectID, and the 
- original column names in the file features.txt (file 

Step 4.  Remove individual data tables to save memory

x_test, y_test, subject_test, x_train, y_train, subject_train, trainData, testData

## Part 2. Extract only the measurements on the mean and standard deviation for each measurement

Step 1. Determine columns of data set to keep based on column name. Use grep.

cKeepers:  Column names in the data allData that include 
- “subject”, and/or 
- “activity”, and/or, “mean” and/or,
- “std.”

Step 2. Reassign the data allData with only those columns in object ckeepers.

Part 3 Use descriptive activity names to name the activities in the data set

Replace activity values with named factor levels in the data activity_Labels.txt (file 1)

## Part 4: Appropriately label the data set with descriptive variable names

Step 1. Assign column names in data allData to vector allDataCols

Step 2. Use gsub function for pattern replacement to clean up the data labels in allDataCols
−	remove special characters
−	extend abbreviations to full descriptive names
−	correct typos
−	use new labels as column names

Step 3. Use new column names for column labels in data allData

## Part 5 - Create a second, independent tidy set with the average of each variable for each activity and each subject

Step 1. Use dplyr functions group_by and summarize_by mean.

Step 2. output to file "tidy_data.txt"

********

For more information about the original dataset contact: activityrecognition@smartlab.ws

License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
