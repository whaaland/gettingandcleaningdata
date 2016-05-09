##########################################
## Getting and Cleaning Data class project
##########################################

setwd("C://Users//whaala//Documents//Coursera Data Science//Getting and Cleaning Data")


#Load labels, columns names
actlab<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//activity_labels.txt", header=FALSE)

cn<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//features.txt", header=FALSE)

subjtrain<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//subject_train.txt", 
                      header=FALSE)


#Read in test-related datasets and combine
subjtest<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//test//subject_test.txt", 
                     header=FALSE, col.names="ID")

xtest<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//test//X_test.txt", 
                  header=FALSE, col.names=cn$V2)

ytest<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//test//y_test.txt", 
                  header=FALSE, col.names="Activity")

combtest<-cbind(subjtest, xtest, ytest)


#Read in train-related datasets and combine
subjtrain<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//subject_train.txt", 
                     header=FALSE, col.names="ID")

xtrain<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//X_train.txt", 
                  header=FALSE, col.names=cn$V2)

ytrain<-read.table(".//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//y_train.txt", 
                  header=FALSE, col.names="Activity")

combtrain<-cbind(subjtrain, xtrain, ytrain)

#Append test and train datasets
combined<-rbind(combtest, combtrain)

#extract mean and standard deviation variables
combined_trimmed<-select(combined,contains("ID"), contains("Activity"),contains("mean"), contains("std"))

#label the activity data
combined_trimmed$Activity<-factor(combined_trimmed$Activity,levels=actlab[,1], labels=actlab[,2])

#improve names - remove extraneous parentheses
names(combined_trimmed)<-gsub("()-","",names(combined_trimmed))


#create tidy dataset with mean of variable by activity and each subject
tidyData<-combined_trimmed %>%group_by(Activity,ID)%>%summarise_each(funs(mean))

#export dataset
write.table(tidyData, file="tidyData.txt", row.names=FALSE )




