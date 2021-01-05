# carbon-reduction-tracker

Electric companies (aka utilities) play a key role in tackling climate change. Electric power generation is responsible for around 30 percent of U.S. greenhouse gas emissions in a given year. Many utilities are taking steps to reduce emissions and have announced ambitious goals.

The Carbon Reduction Tracker is a webpage that displays these goals in both a map of utility service territories and a corresponding table.

This webpage is a resource for utilities to compare their goals with others across the country. It also helps corporations coordinate their decarbonization and renewable energy goals by allowing them to identify utilities' goals where their operations are located.

https://sepapower.org/utility-carbon-reduction-tracker/

## Technology Stack
<img src= "https://github.com/JohnvanZalk/carbon-reduction-tracker/blob/master/images/technology_diagram.JPG" width="700">

**Initial Matching:** A geojson with utility territories is publicly available on ArcGIS' Open Data Portal. From the geojson, a spatial dataframe is created and merged with a dataframe of utility ids from Salesforce. These ids allow goals (which are housed in Salesforce) to be paired with the correct utility territory polygon. After this matching process, the spatial dataframe is saved as shapefiles. 

Note: Due to file size restraints, the shapefiles have not been uploaded to this repository

**Filter Utilities:** The shapefiles produced in the initial matching are read in as a spatial dataframe. Using the Salesforce API, a list of utilities with emission reduction goals is retrieved from Salesforce. Goals are merged with the spatial dataframe, and polygons for utilites that do not have goals are removed. Again, the filtered spatial datframe is saved as shapefiles.

**Create Leaflet Map:** A leaflet map is created from the filtered polygons. The leaflet output is saved as an html file. This file and a csv are pushed to AWS S3.

The unique S3 object url for the map is Iframed to Wordpress. The csv is available for download by completing a form.
