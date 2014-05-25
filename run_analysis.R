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
# Adding the original variable names. 
names(xTrain) <- paste0(featuresList)
colnames(yTrain)[1] <- 'subject'
trainCombined <- cbind(yTrain, xTrain)

names(xTest) <- paste0(featuresList)
colnames(yTest)[1] <- 'subject'
testCombined <- cbind(yTest, xTest)



# Adding labels for test and train datasets. 
trainCombined$label <- 'Train'
testCombined$label <- 'Test'

# Merging both test and train datasets. 
mergedDataset <- rbind(trainCombined, testCombined)

# 3.Uses descriptive activity names to name the activities in the data set
for (i in 1:nrow(activityLabels)) {
    testCombined$subject <- gsub(i, as.character(activityLabels[i, 2]), testCombined$subject)
    trainCombined$subject <- gsub(i, as.character(activityLabels[i, 2]), trainCombined$subject)
    if (i == nrow(activityLabels)) { 
        colnames(trainCombined)[1] <- 'activity'
        colnames(testCombined)[1] <- 'activity' 
    }
}


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# This regex allows me to identify what are the variables that have
# the mean or the standard deviation in them. 
meanIndex <- which(grepl(pattern = "-mean()", names(mergedDataset)))
stdIndex <- which(grepl(pattern = "-std()", names(mergedDataset)))
labelIndex <- which(grepl(pattern = "label", names(mergedDataset)))
avtivityIndex <- which(grepl(pattern = "activity", names(mergedDataset)))
meanstdIndex <- c(meanIndex, stdIndex, labelIndex, avtivityIndex)
meanstdIndex <- sort(meanstdIndex)

# Selecting only the mean and std variables. 
meanstdData <- data.frame(mergedDataset[, meanstdIndex])



# 4. Appropriately labels the data set with descriptive activity names. 

#### Naming function ####
#
# The structure of names is the following: 
#
#          1 2   3    4     5
#          ↓ ↓   ↓    ↓     ↓
#          tBodyGyro.mean...X
# 
# 1. A letter (t or f): 
# 2. A type of capture (Body, BodyBody or Gravity): 
# 3. The sensor (Acc, AccJerk, AccMag, AccJerkMag, Gyro, GyroJerk, GyroMag): 
# 4. The measurement (mean, std, meanFreq):
# 5. A trailing letter (X, Y or Z) for the 3-axial signals.




ProperNaming <- function(df = NULL) { 
    
    newNames <- names(meanstdData)
 
    # Changing the letters
    newNames[1:40] <- sub("t", "TimeSignal", newNames[1:40])  # Time signal.
    newNames[40:79] <- sub("f", "FFTransformation", newNames[40:79])  # FFT transformation.
    
    # Renaming the sensor type.
    newNames <- gsub("Acc", "Accelerometer", newNames)
    newNames <- gsub("AccelerometerJerkMag", "AccelerometerJerkMagnitude", newNames)
    newNames <- gsub("AccelerometerMag", "Accelerometer", newNames)    
    newNames <- gsub("Gyro", "Gyroscope", newNames)
    newNames <- gsub("GyroscopeMag", "GyroscopeMagnitude", newNames)
        
    # Renaming the measurement.
    newNames <- gsub(".mean", "_Mean", newNames)
    newNames <- gsub(".std", "_StandardDeviation", newNames)
    newNames <- gsub(".meanFreq", "_MeanFrequency", newNames)
    
    # Renaming the final letters.
    newNames <- gsub("...X", "XAxis", newNames)
    newNames <- gsub("...Y", "YAxis", newNames)
    newNames <- gsub("...Z", "ZAxis", newNames)
    
    # Cleaning up.
    newNames <- gsub("..", "", newNames, fixed = TRUE)

    names(df) <- newNames
    
    df
}

meanstdData <- ProperNaming(meanstdData)


# Storing the resulting dataset.
write.csv(meanstdData, 'data/TidyData.csv', row.names = FALSE)


