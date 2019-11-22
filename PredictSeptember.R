library(lubridate)
predictions <- myPredict(seq(ymd_hms('2018-09-01 00:00:00'),ymd_hms('2018-09-30 23:30:00'), by = 30*60))

ttrial <- matrix(round(predictions$CV), nrow = 48, byrow = FALSE)
colnames(ttrial) <- format(unique(lubridate::date(predictions$Date)), "%b %d")
rownames(ttrial) <- as.character(seq(0,23.5,0.5))
ttrial.table <- as.table(ttrial)

png(filename = "myheatmap_prediction.png", width = 7, height = 5, units = "in", res = 300)
gplots::heatmap.2(ttrial.table, Rowv=NA, Colv=NA, dendrogram = "none",
                  margins = c(4,4), # Adds margins below and to the right
                  lmat = rbind(c(2,4),c(3,1)), # 1=heatmap, 2=row dendogram, 3=col dendogram, 4= key
                  lwid = c(1,9), lhei = c(5, 15),
                  #     key.title = "Calls",
                  density.info = "none", # Remove density legend lines
                  trace = "none", # Remove the blue trace lines from heatmap
                  breaks=seq(0, 532*1.1, length.out = 256),
                  col = viridis::viridis_pal(option = "B"), # Make colors viridis
                  #main = "Heat Map of Calls", 
                  ylab = "Hour of Day", xlab=""
)
dev.off()


##boxplot(AHT~factor(day.name[weekday], levels=day.name, ordered=TRUE), data=predictions)
png(filename = "aht_prediction.png", width = 9, height = 5, units = "in", res = 300)
boxplot(AHT~factor(period/2), data = predictions, subset = weekday %in% c(2:6), xlab='hour')        
dev.off()


library(readr)
answers_volume <- read_csv("answers_volume-1.csv",
                           col_types = cols(date = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
answers_volume$calls <- myPredict(answers_volume$date)$CV

library(readr)
answers_aht <- read_csv("answers_handletime-1.csv",
                           col_types = cols(date = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
answers_aht$handletime <- myPredict(answers_aht$date)$AHT
