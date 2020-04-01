#!/usr/bin/Rscript

#Load required packages
library(leaflet)
library(rgdal)
library(rgeos)
library(sf)
library(rdrop2)
library(maptools)

## Load GeoJSON
"GeoJSON" %in% ogrDrivers()$name

url <- "https://opendata.arcgis.com/datasets/c4fd0b01c2544a2f83440dab292f0980_0.geojson"
file <- "utility_territories.geojson"
download.file(url, file)
utility_territories <- readOGR(dsn = "utility_territories.geojson", layer = "utility_territories")

#create extra spdf so we don't have to reload
spdf_extra<-utility_territories

##Load csv of map IDs and SF IDs
sf_data<- read.csv("Carbon_Reduction_Tracker/Utility_Territory_Matching.csv", header= T)

##Merge
#Force same number of columns before and after keep all ~2900
utility_territories <-merge(x = utility_territories, y = sf_data, by = "ID", all.x= TRUE)

##Clean up accts
#remove utilites that have no matches in salesforce or are canadian
utility_territories <-utility_territories[!is.na(utility_territories@data$Account.Name), ]
utility_territories <-utility_territories[utility_territories@data$COUNTRY!="CAN", ]

utility_territories <-utility_territories[-c(2,4:36)]

all_territories_data <- utility_territories@data


territories_w_parent <-utility_territories[utility_territories@data$Parent.Name!="", ]



##Merge polygons by parents
parent_territories <- aggregate(territories_w_parent,
                             by = list(territories_w_parent@data$Parent.Name),
                             FUN=head, 1)

##Combine spdfs
#Reformat columns to match
parent_territories <- parent_territories[c(6,7)]
names(parent_territories@data) <- c("ID", "Name")

utility_territories <- utility_territories[c(3,4)]
names(utility_territories@data) <- c("ID", "Name")

utility_territories<-rbind(utility_territories,parent_territories, makeUniqueIDs = TRUE)

##Save
writeOGR(utility_territories, dsn="Carbon_Reduction_Tracker/all_territories", layer="all_territories", driver="ESRI Shapefile")

