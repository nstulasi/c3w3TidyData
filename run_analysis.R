library(reshape)
library(reshape2)
#Assuming you also have the ZIP file extracted to your working directory
#Download and open the zip file
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
activities<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./data_week3/UCI HAR Dataset/features.txt")
#update names of x_train with features
colnames(x_train)<-features$V2
#update names of x_test with features
colnames(x_test)<-features$V2
#merge activities and y_train to train_activities
#name column
colnames(y_train)<-"activity_id"
colnames(activities)<-c("activity_id","activity")
activities_train<-merge(y_train,activities,all.x=TRUE)
#merge activities and y_test to train_activities
#name column
colnames(y_test)<-"activity_id"
activities_test<-merge(y_test,activities,all.x=TRUE)

#Extract only eligible features/variable i.e. mean and std
eligible_features<-features[grepl('-mean\\(|-std\\(',features$V2),]
x_train<-x_train[,eligible_features$V2]
x_test<-x_test[,eligible_features$V2]

#cbind train_activities and x_train
x_train<-cbind(x_train,activity=activities_train$activity)
#cbind test_activities to x_test
x_test<-cbind(x_test,activity=activities_test$activity)
#cbind train_activities and x_train
x_train<-cbind(x_train,subject=subject_train$V1)
#cbind test_activities to x_test
x_test<-cbind(x_test,subject=subject_test$V1)



#Merged the two test and train datasets
tidy_data<-rbind(x_train,x_test)
# Average of each variable by subject and activity
tidy_data<-data.table(tidy_data)
tidy_data<-tidy_data[, lapply(.SD,mean), by=c("activity","subject")]
write.table(tidy_data2, file="./tidydata.txt", sep="\t", row.names=FALSE)
