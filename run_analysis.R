# You should create one R script called run_analysis.R that does the following. 

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


# Opening a temporary connection and downloading the data.
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = temp, 
              method  = 'curl')

# Reading the features list. 
features_list <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))

# Reading trainign data.
x_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz(temp, 'UCI HAR Dataset/train/y_train.txt'))

# Reading test data.
x_test <- read.table(unz(temp, 'UCI HAR Dataset/test/X_test.txt'))
y_test <- read.table(unz(temp, 'UCI HAR Dataset/test/y_test.txt'))

# Cleaning up.
unlink(temp)

# Organizing the feature list.
features_list <- as.list(features_list[2])
features_list <- paste(features_list[[1]])


# 1. Merges the training and the test sets to create one data set.

# Fixing the variable names.
names(x_train) <- paste0(features_list)
colnames(y_train)[1] <- 'subject'
train_combined <- cbind(y_train, x_train)

names(x_test) <- paste0(features_list)
colnames(y_test)[1] <- 'subject'
test_combined <- cbind(y_test, x_test)

# These seem to be the subject list. There is also the 
# subject_train / test.txt file. Read the docs!
names(y_train) <- paste0(features_list)
names(y_test) <- paste0(features_list)

# Fail by regular merge. 
x <- merge(x_train, x_test)
y <- merge(y_train, y_test)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.





