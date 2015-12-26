### 
### Download Data set
### Param boolean to download zip or not
###
analysisSetup <- function(download)
{
  #download dataset if requested
  if (download==TRUE)
  {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","samdataset.zip",mode="wb")
  }
  
  #create data directory
  if (!file.exists("datadir"))
  {
    dir.create("datadir")
  }
  
  #unzip dataset
  unzip("samdataset.zip",exdir="./datadir")
}

###
### Load test data set
### Param list of features (columns)
###
analysisLoadTestSet <- function(featureSet)
{
  #Load Test Set (use table as CSV does not handle double space seperator)
  testSet <- read.table("./datadir/UCI HAR Dataset/test/X_test.txt",header = FALSE, stringsAsFactors = FALSE)
  
  #Set column names as feature vector 2nd element
  names(testSet) <- featureSet[,2]
  
  #Load Test Set Activity
  testSetActivity <- read.table("./datadir/UCI HAR Dataset/test/y_test.txt",header = FALSE, stringsAsFactors = FALSE)
  
  #Set column name
  names(testSetActivity) <- "Activity"
  
  #Load Test Set Subjects
  testSetSubjects <- read.table("./datadir/UCI HAR Dataset/test/subject_test.txt",header = FALSE, stringsAsFactors = FALSE)
  
  #Set column name
  names(testSetSubjects) <- "Subject"
  
  #Add Activity & Subject column 
  testSet <- cbind(testSet,testSetSubjects,testSetActivity)
  
  return (testSet)
}

###
### Load train data set
### Param list of features (columns)
###
analysisLoadTrainSet <- function(featureSet)
{
  #Load Test Set (use table as CSV does not handle double space seperator)
  trainSet <- read.table("./datadir/UCI HAR Dataset/train/X_train.txt",header = FALSE, stringsAsFactors = FALSE)
  
  #Set column names as feature vector 2nd element
  names(trainSet) <- featureSet[,2]
  
  #Load train Set Activity
  trainSetActivity <- read.table("./datadir/UCI HAR Dataset/train/y_train.txt",header = FALSE, stringsAsFactors = FALSE)
  
  #Set column name
  names(trainSetActivity) <- "Activity"
  
  #Load train Set Activity
  trainSetSubjects <- read.table("./datadir/UCI HAR Dataset/train/subject_train.txt",header = FALSE, stringsAsFactors = FALSE)
  
  #Set column name
  names(trainSetSubjects) <- "Subject"
  
  #Add Activity & Subject column 
  trainSet <- cbind(trainSet,trainSetSubjects, trainSetActivity)
  
  return (trainSet)
}


### 
### Load Data sets and combine into a single set
###
analysisLoadFiles <- function()
{
  #Load Column Names
  featureSet <- read.csv("./datadir/UCI HAR Dataset/features.txt",sep=" ",header = FALSE, stringsAsFactors = FALSE)
  
  testSet <- analysisLoadTestSet(featureSet)
  trainSet <- analysisLoadTrainSet(featureSet)
  
  #Combine sets
  masterSet <- rbind(testSet,trainSet)
  
  return(masterSet)
}


###
### Extract only the -std and -mean columns 
### Param master data set
###
analysisExtractMeanAndStd <- function(masterSet)
{
  #Find all the -std columns
  stdColumns <- grep("-std",names(masterSet))
  
  #Find all the -mean columns
  meanColumns <- grep("-mean",names(masterSet))
  
  #Add activity & subject columns (last 2)
  actAndSubjColumn = c(ncol(masterSet)-1,ncol(masterSet))
  
  #Combine columns and sort columns back into original order
  colToExtract <- sort(c(stdColumns,meanColumns,actAndSubjColumn))
  
  #Extract Wanted Columns
  masterColumnSubset <- masterSet[,colToExtract]
}

###
### Convert 1:6 activity names into descriptive names
### Param dataset
###
analysisSetActivityNames <- function(masterSet)
{
  #Load Activity Names
  activityName <- read.csv("./datadir/UCI HAR Dataset/activity_labels.txt",sep=" ",header = FALSE, stringsAsFactors = FALSE)
  
  #Convert activity number 1:6 to descriptive equivilant
  for (i in 1:6)
  {
    #2 is the decriptive column
    masterSet[masterSet$Activity==i,ncol(masterSet)] <- activityName[i,2]
  }
  
  return(masterSet)
}


### 
### Create summarise command to group by Subject and Activity then take an average of numeric values
### Param dataset
###
analysisCreateSummariseCmd <- function(masterDataExtract)
{
  
  #1st part of cmd
  summariseCmd <- "summarise(group_by(masterDataExtract,Subject ,Activity)"  
  
  namesVector <- names(masterDataExtract)
  
  #loop over required columns minus activity and subject
  for (i in 1:79)
  {
    summariseCmd <- paste0(summariseCmd,",mean(",namesVector[i],")",sep="")
  }
  
  #close command
  summariseCmd <- paste0(summariseCmd,")")
  
  return(summariseCmd)
}

###
### Use the dynamically created summarise command to aggregate the data by subject AND activity
### Param dataset, summarised command
###
analysisCreateFinalExtract <- function(masterDataExtract,cmd)
{
  #run summarise cmd after parsing from text to cmd
  summarisedData <- eval(parse(text=cmd))
  
  #Write data to file
  write.table(summarisedData,"avg_by_subject_AND_activity.txt",row.name=FALSE)
  
  #return data 
  return(summarisedData)
}

###
### Main routine
###
analysisRun <- function(download = FALSE)
{
  #Load Libraries
  library(dplyr)
  
  #Prep Data
  analysisSetup(download)
  
  #Load Data
  masterData <- analysisLoadFiles()
  
  #Extract Columns
  masterDataExtract <- analysisExtractMeanAndStd(masterData)
  
  #Descriptive activity names
  masterDataExtract <- analysisSetActivityNames(masterDataExtract)
  
  #Make names R compatible
  names(masterDataExtract) <- make.names(names(masterDataExtract))
  
  #Create final Data Extract using dynamically created summarise command (cmd)
  analysisCreateFinalExtract(masterDataExtract,analysisCreateSummariseCmd(masterDataExtract))

}