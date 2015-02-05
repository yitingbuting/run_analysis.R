library(reshape2)
# Load datasets
test.subject <- read.table("test/subject_test.txt")
test.x <- read.table("test/X_test.txt")
test.y <- read.table("test/y_test.txt")

train.subject <- read.table("train/subject_train.txt")
train.x <- read.table("train/X_train.txt")
train.y <- read.table("train/y_train.txt")

features <- read.table("features.txt")
activity.labels <- read.table("activity_labels.txt")

# Merges the training and the test sets to create one data set.
subject <- rbind(test.subject, train.subject)
colnames(subject) <- "subject"
label <- rbind(test.y, train.y)
label <- merge(label, activity.labels, by=1)[,2]
data <- rbind(test.x, train.x)
colnames(data) <- features[, 2]
data <- cbind(subject, label, data)

# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
search <- grep("-mean|-std", colnames(data))
data.mean.std <- data[,c(1,2,search)] 

# average of each variable for each activity and each subject.
melted = melt(data.mean.std, id.var = c("subject", "label"))
means = dcast(melted , subject + label ~ variable, mean)

# creates a second, independent tidy data set
write.table(means, file="tidy_data.txt",row.name=FALSE)