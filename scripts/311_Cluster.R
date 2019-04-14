library(ggplot2)
library(lattice)
library(spdep)
library(spatstat)
library(maptools)
library(RColorBrewer)
library(classInt)
library(rgdal)
library(formatR)
library(sm)
library(fpc)

three.one.one<-read.csv("/Users/frankie/Desktop/311_Service_Requests_from_2010_to_Present.csv")
levels(three.one.one$Complaint.Type)
xtabs(~Complaint.Type,data=three.one.one)
#164 Drug Activity
#120 Graffiti
#942 Drinking
#429 DIsorderly Youth
#Derelect Vehicle 21428



SI<-read.csv("/Users/frankie/Desktop/drugcrimepolicing_nyc/data/si_drugs_mod_arrests.csv")

Smn <- apply(SI[,c("longitude","latitude")],2,min)
Smx <- apply(SI[,c("longitude","latitude")],2,max)
SP <- ppp(SI$longitude,SI$latitude,window=owin(c(Smn[1],Smx[1]),c(Smn[2],Smx[2])))
SE.square <- envelope(SP, Kest, nsim =100)
plot(SE.square, main="K values for Drug Arrest")
class(SP)
black<-SI[SI$perp_race=="BLACK",]

Bmn <- apply(black[,c("longitude","latitude")],2,min)
Bmx <- apply(black[,c("longitude","latitude")],2,max)
BP <- ppp(black$longitude,black$latitude,window=owin(c(Bmn[1],Bmx[1]),c(Bmn[2],Bmx[2])))
BE.square <- envelope(BP, Kest, nsim =100)
plot(BE.square, main="K values for Black Perpitrators")

eucdist<-dist(SI[,c("longitude","latitude")],method = "euclidean")
euc.mat<-as.matrix(eucdist)
