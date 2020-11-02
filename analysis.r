# Download data
### Download data for analysis
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url, destfile=paste0(getwd(), "/UCI HAR Dataset.zip"), method = "curl") 
unzip("UCI HAR Dataset.zip", exdir = getwd())

# Read and convert data
### Read data file by file and merge into a single dataset
features <- read.csv('./UCI HAR Dataset/features.txt', header=FALSE, sep = ' ')
features <- as.character(features[, 2])

x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

train <- data.frame(x_train, y_train, subject_train)
names(train) <- c(c('subject', 'activity'), features)
