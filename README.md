Wearable Tracking Study
=======================

**Note:** This repository is part of for Coursera's course 'Getting and Cleaning Data' final assignment.


Description
-----------

The main content of this repository is the [run_analysis.R](https://github.com/luiscape/wearable_tracking_study/blob/master/run_analysis.R) script. That script downloads a dataset from the [Human Activity Recognition Using Smartphones Data Set project](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). It downloads the data from the web, exctracts only the mean and standard deviation measurements and then prepares that dataset for analysis making it "Tidy".

The tidy version of the original dataset uses Hadley Wickham's [tidy data principles](http://vita.had.co.nz/papers/tidy-data.pdf). It functions in 6 steps as follows:

* **Step 1:** fetches the data from the web.
* **Step 2:** merges the test and train datasets into a single dataset.
* **Step 3:** uses descriptive activity names instead of integers.
* **Step 4:** extracts only the mean and standard deviation measurements.
* **Step 5:** labels the variable names in more human readable forms and "tidies" the dataset following Wickham's principles.
* **Step 6:** stores the tidy dataset in a CSV file.

The resulting is a dataset with the following format:

![Tidy Dataset](https://raw.githubusercontent.com/luiscape/wearable_tracking_study/master/tidy_dataset.png "Tidy Dataset")

The resulting variables from the dataset and their respective explanations can be found in the [CodeBook.md](https://github.com/luiscape/wearable_tracking_study/blob/master/CodeBook.md) available in this repository.
