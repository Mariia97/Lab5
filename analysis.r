# Download data
### Download data for analysis
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url, destfile=paste0(getwd(), "/UCI HAR Dataset.zip"), method = "curl") 
unzip("UCI HAR Dataset.zip", exdir = getwd())

# Read and convert data
### Read data file by file and merge into a single dataset
features <- read.csv('./UCI HAR Dataset/features.txt', header=FALSE, sep = ' ')
features <- as.character(features[,2])

x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
names(x_train) <- features
y_train<- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
names(y_train) <- c("Activity")
subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
names(subject_train)<-c("Subject")

train <- data.frame(subject_train,  y_train, x_train)


x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
names(x_test) <- features
y_test <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
names(y_test)<-c("Activity")
subject_test <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')
names(subject_test) <- c("Subject")

test <-  data.frame(subject_test, y_test, x_test)


# 1. Merge the Train and Test datasets

ds_all <-rbind(train, test)

# 2. Measurements of the mean and standard deviations for each measurement

mean_std <- grep('mean|std', features)
ds_sub <- ds_all[, c(1, 2, mean_std+2)]

# 3. Use descriptive activity names to rename activities in the dataset

activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity_labels <- as.character(activity_labels[,2])
ds_sub$Activity <- activity_labels[ds_sub$Activity]


# 4. Replace the names in the data set with the names from activity labels
name_new <- names(ds_sub)
name_new <- gsub("[(][)]", "", name_new)
name_new <- gsub("^t", "TimeDomain_", name_new)
name_new <- gsub("^f", "FrequencyDomain_", name_new)
name_new <- gsub("Acc", "Accelerometer", name_new)
name_new <- gsub("Gyro", "Gyroscope", name_new)
name_new <- gsub("Mag", "Magnitude", name_new)
name_new <- gsub("-mean-", "_Mean_", name_new)
name_new <- gsub("-std-", "_StandardDeviation_", name_new)
name_new <- gsub("-", "_", name_new)
names(ds_sub) <- name_new

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data_tidy <- aggregate(ds_sub[,3:81], by = list(activity = ds_sub$Activity, subject = ds_sub$Subject),FUN = mean)
write.table(x = data_tidy, file = "data_tidy.txt", row.names = FALSE)
