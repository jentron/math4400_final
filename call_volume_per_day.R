# Load RODBC package
library(RODBC)

setwd("~/Weber/MATH4400/stats_final/")
# Create a connection to the database called "channel"
channel <- odbcConnect("MATH_4400", uid="MATH4400", pwd=password)


callsperday <- sqlQuery(channel, "
  select trunc(contactstart) as calldate, count(*) as callvolume
  from calls
  group by trunc(contactstart)
  order by trunc(contactstart);")
odbcClose(channel)                        


library(lubridate)
callsperday$WDAY <- as.factor(wday(callsperday$CALLDATE))
pred.weekday <- predict(ccc, newdata = callsperday$CALLDATE)
callsperday$PRED <- pred.weekday[callsperday$WDAY]
  

ggplot(test_data, aes(date)) + 
  geom_line(aes(y = var0, colour = "var0")) + 
  geom_line(aes(y = var1, colour = "var1"))

library(ggplot2)
png(filename = "CallVolumePerDay.png", width = 9, height = 5, units = "in", res = 300)
ggplot(callsperday, aes(CALLDATE))  + 
  geom_line(aes(y = PRED), colour = "red") +
  geom_line(aes(y = CALLVOLUME), colour = "black") +
  xlab("Date") + ylab("Call Volume")  + theme(panel.background = element_rect(fill='#F3F1f1', colour='#a391b1'))
dev.off()

sqrt(with(callsperday, sum((CALLVOLUME-PRED)^2) ))
     