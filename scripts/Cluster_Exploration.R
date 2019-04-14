library(ggplot2)
library(lattice)
library(maps)
library(spdep)
library(spatstat)
library(maptools)
library(RColorBrewer)
library(classInt)
library(rgdal)
library(formatR)
library(sm)
library(smacpod)
library(SpatialEpi)
library(GISTools)
library(dplyr)
library(fpc)
####Checking K values to see if the points are Randomized#######

SI<-read.csv("/Users/frankie/Desktop/drugcrimepolicing_nyc/data/si_drugs_mod_arrests.csv")
Smn <- apply(SI[,c("longitude","latitude")],2,min)
Smx <- apply(SI[,c("longitude","latitude")],2,max)
SP <- ppp(SI$longitude,SI$latitude,window=owin(c(Smn[1],Smx[1]),c(Smn[2],Smx[2])))
SE.square <- envelope(SP, Kest, nsim =100)
plot(SE.square, main="K values for Drug Arrest")


black<-SI[SI$perp_race=="BLACK",]

Bmn <- apply(black[,c("longitude","latitude")],2,min)
Bmx <- apply(black[,c("longitude","latitude")],2,max)
BP <- ppp(black$longitude,black$latitude,window=owin(c(Bmn[1],Bmx[1]),c(Bmn[2],Bmx[2])))
BE.square <- envelope(BP, Kest, nsim =100)
plot(BE.square, main="K values for Black Perpitrators")

####Now checking Clusters/Spatial with Race and population Make up built in

NTA1<-read.csv("/Users/frankie/Desktop/SI_project/NTA_COUNT_POP.csv")
NTA<-read.csv("/Users/frankie/Desktop/SI_project/NTA_COUNT_POP.csv")
#Look over NTA Data
View(NTA)
#Population variables are factor because of commas
NTA$Total_Pop<-gsub(",","",NTA$Total_Pop)
NTA$Total_Pop<-as.numeric(NTA$Total_Pop)
NTA$Black_Pop<-gsub(",","",NTA$Black_Pop)
NTA$Black_Pop<-as.numeric(NTA$Black_Pop)
NTA$Hispanic_Pop<-gsub(",","",NTA$Hispanic_Pop)
NTA$Hispanic_Pop<-as.numeric(NTA$Hispanic_Pop)
NTA$White_Pop<-gsub(",","",NTA$White_Pop)
NTA$White_Pop<-as.numeric(NTA$White_Pop)
#all are switched to numeric
#Arrest totals are bigger than major groups Black, White and Hispanic

0->NTA[19,c("Total_A","White_A")]
#deal with the infite problem in rate
NTA<-mutate(NTA,WBH_Arrest=Black_A+White_A+Hispanic_A)
NTA<-mutate(NTA,WBH_Pop=Black_Pop+White_Pop+Hispanic_Pop)
#Make new variable to reflect population in each are of just groups of interest
SI.agg<-NTA[,c("NTA","WBH_Pop","WBH_Arrest")] #DB on NTA Cases and Population
SI.agg$rate <- 1000*SI.agg$WBH_Arrest/SI.agg$WBH_Pop #gets the case rate for population per county
#How many arrests per thousand people
View(SI.agg)
0->SI.agg[19,"rate"] #rate of 0,0 appears to be NA

v<-c(0,0,0,0) #initiator row
for (i in 1:19){
a<-c(NTA[i,c('NTA','White_A','White_Pop')],"White")
b<-c(NTA[i,c('NTA','Black_A','Black_Pop')],"Black")
c<-c(NTA[i,c('NTA','Hispanic_A','Hispanic_Pop')],"Hispanic")
v<-rbind(v,a,b,c)
}
#create a more usable aggrigate dataframe
race.agg<-as.data.frame(v[-1,]) #remove the initator row
names(race.agg)<-c("NTA","Arrests","Population","Race") #name columns

race.agg$NTA<-unlist(race.agg$NTA)
race.agg$Race<-unlist(race.agg$Race)
race.agg$Arrests<-unlist(race.agg$Arrests)
race.agg$Population<-unlist(race.agg$Population)
race.agg$Race<-as.factor(race.agg$Race)
race.agg$Arrests<-as.integer(race.agg$Arrests)
race.agg$Population<-as.integer(race.agg$Population)
#unlisting specific variables

xtabs(~Race,data=race.agg)
#simple table stratification
#each is simply 3 race catagories white black hispanic

n.strata <- prod(dim(xtabs(~Race,data=race.agg)))

SI.agg$adj.rate <- 1000*expected(race.agg$Population, race.agg$Arrests, n.strata)


SI.shp<-readOGR("/Users/frankie/Desktop/SI_project/SI_WG/New_Stat.shp")
#read in shape file of staten island

SI.latlong <- SI.shp
SI.utm <- spTransform(SI.latlong,CRS("+init=epsg:3724 +units=km"))
choropleth(SI.utm,SI.agg$rate)

SI.nb <- poly2nb(SI.utm,queen=FALSE)
#creates a neighbors list based on contiguous boundaries
SI.lw <- nb2listw(SI.nb)
#using the neighbors list it creates weights
moran.test(SI.agg$rate,SI.lw) 
#above 0 with a statistic of .2 not excessively high to the point of near one but good
#p value of .031 signifies spatial correlation
#0 means no autocorrelation 1+ means high spatial autocorrelation
#look for autocorrelation between regions
moran.mc(SI.agg$rate,SI.lw,nsim=999)
#value of .042 means possibility for spacial structure

geary.test(SI.agg$adj.rate,SI.lw)
#p-value of .025
#statistic of .68
geary.mc(SI.agg$adj.rate,SI.lw,nsim=999)
#p-value of .02
# strong show of possible autocorrelation between regions.68

moran.loc <-localmoran(SI.agg$adj.rate,SI.lw,p.adjust.method="fdr") 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(SI.utm,moran.loc[,"Pr(z > 0)"],shades)
moran.plot(SI.agg$adj.rate, SI.lw)
#one is of the park which makes sense for difference
#other is old town dongan hills south beach area

###DBscan Statistic
SI<-read.csv("/Users/frankie/Desktop/drugcrimepolicing_nyc/data/si_drugs_mod_arrests.csv")
eucdist<-dist(SI[,c("longitude","latitude")],method = "euclidean")
euc.mat<-as.matrix(eucdist)

mins<-apply(euc.mat,MARGIN=1,function(x)sort(x)[[3]])
min(mins) ###0 doesn't make much conventional sense here
#The issue is that because of this it is hard to gauge a EPS so some trial and error will be done
dist.vec<-as.vector(euc.mat) #so we can look at dist in histogram
hist(dist.vec,breaks = 40) #see majority falls between 0-.05 atleast half
scan1<-dbscan(SI[,c("longitude","latitude")],eps=.01,MinPts = 4)
max(scan1$cluster) #only 1 cluster created
scan2<-dbscan(SI[,c("longitude","latitude")],eps=.005,MinPts = 4)
max(scan2$cluster) #7 clusters created could make good sense
scan3<-dbscan(SI[,c("longitude","latitude")],eps=.008,MinPts = 10)
max(scan3$cluster) #no good only 1 cluster
scan4<-dbscan(SI[,c("longitude","latitude")],eps=.008,MinPts = 4)
max(scan4$cluster)# 1 cluster still


#the 7 cluster model appears to be the best thus far
scan2<-dbscan(SI[,c("longitude","latitude")],eps=.005,MinPts = 4)