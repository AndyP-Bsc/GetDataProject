---
title: "README"
output: html_document
---

This repo contains a solution for the Getting and Cleaning Data course project. The provided script makes use of the Samsung Galaxy data to perform statistical analysis of subjects and their activities after 1st assembling the data into a tidy dataset.

The data is sourced from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Script Mechanics 

The script performs the following data prep steps:
```
- (optionally) downloads the source data zip into a file called samdataset.zip
- Unzips samdataset.zip into ./datadir directory (creates directory if not exists)
```

The script performs the following load and data steps:
```
- Loads test data set (X_test.txt) and sets columns to that supplied in the feature.txt file
- Loads associated test data subjects (subject_test.txt)
- Loads associated activities (y_test.txt)
- The script then combines the above 3 results into a single table (i.e. it adds activity and subject columns to the test data set)
- This is repeated for the train data set
- Once test and train datasets are loaded they are then combined into a single dataset

```

Data analysis 
```
- The script then extracts the required columns (i.e. those that end in -std or -mean)
- The script translates activity numbers into activity names (referencing activity_labels.txt)
- The script makes column names 'R' compatible using make.names
- The script creates a dynamic summarise command using the mean function which also groups by Subject & Activity as in:
summarise(group_by(dataset,Subject ,Activity,mean(colx)...)
- The script then saves this summarised data set to avg_by_subject_AND_activity.txt in the working directory as well as returning the data from the analysisRun() function
```

# Running The Script

1. Download Script either by:
+ Save run_analysis.R to your local R working directory
+ OR from R: source("https://raw.githubusercontent.com/AndyP-Bsc/GetDataProject/master/run_analysis.R")
2. Usage From R: analysisRun(download = FALSE) 
+ If download = FALSE then you will need to have previously saved the Samsung data zip file to a local file called samdataset.zip (in your working directory). 
+ If download = TRUE then the script will automatically download the data from the Internet for you.
3. The analysisRun function will output the summarised data to the file avg_by_subject_AND_activity.txt (in your working directory) as well as providing the data as part of the function return (i.e. available as e.g. MySummarisedData <- analysisRun()) 

# Code book

A full description of the input dataset that was used for this analysis can be found in the README.txt from http://archive.ics.uci.edu/ml/machine-learning-databases/00240/ part of which is quoted below:

```
"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag"
```

Specifically this analysis outputs the mean of the above fields as well as the test Subjects number in question and the activity they were undertaking for that observation, to give us:

```
Subject
Activity
mean(tBodyAcc.mean...XYZ)
mean(tGravityAcc.mean...XYZ)
mean(tBodyAccJerk.mean...XYZ)
mean(tBodyGyro.mean...XYZ)
mean(tBodyGyroJerk.mean...XYZ)
mean(tBodyAccMag)
mean(tGravityAccMag)
mean(tBodyAccJerkMag)
mean(tBodyGyroMag)
mean(tBodyGyroJerkMag)
mean(fBodyAcc.mean...XYZ)
mean(fBodyAccJerk.mean...XYZ)
mean(fBodyGyro.mean...XYZ)
mean(tBodyAcc.std...XYZ)
mean(tGravityAcc.std...XYZ)
mean(tBodyAccJerk.std...XYZ)
mean(tBodyGyro.std...XYZ)
mean(tBodyGyroJerk.std...XYZ)
mean(tBodyAccMag)
mean(tGravityAccMag)
mean(tBodyAccJerkMag)
mean(tBodyGyroMag)
mean(tBodyGyroJerkMag)
mean(fBodyAcc.std...XYZ)
mean(fBodyAccJerk.std...XYZ)
mean(fBodyGyro.std...XYZ)
mean(fBodyAccMag.mean..)
mean(fBodyAccMag.std..)
mean(fBodyAccMag.meanFreq..)
mean(fBodyBodyAccJerkMag.mean..)
mean(fBodyBodyAccJerkMag.std..)
mean(fBodyBodyAccJerkMag.meanFreq..)
mean(fBodyBodyGyroMag.mean..)
mean(fBodyBodyGyroMag.std..)


UNITS

- Each row identifies the subject who performed the activity (and which activity) 
- *Acc*: The mean of acceleration signal from the smartphone accelerometer XYZ (as appropriate) axis in standard gravity units 'g'.  
- *BodyAcc* The mean of body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- *BodyGyro* The mean of angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 
```




