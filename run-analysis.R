# Step 0: load package
library(dplyr)

# Step 1: read data
## Read label
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "function"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

## Train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$function.)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$function.)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

## Merge data
train_dataset <- cbind(subject_train, y_train, x_train)
test_dataset <- cbind(subject_test, y_test, x_test)
merged_dataset <- rbind(train_dataset, test_dataset)

# Step 2: extract mean and SD
tidy_dataset <- merged_dataset %>% select(subject, code, contains("mean"), contains("std"))

# Step 3: change to activity names
tidy_dataset$code <- activity[tidy_dataset$code, 2]

# Step 4: label data
head(tidy_dataset)
names(tidy_dataset)[2] = "activity"
names(tidy_dataset) <- gsub("Acc", "Accelerometer", names(tidy_dataset))
names(tidy_dataset) <- gsub("Gyro", "Gyroscope", names(tidy_dataset))
names(tidy_dataset) <- gsub("Mag", "Magnitude", names(tidy_dataset))
names(tidy_dataset) <- gsub("BodyBody", "Body", names(tidy_dataset))

names(tidy_dataset) <- gsub("^t", "Time", names(tidy_dataset))
names(tidy_dataset) <- gsub("^f", "Frequency", names(tidy_dataset))

names(tidy_dataset) <- gsub("-mean()", "Mean", names(tidy_dataset), ignore.case = TRUE)
names(tidy_dataset) <- gsub("-std()", "StandardDeviation", names(tidy_dataset), ignore.case = TRUE)

# Step 5: calculate average
average_dataset <- tidy_dataset %>%
  group_by(activity, subject) %>%
  summarise(across(everything(), mean))

write.table(average_dataset, "average_dataset.txt", row.names = FALSE)
write.csv(tidy_dataset, file = "TIDY_DATA.csv", row.names = FALSE)
