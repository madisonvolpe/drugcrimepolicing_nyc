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
library(dplyr)

EMS<- read.csv("/Users/frankie/Desktop/GitHub/drugcrimepolicing_nyc/data/emsdrugs.csv")
SIzip<-read.csv("/Users/frankie/Desktop/GitHub/drugcrimepolicing_nyc/data/SI_Zip_Pop2010.csv")
SIArrests<-as.data.frame(table(EMS$zipcode))
SIArrests$Var1<-as.numeric(as.character(SIArrests$Var1))
names(SIArrests)<-c("Zip.Code","Arrests")
str(SIArrests)
SIzip.agg<-left_join(SIArrests,SIzip[,1:2], by="Zip.Code")
View(SIzip.agg)
SIzip.agg$rate<-SIzip.agg$Arrests/SIzip.agg$Total_WBH

SIzip.agg$adj.rate <-expected(SIzip.agg$Total_WBH, SIzip.agg$Arrests, 1)
SIzip.agg<-rbind(c(10311,0,0,0,0),SIzip.agg)
nrow(SIzip.agg)
SIzip.shp<-readOGR("/Users/frankie/Desktop/SI_Zip/nyu_2451_34509.shp")

SIzip.latlong <- SIzip.shp
SIzip.utm <- spTransform(SIzip.latlong,CRS("+init=epsg:3724 +units=km"))
choropleth(SIzip.utm,SIzip.agg$rate)

SIzip.nb <- poly2nb(SIzip.utm,queen=FALSE)
#creates a neighbors list based on contiguous boundaries
SIzip.lw <- nb2listw(SIzip.nb)
#using the neighbors list it creates weights
moran.test(SIzip.agg$rate,SIzip.lw) 
#above 0 with a statistic of .2 not excessively high to the point of near one but good
#p value of .031 signifies spatial correlation
#0 means no autocorrelation 1+ means high spatial autocorrelation
#look for autocorrelation between regions
moran.mc(SIzip.agg$rate,SIzip.lw,nsim=999)
#value of .042 means possibility for spacial structure

####problem with the greary test b/c adj rate is wrong
geary.test(SIzip.agg$adj.rate,SIzip.lw) 
#p-value of .025
#statistic of .68
geary.mc(SIzip.agg$adj.rate,SIzip.lw,nsim=999)
#p-value of .02
# strong show of possible autocorrelation between regions.68

zip.moran.loc <-localmoran(SIzip.agg$adj.rate,SIzip.lw,p.adjust.method="fdr") 
shades <- shading(c(0.05),cols=c(2,8))
choropleth(SIzip.utm,zip.moran.loc[,"Pr(z > 0)"],shades)
moran.plot(SIzip.agg$adj.rate, SIzip.lw)
######kuldorff check########
geo <- latlong2grid(pennLC$geo[,2:3])  #kilometer-based
#pop.upper.bound=0.5  -> don't choose a cluster larger than 1/2 of the population
png("MCdistnLambda.png")
pois.fit <- kulldorff(geo, PA.agg$cases, PA.agg$population, PA.agg$adj.rate/1000,pop.upper.bound=0.5,n.simulations=999,alpha.level=0.05,plot=T)
dev.off()
cluster1 <- pois.fit$most.likely.cluster$location.IDs.included
cluster2 <- pois.fit$secondary.clusters[[1]]$location.IDs.included

cat("P-values associated with clusters 1 & 2:")
print(round(c(pois.fit$most.likely.cluster$p.value,pois.fit$secondary.clusters[[1]]$p.value),3))