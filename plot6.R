library("data.table")
library("ggplot2")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

# Load the NEI & SCC datasets.
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
filter <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[filter, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# data Subset the vehicles NEI data for Baltiomore city fip 
# set city name = Baltimore
baltimoreOnly <- vehiclesNEI[fips == "24510",]
baltimoreOnly[, city := c("Baltimore City")]

# data Subset the vehicles NEI data for LA city fip 
# set city name = LA
LAOnly <- vehiclesNEI[fips == "06037",]
LAOnly[, city := c("Los Angeles")]

# Combine Baltimore and LA data frames
LABaltimoreCombinedNEI <- rbind(baltimoreOnly,LAOnly)

png("plot6.png")

ggplot(LABaltimoreCombinedNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

dev.off()