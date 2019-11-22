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

training <- read_csv("training_fixed.csv", col_types = cols(X1 = col_integer(),
                      campaignId = col_character(), contactId = col_character(),
                      contactStart = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

training$sinceMidnights <- round(minute(training$contactStart)/60) *0.5 + hour(training$contactStart)
training$julianDay <- floor(as.numeric(julian(training$contactStart, origin = as.Date("2017-12-31"))) )
training$dayOfWeek <- wday(training$contactStart)

call_table <- table(training[,c("sinceMidnights", "julianDay")])
day_of_week_table <- table(training[,c("sinceMidnights", "dayOfWeek")])
boxplot(day_of_week_table)

## heatmap(call_table, Rowv=NA, Colv=NA)
## gplots::heatmap.2(call_table, Rowv=NA, Colv=NA, dendrogram = "none")


sqldf('SELECT campaignId, count() from training group by campaignId')

oldpar <- par(mfrow=c(2,2))
for(m in 5:8){
  hist(training$sinceMidnights[month(training$contactStart) == m], breaks = seq(-0.5, 24.5, 0.5),
     col="darkred", main = paste("Calls per 30 minutes for", month.name[m]), xlab = "Time", ylab="Number of calls")
}
par(oldpar)

oldpar <- par(mfrow=c(3,2))
for(m in 5:8){
  plot.text(month.name[m])
  for(w in 2:6){
    hist(training$sinceMidnights[(day(training$contactStart) == w) & (month(training$contactStart) == m)], breaks = seq(-0.5, 24.5, 0.5),
       col="darkred", main = paste("Calls per 30 minutes for", day.name[w]), xlab = "Time", ylab="Number of calls")
  }
}
par(mfrow=c(1,1))
hist(training$sinceMidnights, breaks = seq(-0.5, 24.5, 0.5),
     col="darkred", main = paste("Calls per 30 minutes"),  xlab = "Time", ylab="Number of calls")


mean(training$agentSeconds)
min(training$contactStart)
max(training$contactStart)
# plot(training$contactStart, training$agentSeconds, type="l")

# Trends. is the number of contacts increasing over time?
## Call volume is increasing by month
months.hist <- hist(month(training$contactStart), breaks = c(4.5:8.5), plot=FALSE) 
plot(months.hist, main="Call Volume by Month", xaxt = "n", xlab = "Month", col = "pink")
axis(1, months.hist$mids, labels = c("May", "Jun", "Jul", "Aug"), tick = FALSE, padj= -1.5)
months.lm <- lm(months.hist$counts~months.hist$mids+months.hist$mids)
abline(months.lm, col="blue")


#   
#  Weekly estimates
#

weeks.hist <- hist(week(training$contactStart), breaks = (min(week(training$contactStart))-.5):(max(week(training$contactStart)+.5)), plot=FALSE)

# lets cook up the holidays!
week_f.hist <- weeks.hist
mult <- (week_f.hist$mids == week("2018-07-04") | week_f.hist$mids == week("2018-05-28") ) *0.25 +1
week_f.hist$counts <- weeks.hist$counts *mult

df <- data.frame(week = week_f.hist$mids, callVolume=week_f.hist$counts)
newdata <- data.frame(week = 18:39, week2 = (18:39)^2)

weeks.lm <- lm(callVolume~week, data=df)
weeks.lm.pred <- predict(weeks.lm, newdata = newdata)
sqrt(mean( (df$callVolume - weeks.lm.pred[1:18])^2))

plot(week_f.hist, main="Call Volume by Week", xlab = "Week", col="lightblue")
abline(v=week("2018-07-04")) # Fourth of July
abline(v=week("2018-05-28")) # Memorial Day
abline(v=week("2018-09-03")) # Labor Day

abline(weeks.lm, col="red")
weeks.lm2 <- lm(callVolume~week+I(week^2), data=df)
weeks.lm2.pred <- predict(weeks.lm2, newdata = data.frame(week=18:35, week2=I((18:35)^2)))
sqrt(mean( (df$callVolume - weeks.lm2.pred[1:18])^2))


curve(weeks.lm2$coefficients[1] + weeks.lm2$coefficients[2]*x + weeks.lm2$coefficients[3]*x^2, col="Blue", add = TRUE)

# curve(-62346.94321657143882476 + 6073.29821388581331121 * x - 0.00806991973840725 *x^3  - 0.10303605707293267 *x^4   +  0.00000000022253336 * x^8 + 0.00000000001679082 *x^9, add= TRUE, col="dark green")
curve(lm.bstsub$coefficients[1] + lm.bstsub$coefficients[2]*x^3 + lm.bstsub$coefficients[3]*x^4 + lm.bstsub$coefficients[4]*x^5, col="dark green", add = TRUE)

## Call center only open M-F, more calls on Monday than Friday
wday.hist <- hist(wday(training$contactStart), breaks = c(0.5:7.5), plot=FALSE)
plot(wday.hist, xaxt="n", main="Call Volume by Day of Week", xlab = "Day of Week", xaxt="n", col="lightgreen")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= -1.5)

dayOfWeekCounts <- sqldf("select julianDay, dayOfWeek, count(*) as freq from training group by julianDay, dayOfWeek")
boxplot(freq~dayOfWeek, data = dayOfWeekCounts, xlab = "Day of Week", xaxt="n", ylab="Calls per Day")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= 0)

dayOfWeekMeanAgentSeconds <- sqldf("select julianDay, dayOfWeek, avg(agentSeconds) as meanAHT from training group by julianDay, dayOfWeek")
boxplot(meanAHT~dayOfWeek, data = dayOfWeekMeanAgentSeconds, xlab = "Day of Week", xaxt="n", ylab="Average Handling Time (Sec)")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= 0)


### PROPOSED: Draw 5 histograms for weeks by weekday 
### PROPOSED: We can fit a line to September based on WDAY
pred.dates <- seq(as.Date('2019-09-01'),as.Date('2019-09-30'),by = 1)
train.dates <- seq(min(training$contactStart),
                   max(training$contactStart), by=24*60*60)
hist(wday(pred.dates), breaks = c(0.5:7.5), main="Week Days in September 2019", xaxt="n")
axis(1, 1:7, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= -1.5)

train.wday.hist <- hist(wday(train.dates), breaks = c(0.5:7.5), plot=FALSE)
train.wday.hist$counts <- wday.hist$counts/train.wday.hist$counts
plot(train.wday.hist, xaxt="n", main="Mean Call Volume by Day of Week", xlab = "Day of Week", xaxt="n", col="lightgreen")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= -1.5)

# Predicted calls in September:
sum(hist(wday(pred.dates), breaks = c(0.5:7.5), plot=FALSE)$counts*train.wday.hist$counts)
    
sqldf("select contactStart from newTrain where contactStart < '2018-05-01 01:31:51'")
