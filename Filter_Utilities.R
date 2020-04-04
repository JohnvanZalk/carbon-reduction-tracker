#Load required packages
library(rgdal)#Loading and writing spatial data
library(RForcecom)#Querying Saleforce

#Authenticate to Salesforce
session <- rforcecom.login(username, password, loginURL, apiVersion)

#Load the shapefiles from Initial_Matching.R to spdf by referncing the basename (layer)
utility_shapes <- readOGR(dsn="/home/rstudio/Carbon_Reduction_Tracker/all_territories", layer = "all_territories")

#Retrieve goals from utility accounts in Salesforce
AccountQuery<- "SELECT Account_18_Digit_ID__c,Has_Carbon_Reduction_Tracker_Goal__c,SEPA_Sub_Organization_Type__c,BillingState,Has_Emission_Reduction_Goal__c,Emission_Reduction_Target_Year__c,Emission_Reduction_Goal__c FROM Account WHERE Has_Carbon_Reduction_Tracker_Goal__c = TRUE"
goals<-rforcecom.query(session, AccountQuery)
goals <- goals[, c("Account_18_Digit_ID__c","Has_Carbon_Reduction_Tracker_Goal__c", "SEPA_Sub_Organization_Type__c","BillingState", "Has_Emission_Reduction_Goal__c", "Emission_Reduction_Target_Year__c", "Emission_Reduction_Goal__c")]

#Merge utiltiy territory polygons with goals
utility_shapes <-merge(x = utility_shapes, y = goals, by.x = "ID", by.y= "Account_18_Digit_ID__c", all.x= TRUE)

#Remove polygons that don't have goals
utility_shapes <-utility_shapes[!is.na(utility_shapes@data$Has_Carbon_Reduction_Tracker_Goal__c), ]

#delete old files
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.dbf")
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.prj")
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.shp")
file.remove("Carbon_Reduction_Tracker/filtered_territories/filtered_territories.shx")

#Save
writeOGR(utility_shapes, dsn="Carbon_Reduction_Tracker/filtered_territories", layer= "filtered_territories", driver="ESRI Shapefile")

#to see shapes run: plot(utility_shapes, lwd=0.3)
 
