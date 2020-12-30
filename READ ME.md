READ ME for Week 4 Assignment
GettingandCleaningData

    The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.You will be required to submit:

    a tidy data set as described below
    a link to a Github repository with your script for performing the analysis
    codeBook.md that describes the variables, the data, and any work that you performed to clean up the data
    README.md that explains how all of the scripts work and how they are connected.

    One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

    Here are the data for the project:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

    You should create one R script called run_analysis.R that does the following.

        Merges the training and the test sets to create one data set.
        Extracts only the measurements on the mean and standard deviation for each measurement.
        Uses descriptive activity names to name the activities in the data set.
        Appropriately labels the data set with descriptive activity names.
        Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    Good luck!

Code explanations

#Began by applying the same read format to all files. Use sep="" based on file formatting. Use header=FALSE, but don't want to lose first row of data. If header=TRUE, first row would be column names which we do not want.

Reads these two file from UCI HAR Dataset. For activity labels first column includes rownumber which is not needed.

   #Reading Features and ActivityLabels vector
   features <- read.csv("features.txt", sep = "", header = FALSE)[2]
   activities <- read.csv("activity_labels.txt", sep = "", header = FALSE)

Again reads from same location and combine test and train set with rbind function.

   #Reading Sets
   testSet <- read.csv("X_test.txt", sep = "", header = FALSE)
   trainSet <- read.csv("X_train.txt", sep = "", header = FALSE)
   mergedSet <- rbind(testSet,trainSet)        

Repeat previous steps

   #Reading Movement
   testMoves <- read.csv("Y_test.txt", sep = "", header = FALSE)
   trainMoves <- read.csv("Y_train.txt", sep = "", header = FALSE)
   mergedMoves <- rbind(testMoves, trainMoves)
      
   #Reading PersonID
   testPerson <- read.csv("subject_test.txt", sep = "", header = FALSE)
   trainPerson <- read.csv("subject_train.txt", sep = "", header = FALSE)
   mergedPerson <- rbind(testPerson, trainPerson)

Assigns real column attributes(decriptive column names) that is kept in features vector to mergedSet we have formed in previous steps. After that, select all columns that key values passing through this attributes

   #Extracting columns which includes measurements
   names(mergedSet) <- features[ ,1]
   mergedSet <- mergedSet[ grepl("std|mean", names(mergedSet), ignore.case = TRUE) ] 

Descriptive values for activity columns.

   #Descriptive ActivityName analysis
   mergedMoves <- merge(mergedMoves, activities, by.x = "V1", by.y = "V1")[2]
   mergedSet <- cbind(mergedPerson, mergedMoves, mergedSet)
   names(mergedSet)[1:2] <- c("PersonID", "Activities")

Tidying set according to personID and activities

   #Tidying mergedSet
   group_by(mergedSet, PersonID, Activities) %>%
         summarise_each(funs(mean))
         
Prepare final table
write.table(tidy,file="Assignment.txt",row.names=FALSE)