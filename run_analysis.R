#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("C:/R/Homework")

#read in features and extract only the mean and standard deviation
features<- read.table("./features.txt",header=FALSE)[,2]
features_mean_std <- grepl("mean|std", features)

#read in all the other files
xTrain<- read.table("./X_train.txt", header=FALSE)
yTrain<- read.table("./y_train.txt", header=FALSE)

subject_Train<-read.table("./subject_train.txt", header=FALSE)

activity_Label<- read.table("./activity_labels.txt",header=FALSE)

#subset XTrain_data with only mean&std rows
xTrain_data<-xTrain[,features_mean_std]

#add in the activity column names
colnames(yTrain) = "Activity_ID"
colnames(activity_Label)<-c("Activity_ID","Activity")
yTrain_data<-merge(yTrain,activity_Label,by="Activity_ID")

train_data<-cbind(subject_Train,xTrain_data,yTrain_data)

xTest<- read.table("./X_test.txt", header=FALSE)
yTest<- read.table("./Y_test.txt", header=FALSE)
subject_Test<-read.table("./subject_test.txt", header=FALSE)

xTest_data<-xTest[,features_mean_std]
colnames(yTest) = "Activity_ID"
yTest_data<-merge(yTest,activity_Label,by="Activity_ID")

test_data<-cbind(subject_Test,xTest_data,yTest_data)

final_data<-rbind(test_data,train_data)

install.packages("dplyr")

library(dplyr)

#get the names from features with mean&std
names_features<-cbind(data.frame(features),features_mean_std)
names_features_true<-subset(names_features,features_mean_std==TRUE)[1]
colnames(names_features_true) <- NULL

#change the column names in final data to match features
colnames(final_data)[2:(ncol(final_data)-2)]<-(names_features_true)

#output data
write.table(final_data, row.name=FALSE, file = "final_data.txt")
