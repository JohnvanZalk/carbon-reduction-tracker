#Load required packages
library(rgdal)#Loading and writing spatial data
library(sp)
library(raster)

#Load the utility shapefiles
utilities <- readOGR(dsn="/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles", layer = "Utility_Shapefiles")

#Load the state shapefiles
states <- readOGR(dsn="/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles", layer = "State_Shapefiles")
#----------------

#Remove a polygon
utilities<-utilities[utilities@data$ID!="001o000000ivWrUAAU", ]

#----------------

#Assign a polygon to different Salesforce id
utilities@data$ID <- as.character(utilities@data$ID)
utilities@data$ID[utilities@data$ID == "001o000000ivYaDAAU"] <- "001o000000ivYaCAAU"

#----------------

#Intersect utility polygon with state to create a polygon for a utility's service territory in that state only
crop_utility <-utilities[utilities@data$ID=="001o000000ivZ5aAAE", ]

crop_state <-aggregate(states[states@data$NAME=="Colorado", ])

#Delete existing polygon
utilities <- utilities[utilities@data$ID!="001o000000ivZ5aAAE", ]

#Match up projections
crop_state <- spTransform(crop_state, proj4string(crop_utility))

#Perform intersection
crop_utility <- intersect(crop_state, crop_utility)

#Add new shape to utilities spdf
utilities<-rbind(utilities,crop_utility, makeUniqueIDs=TRUE)

#Plot to confirm success
plot(utilities[utilities@data$ID=="001o000000ivWrQAAU", ])

#Delete old files
file.remove("/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles/Utility_Shapefiles.dbf")
file.remove("/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles/Utility_Shapefiles.prj")
file.remove("/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles/Utility_Shapefiles.shp")
file.remove("/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles/Utility_Shapefiles.shx")

#Save
writeOGR(utilities, dsn="/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles", layer= "Utility_Shapefiles", driver="ESRI Shapefile")


