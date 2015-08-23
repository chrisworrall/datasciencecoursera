activity.names <- read.table('./activity_labels.txt')[,2]
features <- read.csv('features.txt', sep = ' ', header = FALSE)[,2]

testx <- read.table('./test/X_test.txt')
trainx <- read.table('./train/X_train.txt')
bothx <- rbind(testx, trainx)
colnames(bothx) <- features

#filter to desired measurements, in ths case just sttdev and mean
meanstdcols <- grep('(-mean\\()|(-std\\()',features, value=TRUE)
filteredx <- bothx[meanstdcols]

# tidying a few column names, like fBodyBodyGyroMag-mean()
names(filteredx) <- gsub(pattern = 'BodyBody', replacement = 'Body', x = names(filteredx))
names(filteredx) <- gsub(pattern = '\\(\\)', replacement = '', x = names(filteredx))

testy <- read.table('./test/y_test.txt')
trainy <- read.table('./train/y_train.txt')
bothy <- rbind(testy, trainy)

# sub activity number for descriptive strings
activities <- data.frame(activity.names[bothy[[1]]])
colnames(activities) <- 'activity'

testsubjects <- read.table('./test/subject_test.txt')
trainsubjects <- read.table('./train/subject_train.txt')
bothsubjects <- rbind(testsubjects, trainsubjects)
colnames(bothsubjects) <- 'subject'

# assemble final dataset, mergedHAR
mergedHAR <- data.frame()
mergedHAR <- rbind(mergedHAR, bothsubjects)
mergedHAR <- cbind(mergedHAR, activities)
mergedHAR <- cbind(mergedHAR, filteredx)

# generate tidy dataset, averagesHAR, of averages per activity, per subject

mergedHAR %>%
  group_by(subject,activity) %>%
  summarise_each(funs(mean)) -> averagesHAR
