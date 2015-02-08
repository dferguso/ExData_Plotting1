rm(list=ls())
## memory estimation assuming all 9 columns are numeric
## this estimate is not very accurate based on results from object.size()
fLines = 2075259 ## Number of rows
fCol = 9 ## Number of columns
ByteSize = 8 ## 8bytes /numeric
bYtesperMB = 1024*1024 ## byts per MegaByte
memSize = fLines*fCol*ByteSize/bYtesperMB
cat("Memory size required = ", memSize, "MB")


## Read in the first few lines of the table to determine the 
## classes for each column
library(sqldf)  ## Need this for read.csv.sql used below
tabROws <- read.table("data/household_power_consumption.txt", header = TRUE, sep=";"
                      , nrow=5) ## pull in a small number of rows to check the variable class  
classes <-sapply(tabROws, class) ## Variables defining the class for each column 

## read subset of 
tabAll<-read.csv.sql("data/household_power_consumption.txt", header=TRUE, sep=";", colClasses=classes,
                     sql="Select * from file where Date = '1/2/2007' OR Date = '2/2/2007'")
closeAllConnections()

tabAll[as.character(tabAll)=="?"]<-NA

dt=paste(tabAll$Date, tabAll$Time)
dateTime <- strptime(dt, format="%d/%m/%Y %H:%M:%S")
pData<-cbind(dateTime, tabAll)
rm(tabROws, tabAll, classes)


## Plot 3
plot(pData$dateTime, pData$Sub_metering_1, type="l",
     xlab="", ylab="Energy sub metering",
     col="black")
lines(pData$dateTime, pData$Sub_metering_2, type="l",
     xlab="", ylab="",
     col="red")
lines(pData$dateTime, pData$Sub_metering_3, type="l",
      xlab="", ylab="",
      col="blue")
#legend("pData$dateTime[2000], 38,
legend("topright", inset=0.1,
       lty = 1, col=c("black", "red", "blue"), 
       bty = "n",
       cex = 0.75,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, filename = "Plot3.png",
         width = 480, height = 480, units = "px", pointsize = 12)
dev.off()
dev.off()