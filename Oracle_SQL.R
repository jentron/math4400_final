# Load RODBC package
library(RODBC)

# Create a connection to the database called "channel"
channel <- odbcConnect("MATH_4400", uid="MATH4400", pwd=password)

# Query the database and put the results into the data frame
# "dataframe"

dataframe <- sqlQuery(channel, "select to_char(contactstart, 'DDD') as callDate, campaignID, count(*) as count
from calls
group by to_char(contactstart, 'DDD'), campaignID
order by to_char(contactstart, 'DDD'), campaignID;
                      ")
bob<-as.matrix(spread(as_tibble(dataframe), value = COUNT, key = CAMPAIGNID,fill = 0))
gplots::heatmap.2(bob, Rowv=NA, Colv=NA, dendrogram = "none",
                  margins = c(4,4), # Adds margins below and to the right
                  lmat = rbind(c(2,4),c(3,1)), # 1=heatmap, 2=row dendogram, 3=col dendogram, 4= key
                  lwid = c(1,9), lhei = c(5, 15),
                  #     key.title = "Calls",
                  density.info = "none", # Remove density legend lines
                  trace = "none", # Remove the blue trace lines from heatmap
                  breaks=seq(0, 1000, length.out = 256),
                  col = viridis::viridis_pal(option = "B"), # Make colors viridis
                  #main = "Heat Map of Calls", 
                  ylab = "Hour of Day", xlab="Julian Day"
)
# When finished, it's a good idea to close the connection
odbcClose(channel)
