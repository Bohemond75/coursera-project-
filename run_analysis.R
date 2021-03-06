#
# 
# COURSERA FINAL PROJECT
# 'GETTING AND CLEANING DATA'
# Boh�mond Flamand
#


########################################################


#If you want the loads to work correctly, change the following line with the path of the directory where you 
#extracted the zip 
setwd('C:/Users/Boh�mond Flamand/Documents/FIB/first semester/Coursera/project/UCI HAR Dataset/');


#
# The first thing to do is to load the datasets, the train and the test one
#

#train
accelero.Xtrain <- read.table("train/X_train.txt")
accelero.Ytrain <- read.table("train/Y_train.txt")
subject.train <- read.table("train/subject_train.txt")

#test
accelero.Xtest <- read.table("test/X_test.txt")
accelero.Ytest <- read.table("test/Y_test.txt")
subject.test <- read.table("test/subject_test.txt")


#
# Now we want to get the activity labels and the features of our datasets
#

activity.labels <- read.table("activity_labels.txt")
#I don't know why, but the names of the activity labels were integer, so I needed to transform them in characters
#otherwise for the next part it created an error
activity.labels[,2] <- as.character(activity.labels[,2])
features <- read.table("features.txt")
#same problem with the names of the features
features[,2] <- as.character(features[,2])

# Now we have to "Extract only the measurements on the mean and standard deviation for each measurement."
mean.std <- grep(".*mean.*|.*std.*", features[,2])
mean.std.features <- features[mean.std,2] #names of the features

#we only take what is interesting for us, being the mean and the standard deviation 
accelero.Xtrain <- read.table("train/X_train.txt")[mean.std]
accelero.Xtest <- read.table("test/X_test.txt")[mean.std]

#with the two next lines we create two datasets data.train and data.test which contain 
#for each row the subject tested, the variable Y, and all the measurements we are interested in
data.train <- cbind(subject.train, accelero.Ytrain, accelero.Xtrain)
data.test <- cbind(subject.test, accelero.Ytest, accelero.Xtest)


#
# As ordered, we have to merge the datasets to make one final dataset. 
#
final.dataset <- rbind(data.train, data.test)
colnames(final.dataset) <- c("subject", "label_activity", mean.std.features) #we name the two first columns so that every column has a name

#
# For the moment activites and subjects are just numbers and it is not really relevant because they're not measures,
# they are conditions of experience and should be transformed to factors with their associated names
#

final.dataset$subject <- as.factor(final.dataset$subject)
final.dataset$label_activity <- factor(final.dataset$label_activity, levels = activity.labels[,1], labels = activity.labels[,2])

#
# From the data set in step 4, I create a second, independent tidy data set with the average of each variable for each activity 
# and each subject.
#

library(reshape2)
final.dataset <- melt(final.dataset, id = c("subject", "label_activity"))  
final.dataset <- dcast(final.dataset, subject + label_activity ~ variable, mean) #average of each variable
write.table(final.dataset, "C:/Users/Boh�mond Flamand/Documents/FIB/first semester/Coursera/project/UCI HAR Dataset/tidy.txt", row.names = FALSE, quote = FALSE)


test.tidy.data <- read.table("C:/Users/Boh�mond Flamand/Documents/FIB/first semester/Coursera/project/UCI HAR Dataset/tidy.txt")
