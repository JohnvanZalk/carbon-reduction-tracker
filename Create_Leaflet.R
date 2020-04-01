#!/usr/bin/Rscript

#load packages
library(leaflet)
library(sp)
library(dplyr)
library(rgdal)
library(rgeos)
library(sf)
library(maptools)
library(htmlwidgets)
library(aws.s3)

#read shapefile
utility_shapes <- readOGR(dsn = "Carbon_Reduction_Tracker/filtered_territories", layer = "filtered_territories")
names(utility_shapes@data) <-c("ID","Name","Has_Carbon_Reduction_Tracker_Goal__c","SEPA_Sub_Organization_Type__c","BillingState", "Has_Emission_Reduction_Goal__c", "Emission_Reduction_Target_Year__c", "Emission_Reduction_Goal__c", "Has_Ren__c", "Renewable_Energy_Target_Year__c","Renewable_Energy_Goal__c")
data <-utility_shapes@data

utility_shapes_simple<-gSimplify(utility_shapes, tol = 0.05, topologyPreserve = TRUE)
utility_shapes<- sp::SpatialPolygonsDataFrame(utility_shapes_simple, data)

emission_shapes <-utility_shapes[utility_shapes@data$Has_Emission_Reduction_Goal__c %in% "true",]
emission_shapes@data$Name <- toupper(emission_shapes@data$Name)

#Create csv
utility_data <- emission_shapes@data[-c(1,3,6,9:11)]
names(utility_data) <-c("Name","Utility Type","State", "Emission Reduction Target Year","Emission Reduction Goal")
write.csv(utility_data,"Carbon_Reduction_Tracker/table.csv", row.names = FALSE)

Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAIEBFDTGHCAOIBT5A","AWS_SECRET_ACCESS_KEY" = "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")


put_object(file = "Carbon_Reduction_Tracker/table.csv", object = "tracker_data.csv", bucket = "sepa-utility-crt")

#store leaflet in utility_map object
utility_map <- leaflet() %>%
  fitBounds(-124, 49, -65, 25) %>%
  addTiles() %>%
  addPolygons(data = emission_shapes,
              fillOpacity = 0.5,
              weight = 0.5,
              color = "forestgreen",
              fillColor = "forestgreen",
              highlightOptions = highlightOptions(weight = 2),
              popup = paste("<b style='color: #00a0df;font-family: Arial;font-size:14px'>",emission_shapes@data$Name,"</b>","<br>",
                            "<b style='color: #223a6f;font-family: Arial'>Emission Reduction Goal:</b>","<span style='color: #223a6f;font-family: Arial'>",emission_shapes@data$Emission_Reduction_Goal__c,"</span>"))

#save map as html to folder
htmlwidgets::saveWidget(utility_map,"/home/rstudio/Carbon_Reduction_Tracker/map.html")

put_object(file = "/home/rstudio/Carbon_Reduction_Tracker/map.html", object = "map.html", bucket = "sepa-utility-crt")


