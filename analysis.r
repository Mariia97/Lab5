# Download data
### Download data for analysis
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url, destfile=paste0(getwd(), "/UCI HAR Dataset.zip"), method = "curl") 
unzip("UCI HAR Dataset.zip", exdir = getwd())

# Read and convert data
## Read data file by file and merge into a single dataset
features <- read.csv('./UCI HAR Dataset/features.txt', header=FALSE, sep = ' ')
features <- as.character(features[, 2])

### Train dataset
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

train <- data.frame(x_train, y_train, subject_train)
names(train) <- c(c('subject', 'activity'), features)

### Test dataset
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
subject_test <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

test <-  data.frame(x_test, y_test, subject_test)
names(test) <- c(c('subject', 'activity'), features)


# 1. Merge the Train and Test datasets

ds_all <-rbind(train, test)

# 2. Measurements of the mean and standard deviations for each measurement

mean_std <- grep('mean|std', features)
ds_sup <- ds_all[, c(1, 2, mean_std +2)]

# 3. Use descriptive activity names to rename activities in the dataset

activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

train_labels <- merge(activity_labels, train_labels,by=c("V1"))
test_labels <- merge(activity_labels, test_labels,by=c("V1"))

labels <-rbind(train_labels, test_labels)
labels$Activity <-labels$V2

ds_labels <-cbind(labels, ds_sub)
