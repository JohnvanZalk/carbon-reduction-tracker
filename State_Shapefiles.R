#Load required packages
library(rgdal)# For loading and writing spatial data

#Load the state shapefiles
states <- readOGR(dsn="/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles", layer = "cb_2018_us_state_500k")

#Load salesforce id mapping file
sf_ids <- read_csv("/home/rstudio/Carbon_Reduction_Tracker/GitHub/Data/State_Salesforce_Mapping.csv")

#Merge state polygons with salesforce ids
states <-merge(x = states, y = sf_ids, by.x = "NAME", by.y= "State", all.x= TRUE)

#Save
writeOGR(states, dsn="/home/rstudio/Carbon_Reduction_Tracker/GitHub/Shapefiles", layer= "State_Shapefiles", driver="ESRI Shapefile")

