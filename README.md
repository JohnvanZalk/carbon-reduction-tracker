# carbon-reduction-tracker

Electric companies (aka utilities) play a key role in tackling climate change. Electric power generation is responsible for around 30 percent of U.S. greenhouse gas emissions in a given year.

Many utilities are taking steps to reduce emissions and have announced ambitious goals to reduce their impact on the environment.

The Carbon Reduction Tracker is a webpage that displays these goals in both a map of utility service territories and a corresponding table of utility goals.

This webpage is a resource for utilities to compare their goals with others across the country and potentially connect them with one another.

It also helps corporations coordinate their decarbonization and renewable energy goals by allowing them to identify utilities with similar goals where their operations are located.

https://sepapower.org/utility-carbon-reduction-tracker/

## Technology Stack
<img src= "https://github.com/JohnvanZalk/carbon-reduction-tracker/blob/master/images/technology_diagram.JPG" width="700">

Here is the process to create and update the map and table:

**Initial Matching:** A geojson with utility territories is publicly available on ArcGIS' Open Data Portal. From the geojson, a spatial dataframe is created  and merged with a dataframe of utility ids from Salesforce. These ids allow goals (which are housed in Salesforce) to be paired with the correct utility territory polygon. After this matching process, the spatial dataframe is saved as shapefiles. 

Note: Due to file size restraints, the shapefiles have not been uploaded to this repository

**Filter Utilities:** 


**Create Leaflet Map:** Saving leaflet output as html

Wordpress pulls from S3

## Future Development
Due to cost contraints, SQL and Tableau

