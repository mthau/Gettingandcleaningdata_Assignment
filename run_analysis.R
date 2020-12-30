##Move all data into the same folder

##Reading Features and ActivityLabels vector
features <- read.csv("features.txt", sep = "", header = FALSE)[2]
activities <- read.csv("activity_labels.txt", sep = "", header = FALSE)

##Reading Sets
testSet <- read.csv("X_test.txt", sep = "", header = FALSE)
trainSet <- read.csv("X_train.txt", sep = "", header = FALSE)
mergedSet <- rbind(testSet,trainSet)        

##Reading Movement
testMoves <- read.csv("Y_test.txt", sep = "", header = FALSE)
trainMoves <- read.csv("Y_train.txt", sep = "", header = FALSE)
mergedMoves <- rbind(testMoves, trainMoves)

##Reading PersonID
testPerson <- read.csv("subject_test.txt", sep = "", header = FALSE)
trainPerson <- read.csv("subject_train.txt", sep = "", header = FALSE)
mergedPerson <- rbind(testPerson, trainPerson)

##Extracting columns which includes measurements
names(mergedSet) <- features[ ,1]
mergedSet <- mergedSet[ grepl("std|mean", names(mergedSet), ignore.case = TRUE) ] 

#Descriptive ActivityName analysis
mergedMoves <- merge(mergedMoves, activities, by.x = "V1", by.y = "V1")[2]
mergedSet <- cbind(mergedPerson, mergedMoves, mergedSet)
names(mergedSet)[1:2] <- c("PersonID", "Activities")


##Tidying mergedSet
tidy<-group_by(mergedSet, PersonID, Activities) %>%
  summarise_each(funs(mean))
write.table(tidy,file="Assignment.txt",row.names=FALSE)
