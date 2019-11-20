## Forecast September’s call volume (number of calls) in 30 minute increments and 
## call volume: calculate y=total number of calls in 30 minutes for that day and time
## Create your own predictors. How will you use abandoned or in queue seconds or agent handle time
## Agent Seconds AHT (Average Handle Time – the average amount of time it takes an agent to handle the call). 
## two models
## Clearview Live call-center data
library(lubridate)
library(readr)
library(sqldf)

day.name <- c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");

training <- read_csv("training.csv", col_types = cols(X1 = col_integer(),
                     campaignId = col_character(), contactId = col_character(),
                    contactStart = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
training$Synthetic <- FALSE

# fix up the training data
max.training <- max(training$X1)
trn.indexes <- training$X1
all.indexes <- c(1:max.training)
missing.records <- setdiff(all.indexes, trn.indexes) ## Note: Order matters!

## where are the gaps?
n <- length(training$X1)
gaps.index <- c(1:n)[training$X1[1:n-1] + 1 < training$X1[2:n]]
gaps <- training$X1[gaps.index]

## View(missing.records)

newTrain <- training

print("This will take awhile ... ")
ng<- length(gaps.index)
# for(i in 1){ 
for( i in 1:ng) {
  if(! i %% 10) print(paste("Record",i,"of", ng));
  # starting and ending index, and count
  start <- training$X1[gaps.index[i]] 
  stop <- training$X1[gaps.index[i]+1]
  num  <- stop -start - 1
  
  startTime <- training$contactStart[gaps.index[i]]
  stopTime  <- training$contactStart[gaps.index[i]+1]
  
  # generate missing indices
  X1 <-  seq(from=start+1, length.out = num)
  # random uniform contactStart time in the interval
  contactStart <- 
    as_datetime(sort(runif(num, startTime, stopTime)))
  
  # all calls 30 minutes before and after the gap
  population.index <- 
    c(1:n)[training$contactStart < (stopTime + 1800) & training$contactStart > (startTime - 1800) ]
  
  # bootstrap sample the population
  sample.index <- sample(population.index, num, replace = TRUE)
  
  contactId  <- training$contactId[sample.index]
  campaignId <- training$campaignId[sample.index]
  abandoned  <- training$abandoned[sample.index]
  abandonseconds <- training$abandonseconds[sample.index]
  inQueueSeconds <- training$inQueueSeconds[sample.index]
  agentSeconds <- training$agentSeconds[sample.index]
  
  # Build a new tibble
  bob<-
    tibble::tibble(
      X1, campaignId, contactId, contactStart, abandoned, abandonseconds, inQueueSeconds, agentSeconds
    )
  bob$Synthetic <- TRUE # mark the synthetic records
  
  #Combine the new and old tibbles
  
  newTrain <- rbind(newTrain, bob)
}
options(scipen = 999)
write.table(newTrain[order(newTrain$X1),], file="training_fixed.csv", row.names = FALSE, dec = ".", sep = ",", quote = TRUE)


f <- parse_datetime("2016-01-01")
str(output_column(f))
