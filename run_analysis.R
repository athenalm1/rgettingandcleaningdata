#This script merges the training and the test sets to create one data set

#Set working directory
setwd("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3")

#Download project data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "data.zip")
unzip("data.zip")
setwd("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset")

#Read training files for x, y, and subject data
xtrain <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/train/X_train.txt"))
ytrain <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/train/y_train.txt"))
strain <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/train/subject_train.txt"))

#Read test files for x, y, and subject data
xtest <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/test/X_test.txt"))
ytest <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/test/y_test.txt"))
stest <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/test/subject_test.txt"))

# (1) merge the training and test sets to create one data set
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
sdata <- rbind(strain, stest)

# features and activity labels
features <- read.table(("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/features.txt"))
activityLabels <- read.table("C:/Users/Athena Marquez/Desktop/R_Projects/Course_3/UCI HAR Dataset/activity_labels.txt")

# (2) Extract measurements on the mean and standard deviation for each measurement
measures <- grep("mean|std).*", as.character(features[,2]))
measureNames <- features[measures, 2]
measureNames <- gsub("-mean", "Mean", measureNames)
measureNames <- gsub("-std", "std", measureNames)
measureNames <- gsub("[-()]", "", measureNames)

# (3) Use descriptive activity names to name the activities in the data set
# (4) Label the data set with descriptive variable names
projectdata <- cbind(sdata, ydata, xdata)
colnames(projectdata) <- c("Subject", "Activity", measureNames)

projectdata$Activity <- factor(projectdata$Activity, levels = activityLabels[,1], labels = activityLabels[,2])
projectdata$Subject <- as.factor(projectdata$Subject)

#Check if "reshape" package is installed
if (!"reshape2" %in% installed.packages()) 
  {install.packages("reshape2")}
library("reshape2")

#(5) Independent tidy data set with the average of each variable for each activity and each subject
melted <- melt(projectdata, id = c("Subject", "Activity"))
tidydata <- dcast(melted, Subject + Activity ~ variable, mean)
write.table(tidydata, "./tidy_data.txt", row.name = FALSE)

#Output
View(projectdata)
View(tidydata)