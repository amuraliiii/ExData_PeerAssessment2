library("data.table")
library("ggplot2")


path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

# Load the NEI & SCC datasets.
NEI <- data.table::as.data.table(x = readRDS("summarySCC_PM25.rds"))
SCC <- data.table::as.data.table(x = readRDS("Source_Classification_Code.rds"))



# # data Subset of the NEI data which corresponds to vehicles
filter <- grepl("vehicle", SCC[,SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[filter,SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data for Baltimore's fip
baltimoreOnly <- vehiclesNEI[fips=="24510",]

png("plot5.png")

ggplot(baltimoreOnly,aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill ="#6A0DAD") +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.off()





