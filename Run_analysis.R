## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

require(reshape2)

## Creating a directory to store the data. Downloading and unzipping the .zip file

setwd("C:/Users/Daniela/Coursera/Getting and Cleaning Data")

if(!file.exists("data")){dir.create("data")}
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,dest="dataset.zip")
unzip("dataset.zip")

## Read data into tables
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")

# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# add column names for measurement files
names(x_train) <- features$V2
names(x_test) <- features$V2

# add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"


## 1. Merges the training and the test sets to create one data set.
training_dataset<-cbind(cbind(x_train,subject_train),y_train)
test_dataset<-cbind(cbind(x_test,subject_test),y_test)
dataset<-rbind(training_dataset,test_dataset)

## 2. Extract only the measurements on the mean and standard deviation for each measurement
dataset_mean<-sapply(dataset,mean,na.rm=TRUE)
dataset_sd<-sapply(dataset,sd,na.rm=TRUE)

## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive activity names.

dataset$activity <- factor(dataset$activity, 
                            labels=c("Walking","Walking Upstairs",
                                     "Walking Downstairs", "Sitting", 
                                     "Standing", "Laying"))

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# create the tidy data set
melt <- melt(dataset, id=c("subjectID","activity"))
tidy.dataset <- dcast(melt, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy.dataset, "tidy_dataset.csv", row.names=FALSE)