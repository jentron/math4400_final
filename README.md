Introduction:
In the call center industry, margins are razor thin. The need to manage costs necessitates accurate forecasting of incoming call volume and the time agents spend handling those calls so call center managers can make sure there are enough agents available to handle the expected call volume without having too many agents sitting idle. This project leverages four months of prior call center data to forecast the next month. Because the data does not span a year or more it is impossible to understand the seasonality effects on call volume. To be actionable, the forecast is broken down in 30 minute time intervals for each day.

Call volume is the number of calls received per unit of time. For this model, it is calls per half hour.
Handle time is the time a the agent spends on the call with the customer.
Call Volume x Handle time / 30 minutes = the number of agents required to staff the phones.

It appears Campaign Id is assigned whether or not a call is answered. Is it assigned by incoming phone number? Campaign 900856 appears to have stayed relatively constant over the period, while 900857 peaked around Memorial Day. Knowing something about these campaigns may improve forecastability.

The boxplots of call volume/day and call volume/hour are instructive. A plot of handling time with respect to call volume may also be interesting. The main plot will be a heatmap of calls per hour vs days

My model will estimate expected call volume by week with a simple, linear fit. This call volume will the be apportioned to each day based on the medians of the boxplot "call volume/day" and to each period based on the medians of the boxplot "call volume/hour."  As an alternative I will bootstrap sample from the training set for each week to get a representative distribution of calls and draw inference from that sample. Also looking into the Poisson distribution and autocorrelation and time series from Mastering Predictive Analytics with R. Packt Publishing. Kindle Edition.  978-1-78398-280-6 