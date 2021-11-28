# carbon-reduction-tracker

Electric companies (aka utilities) play a key role in tackling climate change. Electric power generation is responsible for around 30 percent of U.S. greenhouse gas emissions in a given year. Many utilities are taking steps to reduce emissions and have announced ambitious goals.

The Carbon Reduction Tracker is a webpage that displays these goals in both a map of utility service territories and a corresponding table.

This webpage is a resource for utilities to compare their goals with others across the country. It also helps corporations coordinate their decarbonization and renewable energy goals by allowing them to identify utilities' goals where their operations are located.

<img src= "https://github.com/JohnvanZalk/carbon-reduction-tracker/blob/master/images/Utilities and Utility Parents.png" width="700">

https://sepapower.org/utility-transformation-challenge/utility-carbon-reduction-tracker/

**Initial Matching:** A geojson with utility territories is publicly available on ArcGIS' Open Data Portal. From the geojson, a spatial dataframe is created and merged with a dataframe of utility ids from Salesforce. These ids allow goals (which are housed in Salesforce) to be paired with the correct utility territory polygon. After this matching process, the spatial dataframe is saved as shapefiles. 

Note: Due to file size restraints, the shapefiles have not been uploaded to this repository
