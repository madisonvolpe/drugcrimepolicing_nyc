Introduction
------------

Staten Island, the forgotten borough of NYC, is understudied in academic literature. Both academic journals and policy briefs alike neglect issues that the borough is facing. However, this neglect will allow us to analyze and release new and exciting information about criminal justice issues in the city’s forgotten borough. Like, other areas of NYC, Staten Island has the same law enforcement, NYPD, as well as other government policies in place. This should make it comparable to other boroughs, but it is seemingly different owed to its unique history and landscape. Up until the 1960s, when the Verrazzano Bridge was completed, Staten Island had no connection to any other borough except through the SI Ferry. Even today, Staten Island lacks a subway that connects it to Manhattan and other boroughs. Both these facts play largely into the socioeconomic landscape of Staten Island. Because the borough remained disconnected for so long, it was largely white until the 1960s. Once the Verrazzano Bridge was created the city wanted to create apartments and affordable housing, but native Islanders were strongly against it. Their fears of minorities and rallying cries worked as all affordable housing never infiltrated the Island’s South Shore and until this day is only on the Island’s North Shore. The history of Staten Island has created a geographically segregated borough. To put this into perspective, predominantly white neighborhoods on the South Shore, such as Tottenville and Annadale are .2% and .5% black respectively, likewise they are only 7.1% and 6.2% Hispanic. In comparison, neighborhoods on the North Shore, such as Port Ivory and Mariner’s Harbor are 58.8% and 44.6% black and 26% and 32.7% Hispanic. The racial divide in Staten Island is evident and one could make the argument that it is unique for NYC, especially considering that other boroughs are gentrifying faster than Staten Island. In addition to its geographic racial segregation, Staten Island is also suffering from a heroin crisis. This crisis is affecting all neighborhoods, but it is particularly concentrated in the predominantly white South Shore. Due to this information, one would think that police activity would be concentrated in this area. However, most police activity, especially for drugs occurs on the borough’s North Shore.

Our Questions
-------------

Due to Staten Island’s current drug problem, as well as the geographic segregation in the borough, we would like to examine how police arrests for drugs differ throughout the borough. Staten Island only has four police precincts, within these police precincts, there are a variety of different neighborhoods. Within the neighborhoods, there are census blocks. In the above paragraph, we made the claim that most neighborhoods in Staten Island are predominantly minority on the North Shore and predominantly White on the South Shore. However, within this neighborhoods, there are still census blocks that may differ from the neighborhood’s normal racial makeup. With these facts in mind, we have come up with the following questions:

1.  How do drug arrests differ across neighborhoods in Staten Island?

    -   Are certain neighborhoods more targeted for drug arrests ?
    -   Are certain blocks within neighborhoods more targeted for drug arrests?
    -   What is the racial makeup of the targeted neighborhoods and blocks within neighborhoods?

2.  Where is drug activity happening on Staten Island?

    -   By this we mean, where are drug overdoses happening?
    -   Where are hospital admissions for drug overdoses? Are more admissions happening at the North Shore’s Richmond University Medical Center (RUMC) or the South Shore’s Staten Island University Hospital (SIUH)?

3.  Are the neighborhoods with the most drug activity targeted more for drug arrests? Can we show that most drug arrests are happening on the Island’s North Shore at a far greater rate than the South Shore even though drug activity is the same rate on both shores?

Data
----

### Datasets Consulted

We are using the following data sources:

-   [NYPD Arrest Data YTD](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc) :white\_check\_mark:

-   [NYPD Arrrest Data Historic](https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u) :white\_check\_mark:

-   [NYPD Criminal Court Summons Data YTD](https://data.cityofnewyork.us/Public-Safety/NYPD-Criminal-Court-Summons-Incident-Level-Data-Ye/mv4k-y93f)

-   [NYPD Criminal Court Summons Data Historic](https://data.cityofnewyork.us/Public-Safety/NYPD-Criminal-Court-Summons-Historic-/sv2w-rv3k)

-   [NYC Population by Census Tracts](https://data.cityofnewyork.us/dataset/New-York-City-Population-By-Census-Tracts/kc6e-jm93)

-   [Death/Moratlity Data 2000-2016](https://a816-healthpsi.nyc.gov/epiquery/VS/index.html)

-   [Vital Statistics: Death Micro SAS Datasets](https://www1.nyc.gov/site/doh/data/data-sets/death-micro-sas-datasets.page)

### Datasets Created

-   si\_drugs - all drug arrests from 2013-2018 that have taken place on Staten Island (used - NYPD Arrest Data YTD + NYPD Arrest Data Historic)

-   deaths\_cause - Deaths by each NYC (community district) neighborhood in 2016 (used- DOHMH epiquery)

-   premature\_deaths\_Cause - Premature deaths by each NYC (community district) neighborhood in 2016 (used - DOHMH epiquery)

-   deaths\_psychoactive\_CT - deaths that occured due to psychoactive drugs by Census Tract 2010-2014 (used - DOHMH SAS datasets)

### Spatial Data

Methods
-------
