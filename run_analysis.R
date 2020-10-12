#Creating the Script
#Downloading the file and putting to the folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#Unzip and getting the list of files
unzip(zipfile="./data/Dataset.zip",exdir="./data")
pathRef <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(pathRef, recursive=TRUE)
files

#Read data from files into variables
activityTest  <- read.table(file.path(pathRef, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(pathRef, "train", "Y_train.txt"),header = FALSE)
subjectTrain <- read.table(file.path(pathRef, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(pathRef, "test" , "subject_test.txt"),header = FALSE)
featuresTest  <- read.table(file.path(pathRef, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(pathRef, "train", "X_train.txt"),header = FALSE)

#Checking properties
str(activityTest)
str(activityTrain)
str(subjectTrain)
str(subjectTest)
str(featuresTest)
str(featuresTrain)

#Concatenate the data tables by rows
dataSubject <- rbind(subjectTrain, subjectTest)
dataActivity<- rbind(activityTrain, activityTest)
dataFeatures<- rbind(featuresTrain, featuresTest)

#set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
featuresNames <- read.table(file.path(pathRef, "features.txt"),head=FALSE)
names(dataFeatures)<- featuresNames$V2

#Merge columns
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)


#Subset Name of Features by measurements on the mean and standard deviation
subsetFeaturesNames<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]

#Subset the data frame Data by selected names of Features
selectedNames<-c(as.character(subsetFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Check the structures of the data frame Data
str(Data)

#Appropriately labels the data set with descriptive variable names
#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("gravity", "Gravity", names(Data))
names(Data)<-gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)

#Check
names(Data)


#Creating the tidy dataset
library(dplyr)
TidyData <- Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(TidyData, "TidyData.txt", row.name=FALSE)

#Checking variable names
str(TidyData)



