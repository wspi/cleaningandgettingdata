subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="\n", strip.white=T)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="\n", strip.white=T)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", sep="\n", strip.white=T)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", sep="\n", strip.white=T)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep="\n", strip.white=T)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep="\n", strip.white=T)
x_train <- ldply(strsplit(gsub(" {2,}", " ", x_train$V1), " "))
x_test  <- ldply(strsplit(gsub(" {2,}", " ", x_test$V1), " "))

activity <- read.table("UCI HAR Dataset//activity_labels.txt", sep="\n", strip.white=T)
features <- read.table("UCI HAR Dataset/features.txt", sep="\n", strip.white=T)
features <- gsub("^[0-9]+ ", "", features$V1)
measurements <- grepl("mean|std", features)

train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)

tidy_data <- rbind(train, test)

tidy_data <- tidy_data[, c(TRUE, TRUE, measurements)]

headers <- c("activity", "subject", features[measurements])

colnames(tidy_data) <- headers


for (i in 3:ncol(tidy_data)){
    tidy_data[,i] <- as.numeric(tidy_data[,i])
}

means <- aggregate(tidy_data[,3] ~ tidy_data$subject + tidy_data$activity, data = tidy_data, FUN = mean)

for (i in 4:ncol(tidy_data)){
    means[,i] <- aggregate( tidy_data[,i] ~ tidy_data$subject + tidy_data$activity, data = tidy_data, FUN = mean )[,3]
}
colnames(means) <- headers

write.table(means, file="tidy.txt")
