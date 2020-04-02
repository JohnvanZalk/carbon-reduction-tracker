#!/usr/bin/Rscript

#Using crontab
#To edit or create new schedule past crontab -e in Terminal
#Press i to enter insert mode
#MIN HR DAY MON DOY CMD
#Time is in UTC! (UTC is 4 hours later than EDT)
#Insert /usr/bin/Rscript at top of script or in cron job line
#Press CTRL+C to exit insert mode
#Save and quit by typing :wq
#Make R script executable with chmod +x /home/user/Location/Of/Script 

#Load required packages
library(leaflet)
library(rgdal)
library(rgeos)
library(sf)
library(maptools)
library(RForcecom)

#Login to Salesforce
username <- ""
password <- ""
loginURL <- ""
apiVersion <- ""
session <- rforcecom.login(username, password, loginURL, apiVersion)

#Load the shapefiles to Spatial Point Data Frame (SPDF) by referncing the basename (layer)
utility_shapes <- readOGR(dsn="/home/rstudio/Carbon_Reduction_Tracker/all_territories", layer = "all_territories")

AccountQuery<- "SELECT Account_18_Digit_ID__c,Has_Carbon_Reduction_Tracker_Goal__c,SEPA_Sub_Organization_Type__c,BillingState,Has_Emission_Reduction_Goal__c,Emission_Reduction_Target_Year__c,Emission_Reduction_Goal__c,Has_Ren__c,Renewable_Energy_Target_Year__c,Renewable_Energy_Goal__c FROM Account WHERE Has_Carbon_Reduction_Tracker_Goal__c = TRUE"
goals<-rforcecom.query(session, AccountQuery)
goals <- goals[, c("Account_18_Digit_ID__c","Has_Carbon_Reduction_Tracker_Goal__c", "SEPA_Sub_Organization_Type__c","BillingState", "Has_Emission_Reduction_Goal__c", "Emission_Reduction_Target_Year__c", "Emission_Reduction_Goal__c", "Has_Ren__c", "Renewable_Energy_Target_Year__c","Renewable_Energy_Goal__c")]

utility_shapes <-merge(x = utility_shapes, y = goals, by.x = "ID", by.y= "Account_18_Digit_ID__c", all.x= TRUE)

utility_shapes <-utility_shapes[!is.na(utility_shapes@data$Has_Carbon_Reduction_Tracker_Goal__c), ]

#delete old files
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.dbf")
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.prj")
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.shp")
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.shx")

writeOGR(utility_shapes, dsn="Carbon_Reduction_Tracker/filtered_territories", layer= "filtered_territories", driver="ESRI Shapefile")

#to see shapes run: plot(utility_shapes, lwd=0.3)
 
