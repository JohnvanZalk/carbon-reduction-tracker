# carbon-reduction-tracker

Electric companies (aka utilities) play a key role in tackling climate change. Electric power generation is responsible for around 30 percent of U.S. greenhouse gas emissions in a given year. Many utilities are taking steps to reduce emissions and have announced ambitious goals.

The [Carbon Reduction Tracker](https://sepapower.org/utility-transformation-challenge/utility-carbon-reduction-tracker/) is a resource for utilities to compare their goals with others across the country. It also helps corporations coordinate their decarbonization and renewable energy goals by allowing them to identify utilities' goals where their operations are located.

The webpage displays these goals in both a dashboard and a corresponding dataset.

**Dashboard:** A geojson with utility territories is publicly available on ArcGIS' Open Data Portal. From the geojson, a spatial dataframe is created and merged with a dataframe of utility ids from a Salesforce environment. These ids allow goals (which are housed in Salesforce) to be paired with the correct utility territory polygon. After the id mapping process, the spatial dataframe is saved as shapefiles. The shapefiles are then uploaded to Tableau to be displayed in the dashboard.

<img src= "https://github.com/JohnvanZalk/carbon-reduction-tracker/blob/master/images/Utilities and Utility Parents.png" width="700">

**Dataset:** In addition to viewing the dashboard, users of the tracker can download a dataset. Goal data stored in Salesforce is pasted into an Excel template using the openpyxl package in Python and then uploaded to a public AWS S3 bucket. This process is automated so the dataset is refreshed daily.

Note: Due to file size restraints, the utility shapefiles have not been uploaded to this repository
