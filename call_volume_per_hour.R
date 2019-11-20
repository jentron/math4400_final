# Load RODBC package
library(RODBC)

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


for( w in 2:6){
  boxplot( AHT~HOUR_f,data=callsperhalfhour, 
           subset = ((callsperhalfhour$WDAY == w)&(callsperhalfhour$WDAY == w)) , main=day.name[w])
}
