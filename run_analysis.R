
# Getting and Cleaning Data Course Project 


library(plyr)

# gather the required data sets
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
combinedX <- rbind(X_test,X_train)

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
combinedY <- rbind(y_test,y_train)


# names of the features 
features <- read.table("./UCI HAR Dataset/features.txt")
names(combinedX) <- features[,2]
# Get only the mean and std dev columns 
colsToRetain <- grep("(mean|std)\\(\\)", names(combinedX))
combinedX <- combinedX[,colsToRetain]

# Gather the activities details
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
combinedY$V1 <- activity_labels[combinedY$V1,2]
names(combinedY) <- "Activity"

# give the data set meaningful column names
names(combinedX) <-  gsub("-mean\\(\\)", "Mean", names(combinedX))
names(combinedX) <-  gsub("-std\\(\\)", "StdDev", names(combinedX))
names(combinedX) <-  gsub("^t", "Time", names(combinedX))
names(combinedX) <-  gsub("^f", "Freq", names(combinedX))
names(combinedX) <-  gsub("BodyBody", "Body", names(combinedX))
# gateher the subject details
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
combinedSubject <- rbind(subject_test,subject_train)
names(combinedSubject) <- "Subject"


# Collate all data into one dataset

completeSetOfData <- cbind(combinedY,combinedSubject,combinedX)

# Get the final output 

tidyData <- ddply(completeSetOfData,.(Activity,Subject),function(x){colMeans(x[,-c(1,2)])})

# write to file

write.table(tidyData, "tidyData.txt", row.names = FALSE)