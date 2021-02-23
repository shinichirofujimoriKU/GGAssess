# This program is for IPCC SR 1.5 load and analysis
# 27, 11, 2018
# Shinichiro Fujimori
# The main contents are 
#   1. data process of original database csv file
#   2. Visualization of cumulative emissions in histogram
#   3. emissions figures for Kainuma-san COP presentation in 2018

library(gdxrrw)
library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyr)
library(maps)
library(grid)
library(RColorBrewer)
library(JavaGD)
library(xlsx)
library(scales)
library(tableone)
library(cowplot)

variablemap <- read.table("../modeloutput/variablemap.txt",sep="\t",header=T) 
modelemap <- read.table("../modeloutput/modelmap.txt",sep="\t",header=T) 
worlddata <- read.csv("../modeloutput/iamc15_scenario_data_all_regions_r1.csv", header=T) 
Modellist <- unique(worlddata$Model)
Scenariolist <- unique(worlddata$Scenario)
Variablelist <- as.vector(unique(worlddata$Variable))
colhead <- c("Model","Scenario","Region","Variable","Unit")
colhead2 <- c("ModelN","Scenario","Region","Variable2","Unit")
yearlist <- c("2005","2010","2015","2020","2025","2030","2035","2040","2045","2050","2055","2060","2065","2070","2075","2080","2085","2090","2095","2100")
yearxlist <- c("X2005","X2010","X2015","X2020","X2025","X2030","X2035","X2040","X2045","X2050","X2055","X2060","X2065","X2070","X2075","X2080","X2085","X2090","X2095","X2100")
worlddata1 <-worlddata %>% gather(key=Year,value=Value,-Model,-Scenario,-Region,-Variable,-Unit) %>% inner_join(variablemap,by="Variable")  %>%
  select(-Variable) %>% inner_join(modelemap,by="Model") %>% select(-Model)  %>% select(append(colhead2,c("Year","Value"))) 
row.has.na.worlddata1 <- apply(worlddata1, 1, function(x){any(is.na(x))})
worlddata1 <- worlddata1[!row.has.na.worlddata1,] 

symDim <- 7
attr(worlddata1, "symName") <- "IPCCSR15All"
lst4 <- wgdx.reshape(worlddata1, symDim)
wgdx.lst(gdxName = "../modeloutput/IPCCSR15All.gdx",lst4)

system(paste("gams IPCC.gms",sep=" "))

