## Coursera Getting and Cleaning Data -- Programming Assignment ##
# 
# In this assignment we were asked to fetch data from the internet 
# and make it "tidy". I used Hadley Wickham's tidy data principles
# when writing this function. 
#
# This function has 6 steps as follows: 
#
#   Step 1: fetching the data. 
#   Step 2: merges the test and train datasets into a single dataset.
#   Step 3: uses descriptive activity names instead of integers.
#   Step 4: extracts only the mean and standard deviation measurements.
#   Step 5: labels the variable names in more human readable forms and "tidies"
#           the dataset following Wickham's principles.
#   Step 6: stores the tidy dataset in a CSV file.
#
#
# Author: Luis Capelo | @luiscape

# Loading dependencies.
library(reshape2)  # for using melt. 
library(plyr)  # for using rbind.fill

## STEP 1 ##
# Fetching the data.
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


## STEP 2 ##
# Merging the training and the test sets to create one data set.

# Adding the original variable names to the Train dataset.
names(xTrain) <- paste0(featuresList)
colnames(yTrain)[1] <- 'subject'
trainCombined <- cbind(yTrain, xTrain)

# Adding the original variable names to the Test dataset.
names(xTest) <- paste0(featuresList)
colnames(yTest)[1] <- 'subject'
testCombined <- cbind(yTest, xTest)

# Adding labels for test and train datasets. 
trainCombined$label <- 'Train'
testCombined$label <- 'Test'

# Merging both test and train datasets. 
mergedDataset <- rbind(trainCombined, testCombined)


## STEP 3 ##
# Using descriptive activity names to name the activities in the data set

# For loop that adds labels to the activities. 
for (i in 1:nrow(activityLabels)) {
    testCombined$subject <- gsub(i, as.character(activityLabels[i, 2]), testCombined$subject)
    trainCombined$subject <- gsub(i, as.character(activityLabels[i, 2]), trainCombined$subject)
    if (i == nrow(activityLabels)) { 
        colnames(trainCombined)[1] <- 'activity'
        colnames(testCombined)[1] <- 'activity' 
    }
}


## STEP 4 ##
# Extracting only the measurements on the mean and standard deviation for each measurement.

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



## STEP 5 ##
# Appropriately labeling the data set with descriptive activity names. 

# Here I am using the Tidy Data article by Hadley Wickham to determine 
# how to create correct variable columns.

