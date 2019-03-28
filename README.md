Introduction
------------

Staten Island, the forgotten borough of NYC, is understudied in academic literature. Both academic journals and policy briefs alike neglect issues that the borough is facing. However, this neglect will allow us to analyze and release new and exciting information about criminal justice issues in the city’s forgotten borough. Like, other areas of NYC, Staten Island has the same law enforcement, NYPD, as well as other government policies in place. This should make it comparable to other boroughs, but it is seemingly different owed to its unique history and landscape.

    Up until the 1960s, when the Verrazzano Bridge was completed, Staten Island had no connection to any other borough except through the SI Ferry. Even today, Staten Island lacks a subway that connects it to Manhattan and other boroughs. Both these facts play largely into the socioeconomic landscape of Staten Island. Because the borough remained disconnected for so long, it was largely white until the 1960s. Once the Verrazzano Bridge was created the city wanted to create apartments and affordable housing, but native Islanders were strongly against it. Their fears of minorities and rallying cries worked as all affordable housing never infiltrated the Island’s South Shore and until this day is only on the Island’s North Shore. 

    The history of Staten Island has created a geographically segregated borough. To put this into perspective, predominantly white neighborhoods on the South Shore, such as Tottenville and Annadale are .2% and .5% black respectively, likewise they are only 7.1% and 6.2% Hispanic. In comparison, neighborhoods on the North Shore, such as Port Ivory and Mariner’s Harbor are 58.8% and 44.6%  black and 26% and 32.7% Hispanic. The racial divide in Staten Island is evident and one could make the argument that it is unique for NYC, especially considering that other boroughs are gentrifying faster than Staten Island. 

    In addition to its geographic racial segregation, Staten Island is also suffering from a heroin crisis. This crisis is affecting all neighborhoods, but it is particularly concentrated in the predominantly white South Shore. Due to this information, one would think that police activity would be concentrated in this area. However, most police activity, especially for drugs occurs on the borough’s North Shore. 

Our Questions
-------------

Due to Staten Island’s current drug problem, as well as the geographic segregation in the borough, we would like to examine how police arrests for drugs differ throughout the borough. Staten Island only has four police precincts, within these police precincts, there are a variety of different neighborhoods. Within the neighborhoods, there are census tracts. In the above paragraph, we made the claim that most neighborhoods in Staten Island are predominantly minority on the North Shore and predominantly white on the South Shore. However, within this neighborhoods, there are still census trcts that may differ from the neighborhood’s normal racial makeup. With these facts in mind, we have come up with the following questions:

1.  How do drug arrests differ across neighborhoods in Staten Island?

    -   Are certain neighborhoods more targeted for drug arrests ?
    -   Are certain tracts within neighborhoods more targeted for drug arrests?
    -   What is the racial makeup of the targeted neighborhoods and tracts within neighborhoods?

2.  Where is drug activity happening on Staten Island?

    -   By this we mean, where are drug overdoses happening?
    -   Where are complaints being made about drugs?
    -   911 calls ?
    -   311 calls ?
    -   EMS ?
    -   Where are hospital admissions for drug overdoses? Are more admissions happening at the North Shore’s Richmond University Medical Center (RUMC) or the South Shore’s Staten Island University Hospital (SIUH)?

3.  Are the neighborhoods with the most drug activity targeted more for drug arrests? Can we show that most drug arrests are happening on the Island’s North Shore at a far greater rate than the South Shore even though drug activity is the same rate on both shores?

Data
----

### Datasets Consulted

We are using the following data sources:

-   [NYPD Arrest Data YTD](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc) :white\_check\_mark:

-   [NYPD Arrrest Data Historic](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u) :white\_check\_mark:

-   [EMS Incident Dispatch Data](https://data.cityofnewyork.us/Public-Safety/EMS-Incident-Dispatch-Data/76xm-jjuj) :white\_check\_mark:

-   [311 Service Requests from 2010 to Present](https://nycopendata.socrata.com/Social-Services/311-Service-Requests-from-2010-to-Present/erm2-nwe9) :construction:

### Datasets Created

#### Drug Arrests

-   si\_drugs - all drug arrests from 2013-2018 that have taken place on Staten Island (used - NYPD Arrest Data YTD + NYPD Arrest Data Historic)

-   si\_drugs\_mod\_arrests - as above, but we created indicator variables for different levels of drug arrests

#### Drug 'Activity'

-   emsdrugs - all ems dispatch calls in SI from 2013-2018

### Spatial Datasets

-   [ZipCode](https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u)
-   [NTA](https://data.cityofnewyork.us/City-Government/Neighborhood-Tabulation-Areas/cpf4-rkhq)
-   [Census Tract](https://data.cityofnewyork.us/City-Government/2010-Census-Tracts/fxpq-c8ku)
-   [Precincts](https://data.cityofnewyork.us/Public-Safety/Police-Precincts/78dh-3ptz)

### Demographic Datasets

-   DemobyCT - Demographics by Census Tract
-   DemobyNTA - Demographics by NTA
-   PopbyNTA - Population by NTA
-   CensusTractDemoAll - More involved Demographics by Census Tract

Methods - In progress
---------------------

-   We have conducted exploratory spatial analysis in both QGIS + R - making maps overlaying arrests with racial makeups of NTA, CT. See *Maps* for QGIS analysis, see *ea\_Arrests* in scripts for R analysis! :white\_check\_mark:

-   We are working on getting counts of arrests for each NTA, CT :construction:

-   We are also in the process of getting measures of drug activity by area :construction:
