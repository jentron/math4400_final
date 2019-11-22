setwd("~/Weber/MATH4400/stats_final/")
setEPS()
postscript("whatever.eps")
plot(rnorm(100), main="Hey Some Data")
dev.off()

cairo_ps("image.eps")
plot(1, 10)
dev.off()

postscript("foo.eps", horizontal = FALSE, onefile = FALSE, paper = "special", height = 10, width = 10, colormodel="rgb")
plot(rnorm(100), main="Hey Some Data")
dev.off()


View(mtcars)

df <- scale(mtcars)
heatmap(df, scale = "none")

# half hour and day
png(filename = "myheatmap_full.png", width = 9, height = 5, units = "in", res = 300)
gplots::heatmap.2(call_table, Rowv=NA, Colv=NA, dendrogram = "none",
          margins = c(4,4), # Adds margins below and to the right
          lmat = rbind(c(2,4),c(3,1)), # 1=heatmap, 2=row dendogram, 3=col dendogram, 4= key
          lwid = c(1,9), lhei = c(5, 15),
     #     key.title = "Calls",
          density.info = "none", # Remove density legend lines
          trace = "none", # Remove the blue trace lines from heatmap
          breaks=seq(0, max(call_table[,3])*1.1, length.out = 256),
          col = viridis::viridis_pal(option = "B"), # Make colors viridis
#main = "Heat Map of Calls", 
          ylab = "Hour of Day", xlab="Julian Day"
          )
dev.off()

png(filename = "histogram_time.png", width = 12, height = 8, units = "in", res = 300)
hist(training$sinceMidnights, breaks = seq(-0.5, 24.5, 0.5),
     col="darkred", main = paste("Calls per 30 minutes"),  xlab = "Time", ylab="Number of calls")
dev.off()

png(filename = "histogram_weeks.png", width = 9, height = 5, units = "in", res = 300)
plot(weeks.hist, main="Call Volume by Week", xlab = "Week", col="lightblue")
abline(weeks.lm, col="red")
dev.off()

png(filename = "histogram_volume_by_day_of_week.png", width = 9, height = 5, units = "in", res = 300)
plot(train.wday.hist, xaxt="n", main="Mean Call Volume by Day of Week", xlab = "Day of Week", xaxt="n", col="lightgreen")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= -1.5)
dev.off()

png(filename = "boxplot_volume_by_day_of_week.png", width = 9, height = 5, units = "in", res = 300)
boxplot(freq~dayOfWeek, data = dayOfWeekCounts, xlab = "Day of Week", xaxt="n", ylab="Calls per Day")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= 0)
dev.off()

png(filename = "boxplot_AHT_by_day_of_week.png", width = 9, height = 5, units = "in", res = 300)
boxplot(meanAHT~dayOfWeek, data = dayOfWeekMeanAgentSeconds, xlab = "Day of Week", xaxt="n", ylab="Average Handling Time (Sec)")
axis(1, wday.hist$mids, labels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"), tick = FALSE, padj= 0)
dev.off()
