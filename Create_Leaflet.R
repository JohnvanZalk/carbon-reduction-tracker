#Load packages
library(leaflet) #Mapping
library(sp) #Combining polygon data with a simple df
library(dplyr) #Data manipulation
library(rgdal) #Loading spatial data
library(rgeos) #Simplfying polygons
library(htmlwidgets) #Turning a map into an html file
library(aws.s3) #Writing objects to AWS S3

#Read shapefiles produced in Filter_Utilities.R
utility_shapes <- readOGR(dsn = "Carbon_Reduction_Tracker/filtered_territories", layer = "filtered_territories")
names(utility_shapes@data) <-c("ID","Name","SEPA_Sub_Organization_Type__c","BillingState", "Has_Emission_Reduction_Goal__c", "Emission_Reduction_Target_Year__c", "Emission_Reduction_Goal__c")
data <-utility_shapes@data

#Simply polygons to improve performance on website
utility_shapes_simple<-gSimplify(utility_shapes, tol = 0.05, topologyPreserve = TRUE)
#Reattach data to polygons
utility_shapes<- sp::SpatialPolygonsDataFrame(utility_shapes_simple, data)

#Make utility names all uppercase
emission_shapes@data$Name <- toupper(emission_shapes@data$Name)

#Create csv
utility_data <- emission_shapes@data[-c(1,3,6,9:11)]
names(utility_data) <-c("Name","Utility Type","State", "Emission Reduction Target Year","Emission Reduction Goal")
write.csv(utility_data,"Carbon_Reduction_Tracker/table.csv", row.names = FALSE)

#Import AWS credentials
call_service(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)

#Authenticate to AWS
Sys.setenv("AWS_ACCESS_KEY_ID" = AWS_ACCESS_KEY_ID, "AWS_SECRET_ACCESS_KEY" = AWS_SECRET_ACCESS_KEY)

#Upload csv
put_object(file = "Carbon_Reduction_Tracker/table.csv", object = "tracker_data.csv", bucket = "sepa-utility-crt")

#Store leaflet in utility_map object
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

#Save map as html
htmlwidgets::saveWidget(utility_map,"/home/rstudio/Carbon_Reduction_Tracker/map.html")

#Upload html
put_object(file = "/home/rstudio/Carbon_Reduction_Tracker/map.html", object = "map.html", bucket = "sepa-utility-crt")


