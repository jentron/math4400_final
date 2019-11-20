# Load RODBC package
library(RODBC)

# Create a connection to the database called "channel"
channel <- odbcConnect("MATH_4400", uid="MATH4400", pwd=password)


callsperday <- sqlQuery(channel, "
  select trunc(contactstart) as calldate, count(*) as callvolume
  from calls
  group by trunc(contactstart)
  order by trunc(contactstart);")
odbcClose(channel)                        

plot(callsperday, type='l')

library(ggplot2)
ggplot(callsperday, aes(CALLDATE, CALLVOLUME))  + geom_line() + xlab("Date") + ylab("Call Volume") + labs(title = "Call Volume per Day") + theme(panel.background = element_rect(fill='#e3e1f1', colour='#a391b1'))
