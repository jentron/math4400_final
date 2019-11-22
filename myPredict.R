## Build ccc
## training data needs to be loaded with hackathon.R and processed with fix_data.R
library(sqldf)
dayOfWeekCounts <- sqldf("select julianDay, dayOfWeek, count(*) as freq from training group by julianDay, dayOfWeek")
ccc<-aov(freq~as.factor(dayOfWeek), data = dayOfWeekCounts)

## Build callsperhalfhour
## see call_volume_per_hour.R

## Build dayOfWeekMeanAgentSeconds
## see hackathon.R


dayCoeff <- predict(ccc, newdata=as.factor(1:7))
## c(40.94118, 10868.52941,  9552.38889,  7981.61111,  8370.88889,  8398.27778, 91.88235 ) ## from anova
hourCoeff <- boxplot( CALLVOLUME~HOUR_f,data=callsperhalfhour, subset = (callsperhalfhour$WDAY %in% c(2:6)), plot=FALSE)$stats[3,]

for( i in which(is.na(hourCoeff))){
  if( i == 1) {
    hourCoeff[1] <- 0
    next;
  }
  if( i == 48) {
    hourCoeff[48] <- 0
    next;
  }
  hourCoeff[i] <- hourCoeff[i-1]
}

hourCoeff <- hourCoeff/sum(hourCoeff) # normalize

# grab the medians from a boxplot
ahtCoeff  <- boxplot( AHT~HOUR_f,data=callsperhalfhour, subset = (callsperhalfhour$WDAY %in% c(2:6)), plot=FALSE)$stats[3,]
ahtCoeff[is.na(ahtCoeff)] <- median(ahtCoeff, na.rm=TRUE)
ahtCoeff <- ahtCoeff/mean(ahtCoeff) # normalize

ahtDayValues <-boxplot(meanAHT~dayOfWeek, data = dayOfWeekMeanAgentSeconds, plot=FALSE)$stats[3,]



testString <- c("2018-11-16 05:17:00",
                "2018-11-17 23:17:00",
                "2018-11-18 23:37:00",
                "2018-11-19 00:37:00",
                "2018-11-20 00:07:00",
                "2018-11-21 00:07:00",
                "2018-11-22 12:07:00",
                "2018-07-04 07:02:23",
                "2018-07-05 17:02:23",
                "2018-05-28 07:52:23",
                "2018-05-29 07:02:23",
                "2018-09-03 07:02:23",
                "2018-09-04 07:02:23")

myPredict <- function(date) {
  w <- lubridate::wday(date)
  ## Holidays are "Sunday" and the following day is "Monday"
  w[lubridate::date(date) == "2018-07-04"] <- 1 # Fourth of July
  w[lubridate::date(date) == "2018-07-05"] <- 2 # Fourth of July
  w[lubridate::date(date) == "2018-05-28"] <- 1 # Memorial Day
  w[lubridate::date(date) == "2018-05-29"] <- 2 # Memorial Day
  w[lubridate::date(date) == "2018-09-03"] <- 1 # Labor Day
  w[lubridate::date(date) == "2018-09-04"] <- 2 # Labor Day
  h <- lubridate::hour(date)
  m <- lubridate::minute(date)
  m <- ifelse(m<30, 0, 0.5)
  h <- (h+m)*2+1
  cv <- round(dayCoeff[w]*hourCoeff[h])
  aht <- ahtCoeff[h]*ahtDayValues[w]
  return(data.frame(Date=date, CV=cv, AHT=aht, weekday=w, period=h))
}