TidyThisData <- function(df = NULL) { 
    
    message('Using regex to extract the appropriate variables.')
    
    # Index for the activity and label.
    tidyActivityIndex <- which(grepl(pattern = "activity", names(df), fixed = T))
    tidyLabelIndex <- which(grepl(pattern = "label", names(df), fixed = T))
    
    ## Signals
    # Time signal
    tidyIndex1 <- which(grepl(pattern = "t", names(meanstdData[1:41]), fixed = TRUE))
    tidyTimeIndex <- c(tidyLabelIndex, tidyIndex1)
    SignalTimeData <- data.frame(meanstdData[, tidyTimeIndex])
    SignalTimeData$Signal <- 'Time'
    
    # Fast Fourier transform signal
    tidyIndex2 <- which(grepl(pattern = "f", names(meanstdData), fixed = TRUE))
    tidyFFTIndex <- c(tidyActivityIndex, tidyLabelIndex, tidyIndex2)
    SignalFFTData <- data.frame(meanstdData[, tidyFFTIndex])
    SignalFFTData$Signal <- 'Fast Fourier Transform'
    
    signalDFOutput <<- rbind.fill(SignalTimeData, SignalFFTData)
    
    regexList <- c('BodyBody', 'Body', 'Gravity', 
                   'AccJerkMag', 'AccMag', 'AccJerk', 'Acc',
                   'GyroMag', 'GyroJerk', 'Gyro', 
                   '.mean', '.std', '.meanFreq', 
                   '...X', '...Y', '...Y')
    
    variableList <- c('BodyBody', 'Body', 'Gravity', 
                      'Accelerometer Jerk Magnitude', 'Accelerometer Magnitude', 
                      'Accelerometer Jerk', 'Accelerometer', 
                      'Gyroscope Magnitude', 'Gyroscope Jerk', 'Gyroscope',
                      'Mean', 'Standard Deviation', 'Mean Frequency', 
                      'X', 'Y', 'Z')
    
    
    for (i in 1:length(regexList)) {
        
        if (i > 0 && i <= 3) {  # for the capture labelling
            
            tidyIndex <- which(grepl(pattern = regexList[i], 
                                     names(df), fixed = TRUE))
            
            tidyCaptureIndex <- c(tidyActivityIndex, tidyLabelIndex, tidyIndex)
            captureDataframe <- data.frame(df[, tidyCaptureIndex])
            captureDataframe$Capture <- variableList[i]
            if (i == 1) { captureDFOutput <- captureDataframe }
            else { captureDFOutput <<- rbind.fill(captureDFOutput, captureDataframe) } 
            
        }
        
        if (i > 3 && i <= 11) {  # for the sensor labelling
            
            tidyIndex <- which(grepl(pattern = regexList[i], 
                                     names(df), fixed = TRUE))
            
            tidySensorIndex <- c(tidyActivityIndex, tidyLabelIndex, tidyIndex)
            sensorDataframe <- data.frame(df[, tidySensorIndex])
            sensorDataframe$Sensor <- variableList[i]
            if (i == 4) { sensorDFOutput <- sensorDataframe }
            else { sensorDFOutput <- rbind.fill(sensorDFOutput, sensorDataframe) } 
            
        }
        
        if (i > 11 &&  i <= 13) {  # for the measurement 
            
            tidyIndex <- which(grepl(pattern = regexList[i], 
                                     names(df), fixed = TRUE))
            
            tidyMeasurementIndex <- c(tidyActivityIndex, tidyLabelIndex, tidyIndex)
            measurementDataframe <- data.frame(df[, tidyMeasurementIndex])
            measurementDataframe$Measurement <- variableList[i]
            if (i == 12) { measurementDFOutput <- measurementDataframe }
            else { measurementDFOutput <- rbind.fill(measurementDFOutput, measurementDataframe) } 
        }
        
        if (i > 13 &&  i <= 16) {  # for the axis 
            
            tidyIndex <- which(grepl(pattern = regexList[i], 
                                     names(df), fixed = TRUE))
            
            names(df) <- gsub(pattern = regexList[i], "xx", names(df), fixed = TRUE)
            
            tidyAxisIndex <- c(tidyActivityIndex, tidyLabelIndex, tidyIndex)
            axisDataframe <- data.frame(df[, tidyAxisIndex])
            axisDataframe$Axis <- variableList[i]
            if (i == 14) { axisDFOutput <- axisDataframe }
            else { axisDFOutput <- rbind.fill(axisDFOutput, axisDataframe) } 
        }
    
    }

    message('Using `plyr` to melt the variable data.frames.')
    
    signalDFOutputMelt <- melt(signalDFOutput)
    captureDFOutputMelt <- melt(captureDFOutput)
    sensorDFOutputMelt <- melt(sensorDFOutput)
    measurementDFOutputMelt <- melt(measurementDFOutput)
    axisDFOutputMelt <- melt(axisDFOutput)
    
    message('Merging the variable data.frames into a single data.frame.')
    
    tidyData <- merge(signalDFOutputMelt, captureDFOutputMelt, 
                      by = c('label', 'activity', 'value'))
    
    tidyData$variable <- NULL
    tidyData$variable <- NULL
    
    tidyData <- merge(tidyData, sensorDFOutputMelt, 
                      by = c('label', 'activity', 'value'))
    
    tidyData$variable <- NULL
    
    tidyData <- merge(tidyData, measurementDFOutputMelt, 
                      by = c('label', 'activity', 'value'))
    
    tidyData$variable <- NULL
    
    tidyData <- merge(tidyData, axisDFOutputMelt, 
                      by = c('label', 'activity', 'value'))
    
    tidyData$variable <- NULL
    tidyData$variable.x <- NULL
    tidyData$variable.y <- NULL
    
    print(names(tidyData))
    
    message('Cleaning ...')
    
    # Cleaning labels.
    tidyLabels <- c('Label', 'Activity', 'Value', 'Signal', 
                    'Capture', 'Sensor', 'Measurement', 'Axis')
    
    names(tidyData) <- tidyLabels
          
    message('Done!')
    
    tidyData
}

TidyData <- TidyThisData(meanstdData)

## STEP 5 ##
# Storing the resulting dataset.
dir.create('data')
write.csv(TidyData, 'data/TidyData.csv', row.names = FALSE)