acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==2])
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==3])
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==4])
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==5])
acf(dayOfWeekCounts$freq[dayOfWeekCounts$dayOfWeek==6])
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


ccc<-aov(freq~as.factor(dayOfWeek), data = dayOfWeekCounts)
TukeyHSD(ccc)
summary(ccc)

