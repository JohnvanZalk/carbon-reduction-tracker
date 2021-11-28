#Load rgdal for importing and exporting geospatial data
library(rgdal)

#Make sure GeoJSON is in ogrDrivers list
"GeoJSON" %in% ogrDrivers()$name

#Read GeoJSON in as spatial dataframe (spdf)
url <- "https://opendata.arcgis.com/datasets/c4fd0b01c2544a2f83440dab292f0980_0.geojson"
file <- "utility_territories.geojson"
download.file(url, file)
utility_territories <- readOGR(dsn = "utility_territories.geojson", layer = "utility_territories")

#Create an extra spdf so if a mistake is made, we don't have to reload
spdf_extra<-utility_territories

#Load csv of mapped Salesforce ids
sf_data<- read.csv("/home/rstudio/Carbon_Reduction_Tracker/GitHub/Data/Utility_Salesforce_Mapping.csv", header= T)

#Merge territories with Salesforce ids, keeping all ~2900 polygons
utility_territories <-merge(x = utility_territories, y = sf_data, by = "ID", all.x= TRUE)

#Now remove utilites that have no match in Salesforce or are Canadian
utility_territories <-utility_territories[!is.na(utility_territories@data$Account.Name), ]
utility_territories <-utility_territories[utility_territories@data$COUNTRY!="CAN", ]

#Remove unwanted columns
utility_territories <-utility_territories[-c(2,4:36)]

#Create a seperate dataframe of all utilties that have a parent company
territories_w_parent <-utility_territories[utility_territories@data$Parent.Name!="", ]

#Merge polygons by parents
#If a parent has a goal, we want all of it's child utilties to show up on the map
parent_territories <- aggregate(territories_w_parent,
                                by = list(territories_w_parent@data$Parent.Name),
                                FUN=head, 1)

#Combine parent territories with single teritories
#Reformat columns to match
parent_territories <- parent_territories[c(6,7)]
names(parent_territories@data) <- c("ID", "Name")

utility_territories <- utility_territories[c(3,4)]
names(utility_territories@data) <- c("ID", "Name")

utility_territories<-rbind(utility_territories,parent_territories, makeUniqueIDs = TRUE)

#Save
writeOGR(utility_territories, dsn="/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles", layer="Utility_Shapefiles", driver="ESRI Shapefile")

