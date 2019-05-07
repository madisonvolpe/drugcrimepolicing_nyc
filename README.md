Introduction
------------

Staten Island, the forgotten borough of NYC, is understudied in academic literature. Both academic journals and policy briefs alike neglect issues that the borough is facing. However, this neglect will allow us to analyze and release new and exciting information about criminal justice issues in the city’s forgotten borough. Like, other areas of NYC, Staten Island has the same law enforcement, NYPD, as well as other government policies in place. This should make it comparable to other boroughs, but it is seemingly different due to its unique history and landscape.

Up until the 1960s, when the Verrazzano Bridge was completed, Staten Island had no connection to any other borough except through the SI Ferry. Even today, Staten Island lacks a subway that connects it to Manhattan and other boroughs. Both these facts play largely into the socioeconomic landscape of Staten Island. Because the borough remained disconnected for so long, it was largely white until the 1960s. Once the Verrazzano Bridge was created the city wanted to create apartments and affordable housing, but native Islanders were strongly against it. Their fears of minorities and rallying cries worked as all affordable housing never infiltrated the Island’s South Shore and until this day is only on the Island’s North Shore.

The history of Staten Island has created a geographically segregated borough. To put this into perspective, predominantly white neighborhoods on the South Shore, such as Tottenville and Annadale are .2% and .5% black respectively, likewise they are only 7.1% and 6.2% Hispanic. In comparison, neighborhoods on the North Shore, such as Port Ivory and Mariner’s Harbor are 58.8% and 44.6% black and 26% and 32.7% Hispanic. The racial divide in Staten Island is evident and one could make the argument that it is unique for NYC, especially considering that other boroughs are gentrifying faster than Staten Island.

In addition to its geographic racial segregation, Staten Island is also suffering from a heroin crisis. This crisis is affecting all neighborhoods, but it is particularly concentrated in the predominantly white South Shore. Due to this information, one would think that police activity would be concentrated in this area. However, most police activity, especially for drugs occurs on the borough’s North Shore.

Our Question
------------

#### Primary Questions

Are the neighborhoods with the most drug activity targeted more for drug arrests? Can we show that most drug arrests are happening on the Island’s North Shore at a far greater rate than the South Shore even though drug activity is the same rate on both shores?

#### Secondary Questions

1.  How do drug arrests differ across neighborhoods in Staten Island?

    -   Are certain neighborhoods more targeted for drug arrests ?

2.  Where is drug activity happening on Staten Island?

    -   By this we mean, where are drug overdoses happening?
    -   Where are complaints being made about drugs?

Data
----

### Datasets Consulted

We are using the following data sources:

-   [NYPD Arrest Data YTD](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc) :white\_check\_mark:

-   [NYPD Arrrest Data Historic](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u) :white\_check\_mark:

-   [EMS Incident Dispatch Data](https://data.cityofnewyork.us/Public-Safety/EMS-Incident-Dispatch-Data/76xm-jjuj) :white\_check\_mark:

-   [311 Service Requests from 2010 to Present](https://nycopendata.socrata.com/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9) :white\_check\_mark:

### Main folder

-   si\_drugs\_arrests - all drug arrests from 2013-2018 that have taken place on Staten Island (used - NYPD Arrest Data YTD + NYPD Arrest Data Historic)

-   si\_drugs\_mod\_arrests - as above, but we created indicator variables for different levels of drug arrests

-   emsoriginal - all ems calls not filtered for drugs

-   emsdrugs - all ems dispatch calls related to drugs in SI from 2013-2018

-   311\_Service\_Requests\_from\_2010\_to\_Present - 311 calls on Staten Island 2010 to Present

-   DemoByZipACS2017 - Demographic data for SI zip codes from the 2017 ACS (1 yr estimates)

-   HispanicbyZipACS2017 - Demographic data for SI zip codes from the 2017 ACS (1 yr estimates)

-   SI\_Zip\_Pop2010 - Population estimates for SI zip codes from the 2010 census

### Model datasets

-   Contains all datasets run in our poisson models

### ACS\_Demo

-   Datasets from the 2014 to 2017 American Community survey

-   ACS.14\_17 - combines ACS datasets into one large one

### Extra

-   Any datasets we accumulated along the way that at one point we may have used in our analysis...or not

### Spatial Datasets (Download cannot upload to LFS)

-   [ZipCode](https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u)
-   [NTA](https://data.cityofnewyork.us/City-Government/Neighborhood-Tabulation-Areas/cpf4-rkhq)
-   [Census Tract](https://data.cityofnewyork.us/City-Government/2010-Census-Tracts/fxpq-c8ku)
-   [Precincts](https://data.cityofnewyork.us/Public-Safety/Police-Precincts/78dh-3ptz)

Methods
-------

-   Poisson models with arrest counts by zipcode

-   Spatial analysis

Limitations
-----------

-   Measuring drug activity in zipcode
