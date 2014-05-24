# You should create one R script called run_analysis.R that does the following. 

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


# Opening a temporary connection and downloading the data.
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = temp, 
              method  = 'curl')

# Reading the features list and labels.
featuresList <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
activityLabels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"), sep = " ")
names(activityLabels) <- c('activity', 'label')

# Reading trainign data.
xTrain <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
yTrain <- read.table(unz(temp, 'UCI HAR Dataset/train/y_train.txt'))

# Reading test data.
xTest <- read.table(unz(temp, 'UCI HAR Dataset/test/X_test.txt'))
yTest <- read.table(unz(temp, 'UCI HAR Dataset/test/y_test.txt'))

# Cleaning up.
unlink(temp)

# Organizing the feature list.
featuresList <- as.list(featuresList[2])
featuresList <- paste(featuresList[[1]])


# 1. Merges the training and the test sets to create one data set.

# Fixing the variable names.
names(xTrain) <- paste0(featuresList)
colnames(yTrain)[1] <- 'subject'
trainCombined <- cbind(yTrain, xTrain)

names(xTest) <- paste0(featuresList)
colnames(yTest)[1] <- 'subject'
testCombined <- cbind(yTest, xTest)

# Adding labels to the activities.
for (i in 1:nrow(activityLabels)) {
    testCombined$subject <- gsub(i, as.character(activityLabels[i, 2]), testCombined$subject)
    trainCombined$subject <- gsub(i, as.character(activityLabels[i, 2]), trainCombined$subject)
    if (i == nrow(activityLabels)) { 
        colnames(trainCombined)[1] <- 'activity'
        colnames(testCombined)[1] <- 'activity' 
    }
}

# Adding labels for test and train datasets. 
trainCombined$label <- 'Train'
testCombined$label <- 'Test'

# Merging both test and train datasets. 
mergedDataset <- rbind(trainCombined, testCombined)

# This regex allows me to identify what are the variables that have
# the mean or the standard deviation in them. 
grepl(pattern = "-mean()", names(mergedDataset))
grepl(pattern = "-std()", names(mergedDataset))

# Identify those variables that have -mean() or -std() in it. 
# And extract them into a separate dataset.


# These seem to be the subject list. There is also the 
# subject_train / test.txt file. Read the docs!


# Fail by regular merge. 
# x <- merge(test_combined, train_combined, by = 'subject')


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 





