# Load RODBC package
library(RODBC)

setwd("~/Weber/MATH4400/stats_final/")
# Create a connection to the database called "channel"
channel <- odbcConnect("MATH_4400", uid="MATH4400", pwd=password)


callsperhalfhour <- sqlQuery(channel, "
select timerounded, round((timerounded-TRUNC(timerounded))*24, 1) as hour, avg(inqueueseconds), avg(abandonseconds), avg(abandoned), count(campaignID), count(x1) CallVolume, AVG(NULLIF(agentseconds,0)) as AHT
from calls
where (synthetic = 'FALSE' or synthetic = 'TRUE' ) 
group by timerounded
order by timerounded;")

odbcClose(channel)   

callsperhalfhour$HOUR_f <- as.factor(callsperhalfhour$HOUR)
callsperhalfhour$WDAY <- wday(callsperhalfhour$TIMEROUNDED)

## For holidays, mark the day as a Sunday and the following day as a Monday
# Fourth of July
callsperhalfhour$WDAY[date(callsperhalfhour$TIMEROUNDED) == date("2018-07-04")] = 1
callsperhalfhour$WDAY[date(callsperhalfhour$TIMEROUNDED) == date("2018-07-05")] = 2

# Memorial Day
callsperhalfhour$WDAY[date(callsperhalfhour$TIMEROUNDED) == date("2018-05-28")] = 1
callsperhalfhour$WDAY[date(callsperhalfhour$TIMEROUNDED) == date("2018-05-29")] = 2

# Labor Day
callsperhalfhour$WDAY[date(callsperhalfhour$TIMEROUNDED) == date("2018-09-03")] = 1
callsperhalfhour$WDAY[date(callsperhalfhour$TIMEROUNDED) == date("2018-09-04")] = 2


## View(callsperhalfhour)
for( w in 1:7){
  boxplot( CALLVOLUME~HOUR_f,data=callsperhalfhour, subset = callsperhalfhour$WDAY == w, main=day.name[w])
}

library(ggplot2)
png(filename = "CallVolumePerHour.png", width = 9, height = 5, units = "in", res = 300)
ggplot2::ggplot(data=subset(callsperhalfhour, subset = callsperhalfhour$WDAY == 3), aes(HOUR_f, CALLVOLUME) )+ 
  geom_boxplot(outlier.colour="black", outlier.shape=16,
               outlier.size=2, notch=FALSE)+
  xlab("Hour") + ylab("Call Volume")  + 
  theme(panel.background = element_rect(fill='#F3F1f1', colour='#a391b1'), axis.text.x = element_text(angle = 90))
dev.off()

for( w in 2:6){
  boxplot( AHT~HOUR_f,data=callsperhalfhour, 
           subset = ((callsperhalfhour$WDAY == w)&(callsperhalfhour$WDAY == w)) , main=day.name[w], ylab="AHT (seconds)", xlab="Hour (24 hour clock)")
}

png(filename = "AHTPerHour_all.png", width = 9, height = 5, units = "in", res = 300)
boxplot( AHT~HOUR_f,data=callsperhalfhour, 
         subset = (callsperhalfhour$WDAY %in% c(2:6)) , ylab="AHT (seconds)", xlab="Hour (24 hour clock)")
dev.off()

png(filename = "AHTPerHour_business.png", width = 9, height = 5, units = "in", res = 300)
boxplot( AHT~HOUR_f,data=callsperhalfhour, 
         subset = (callsperhalfhour$WDAY %in% c(2:6))&(callsperhalfhour$HOUR %in% seq(7, 17, 0.5)) , ylab="AHT (seconds)", xlab="Hour (24 hour clock)")
dev.off()


aht.pred <- median(callsperhalfhour$AHT, na.rm=TRUE)
png(filename = "AHT_hist.png", width = 9, height = 5, units = "in", res = 300)
hist(callsperhalfhour$AHT, breaks = c(seq(0,1200, 20), max(callsperhalfhour$AHT, na.rm = TRUE)), xlim = c(0,1200), main="", xlab = "Handle Time (seconds)")
abline(v=aht.pred, col="purple")
dev.off()

aht.pred.func <- function(volume)
{
  return(ifelse(ifelse(is.na(volume), 0, volume) >100, aht.pred, 0))
}



callsperhalfhour$AHTpred <- aht.pred.func(callsperhalfhour$CALLVOLUME)



mean( (callsperhalfhour$AHT[callsperhalfhour$CALLVOLUME>100]-642.3711)^2, na.rm=TRUE )


mean( (callsperhalfhour$AHT-aht.pred.func(callsperhalfhour$CALLVOLUME))^2, na.rm=TRUE )

workhours <- hour(callsperhalfhour$TIMEROUNDED) < 19 & hour(callsperhalfhour$TIMEROUNDED) > 6 & !is.na(callsperhalfhour$AHT) & !callsperhalfhour$WDAY == 1 & !callsperhalfhour$WDAY == 7

mean((callsperhalfhour$AHT[workhours] - callsperhalfhour$AHTpred[workhours])^2, na.rm=TRUE)
