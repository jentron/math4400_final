acf(dayOfWeekCounts$freq, lag.max = 21)

acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==2])
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==3])
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==4])
png(filename = "ACF_Wednesday.png", width = 9, height = 5, units = "in", res = 300)
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==5], main="Series Day of Week Counts")
dev.off()
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==6])


acf(diff(dayOfWeekCounts$freq), lag.max = 21)
acf(diff(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==2]))
acf(diff(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==3]))
acf(diff(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==4]))
acf(diff(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==5]))
acf(diff(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==6]))

summary(lm(freq~julianDay, data = dayOfWeekCounts,subset = dayOfWeekCounts$dayOfWeek==2))
summary(lm(freq~julianDay, data = dayOfWeekCounts,subset = dayOfWeekCounts$dayOfWeek==3))
summary(lm(freq~julianDay, data = dayOfWeekCounts,subset = dayOfWeekCounts$dayOfWeek==4))
summary(lm(freq~julianDay, data = dayOfWeekCounts,subset = dayOfWeekCounts$dayOfWeek==5))
summary(lm(freq~julianDay, data = dayOfWeekCounts,subset = dayOfWeekCounts$dayOfWeek==6))

boxplot(freq~dayOfWeek, data=dayOfWeekCounts)

png(filename = "CallVolumeDayOfWeek.png", width = 9, height = 5, units = "in", res = 300)
ggplot2::ggplot(data=dayOfWeekCounts, aes(factor(day.name[dayOfWeek], levels = day.name, ordered = TRUE), freq) )+ 
  geom_boxplot(outlier.colour="black", outlier.shape=16,
               outlier.size=1, notch=FALSE)+
  xlab("Day of Week") + ylab("Call Volume per Day")  + 
  theme(panel.background = element_rect(fill='#F3F1f1', colour='#a391b1'), axis.text.x = element_text(angle = 0))
dev.off()


ccc<-aov(freq~as.factor(dayOfWeek), data = dayOfWeekCounts)
TukeyHSD(ccc)
summary(ccc)

