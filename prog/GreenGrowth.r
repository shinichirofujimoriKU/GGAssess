# This program is AIM/Enduse and CGE Japan coupling analysis
#----------------------data loading and parameter settings ----------------------*
if(insflag==1){
options(CRAN="http://cran.md.tsukuba.ac.jp/")
install.packages("ggplot2", dependencies = TRUE)
install.packages("RColorBrewer", dependencies = TRUE)
#install.packages("grid", dependencies = TRUE)
#install.packages("gdxrrw", dependencies = TRUE)
install.packages("dplyr", dependencies = TRUE)
install.packages("sp", dependencies = TRUE)
install.packages("maptools", dependencies = TRUE)
install.packages("maps", dependencies = TRUE)
install.packages("ggradar", dependencies = TRUE)
install.packages("fmsb", dependencies = TRUE)
install.packages("tidyr", dependencies = TRUE)
install.packages("stringr", dependencies = TRUE)
install.packages("rJava", dependencies = TRUE)
install.packages("jpeg", dependencies = TRUE)
install.packages("Rcpp", dependencies = TRUE)
install.packages("ReporteRsjars", dependencies = TRUE)
install.packages("ReporteRs", dependencies = TRUE)
install.packages("xlsx", dependencies = TRUE)
install.packages("R2PPT", dependencies = TRUE) #Rtools needs to be installed
install.packages('RDCOMClient', repos = 'http://www.omegahat.net/R/')
}

library(gdxrrw)
library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyr)
library(maps)
library(grid)
library(RColorBrewer)
library(R2PPT)
library(cowplot)
library(RDCOMClient)
library("colorspace")
library(jpeg)
library(png)
library(xlsx)

OrRdPal <- brewer.pal(9, "OrRd")
set2Pal <- brewer.pal(8, "Set2")
YlGnBupal <- brewer.pal(9, "YlGnBu")
Redspal <- brewer.pal(9, "Reds")
pastelpal <- brewer.pal(9, "Pastel1")
pastelpal <- brewer.pal(8, "Set1")
BluYlpal <- sequential_hcl(5,"BluYl")
YlGnpal <- sequential_hcl(5,"YlGn")


MyThemeLine <- theme_bw() +
  theme(
    panel.border=element_rect(fill=NA),
    panel.grid.minor = element_line(color = NA), 
    #    axis.title=element_text(size=5),
    #    axis.text.x = element_text(hjust=1,size = 10, angle = 0),
    axis.line=element_line(colour="black"),
    panel.background=element_rect(fill = "white"),
    #    panel.grid.major=element_line(linetype="dashed",colour="grey",size=0.5),
    panel.grid.major=element_blank(),
    strip.background=element_rect(fill="white", colour="white"),
    strip.text.x = element_text(size=10, colour = "black", angle = 0,face="bold"),
    axis.text.x=element_text(size = 10,angle=45, vjust=0.9, hjust=1, margin = unit(c(t = 0.3, r = 0, b = 0, l = 0), "cm")),
    axis.text.y=element_text(size = 10,margin = unit(c(t = 0, r = 0.3, b = 0, l = 0), "cm")),
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10),
    axis.ticks.length=unit(-0.15,"cm")
  )

#-- data load
dir.create("../output/")
dir.create("../output/ppt")
dir.create("../output/main")
outputdir <- c("../output/")
#filename should be "global_17","CHN","JPN"....
fileloc <- c("E:/sfujimori/CGE/AIMHubGreenGV1.0/")
filename <- c("global_17")
file.copy(paste0(fileloc,"anls_output/iiasa_database/gdx/",filename,"_IAMC.gdx"), paste0("../modeloutput/",filename,"_emf.gdx"),overwrite = TRUE)
file.copy(paste0(fileloc,"output/global/global_17/gdx/analysis.gdx"), paste0("../modeloutput/analysis.gdx"),overwrite = TRUE)
system(paste("gams IPCC.gms",sep=" "))
system(paste("gams Greengrowth.gms",sep=" "))

linepalette <- c("#4DAF4A","#FF7F00","#377EB8","#E41A1C","#984EA3","#F781BF","#8DD3C7","#FB8072","#80B1D3","#FDB462","#B3DE69","#FCCDE5","#D9D9D9","#BC80BD","#CCEBC5","#FFED6F","#7f878f","#A65628","#FFFF33")
linepalette <- c("#E41A1C","#FF7F00","#377EB8","#B3DE69","#4DAF4A","#984EA3","#F781BF","#8DD3C7","#FB8072","#80B1D3","#FDB462","#FCCDE5","#D9D9D9","#BC80BD","#CCEBC5","#FFED6F","#7f878f","#A65628","#FFFF33")
landusepalette <- c("#8DD3C7","#FF7F00","#377EB8","#4DAF4A","#A65628")
scenariomap <- read.table("../data/scenariomap.map", sep="\t",header=T, stringsAsFactors=F)
scenariomap2 <- read.table("../data/scenariomap2.map", sep="\t",header=T, stringsAsFactors=F)
ScenarioOrder <- read.table("../data/ScenarioOrder.txt", sep="\t",header=T, stringsAsFactors=F)
SecOrder <- read.table("../data/Aggsecord.txt", sep="\t",header=T, stringsAsFactors=F)
decompfactor <- read.table("../data/decompfactor.txt", sep="\t",header=T, stringsAsFactors=F)
region <- as.vector(read.table("../data/region.txt", sep="\t",header=F, stringsAsFactors=F)$V1)
varlist_load <- read.table("../data/varlist.txt", sep="\t",header=F, stringsAsFactors=F)
varalllist <- read.table("../data/varalllist.txt", sep="\t",header=F, stringsAsFactors=F)
varlist <- left_join(varlist_load,varalllist,by="V1")
areapalette <- c("Coal|w/o CCS"="#000000","Coal|w/ CCS"="#7f878f","Oil|w/o CCS"="#ff2800","Oil|w/ CCS"="#ffd1d1","Gas|w/o CCS"="#9a0079","Gas|w/ CCS"="#c7b2de","Hydro"="#0041ff","Nuclear"="#663300","Solar"="#b4ebfa","Wind"="#ff9900","Biomass|w/o CCS"="#35a16b","Biomass|w/ CCS"="#cbf266","Geothermal"="#edc58f","Other"="#ffff99",
                 "Solid"=pastelpal[1],"Liquid"=pastelpal[2],"Gas"=pastelpal[3],"Electricity"=pastelpal[4],"Heat"=pastelpal[5],"Hydrogen"=pastelpal[6],
                 "Industry"=set2Pal[1],"Transport"=set2Pal[2],"Commercial"=set2Pal[3],"Residential"=set2Pal[4],
                 "Build-up"=pastelpal[1],"Cropland (for food)"=pastelpal[2],"Forest"=pastelpal[3],"Pasture"=pastelpal[4],"Energy Crops"=pastelpal[5],"Other Land"=pastelpal[6],"Other Arable Land"=pastelpal[7])
areamap <- read.table("../data/Areafigureorder.txt", sep="\t",header=T, stringsAsFactors=F)
areamappara <- read.table("../data/Area.map", sep="\t",header=T, stringsAsFactors=F)
RegionAgg <- c("R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM")
scenariometaSR15 <- read.table("../data/meta.txt", sep="\t",header=T, stringsAsFactors=F)

FigList <- list()     # list for figure storage
FigdataList <- list() # list for figure data

#---IAMC tempalte loading and data merge

  CGEload0 <- rgdx.param(paste0('../modeloutput/global_17_emf_diff.gdx'),'IAMCTemplate') 
  Getregion <- as.vector(unique(CGEload0$REMF))
  if(length(Getregion)==1){region <- Getregion}
  allmodel0 <- CGEload0 %>% rename("Value"=IAMCTemplate,Variable=".i3") %>% 
    left_join(scenariomap,by="SCENARIO") %>% filter(SCENARIO %in% as.vector(scenariomap[,1]) & REMF %in% region) %>% 
    select(-SCENARIO) %>% rename(Region="REMF",SCENARIO="Name",Indicator=".i5")
  
  file.copy(paste0(fileloc,"AIMCGE/individual/IEAEB1062CGE/output/IEAEBIAMCTemplate.gdx"), paste0("../data/IEAEBIAMCTemplate.gdx"),overwrite = TRUE)
  IEAEB0 <- rgdx.param('../data/IEAEBIAMCTemplate.gdx','IAMCtemp17') %>% rename("Value"=IAMCtemp17,"Variable"=VEMF,"Y"=St,"Region"=Sr17,"SCENARIO"=SceEneMod) %>%
    select(Region,Variable,Y,Value,SCENARIO) %>% filter(Region %in% region) %>% mutate(Model="Reference",NDC="None")
  IEAEB0$Y <- as.numeric(levels(IEAEB0$Y))[IEAEB0$Y]
  IEAEB1 <- filter(IEAEB0,Y<=2015 & Y>=1990) %>% mutate(Indicator="abs")
  
  allmodel0$Y <- as.numeric(levels(allmodel0$Y))[allmodel0$Y]
  allmodel <- rbind(allmodel0,IEAEB1)  
  
  #Decomposition results
  Decompload0 <- rgdx.param(paste0('../modeloutput/global_17_emf_diff.gdx'),'Loss_dcp_agg') 
  Decomp0 <- Decompload0 %>% rename("Value"=Loss_dcp_agg) %>% 
    left_join(scenariomap,by="SCENARIO") %>% filter(SCENARIO %in% as.vector(scenariomap[,1]) & REMF %in% region) %>% 
    select(-SCENARIO) %>% rename(Region="REMF",SCENARIO="Name",Indicator=".i6") %>% inner_join(decompfactor) %>% left_join(SecOrder)
  Decomp0$Y <-  as.numeric(levels(Decomp0$Y))[Decomp0$Y]
  
#---- Main figure parts
##---- NPV comparison with IPCC 
#---IAMC tempalte loading and data merge
IPCCSR15 <- rgdx.param(paste0('../modeloutput/CumulativeEmissions.gdx'),'NPV') 
IPCCSR15All <- rgdx.param(paste0('../modeloutput/CumulativeEmissions.gdx'),'IPCCSR15All') %>% rename(Value=IPCCSR15All) %>% select(-".i7")
IPCCSR15All$Y <- as.numeric(levels(IPCCSR15All$Y))[IPCCSR15All$Y]

#---2100 NPV total
IPCCSR15_v2 <- filter(IPCCSR15,Variable2 %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Pol_Cos_GDP_Los_rat_NPV_1pc","Pol_Cos_GDP_Los_rat_NPV_5pc","Emi_CO2_Cum","Emi_Kyo_Gas_Cum") & Region=="World"  & Y==2100) %>% select(-Unit) %>% spread(value=NPV,key=Variable2) 
allmodel_v2 <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Pol_Cos_GDP_Los_rat_NPV_1pc","Pol_Cos_GDP_Los_rat_NPV_5pc","Emi_CO2_Cum","Emi_Kyo_Gas_Cum")  & Y==2100 & Indicator=="abs") %>%  spread(value=Value,key=Variable) 

plotdata1 <- filter(IPCCSR15_v2,Pol_Cos_GDP_Los_rat_NPV_3pc<=8 & Pol_Cos_GDP_Los_rat_NPV_3pc>=-10 & Emi_CO2_Cum<=2000 )
plotdata2 <- filter(allmodel_v2, Pol_Cos_GDP_Los_rat_NPV_3pc>=-10 & Emi_CO2_Cum/1000>=500 & NDC=="off" & Region=="World")
plot.0 <- ggplot() + 
  geom_point(data=plotdata1,aes(x=Emi_CO2_Cum, y = Pol_Cos_GDP_Los_rat_NPV_3pc),color="black",alpha=1,shape=21,size=1.0,fill="white") +
  MyThemeLine +  xlab("Cumulative CO2 emissions from 2011 to 2100 (GtCO2)") + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" ")) +
  theme(legend.title=element_blank()) + annotate("segment",x=300,xend=2000,y=0,yend=0,linetype="solid",color="grey") +
  geom_point(data=plotdata2,aes(x=Emi_CO2_Cum/1000, y = Pol_Cos_GDP_Los_rat_NPV_3pc,shape=Model,color=Model),size=3.0,fill="white") +
  scale_shape_manual(values=c(21,22,23,24,25,20))+ scale_color_manual(values=linepalette)
outname <- paste0(outputdir,"/main/GDPLoss_CO2.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("GDPLoss_CO2"=plot.0))
FigdataList <- c(FigdataList,list("GDPLoss_CO2_1"=plotdata1))
FigdataList <- c(FigdataList,list("GDPLoss_CO2_2"=plotdata2))


plotdata1 <- filter(IPCCSR15_v2,Pol_Cos_GDP_Los_rat_NPV_3pc<=8 & Pol_Cos_GDP_Los_rat_NPV_3pc>=-10 & Emi_Kyo_Gas_Cum<=2500)
plotdata2 <- filter(left_join(allmodel_v2,ScenarioOrder), Pol_Cos_GDP_Los_rat_NPV_3pc>=-10 & Emi_Kyo_Gas_Cum/1000>=500 & NDC=="off" & Region=="World")
plot.0 <- ggplot() + 
  geom_point(data=plotdata1,aes(x=Emi_Kyo_Gas_Cum, y = Pol_Cos_GDP_Los_rat_NPV_3pc),color="black",alpha=1,shape=21,size=1.0,fill="white") +
  MyThemeLine + xlab(expression(paste("Cumulative Kyoto Gas emissions from 2011 to 2100" * "(" * GtCO[2] * "eq)",sep=""))) + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" ")) +
  theme(legend.title=element_blank()) + annotate("segment",x=800,xend=2500,y=0,yend=0,linetype="solid",color="grey") +
  geom_point(data=plotdata2,aes(x=Emi_Kyo_Gas_Cum/1000, y = Pol_Cos_GDP_Los_rat_NPV_3pc,shape=Model,color=Model),size=3.0,fill="white") +
  scale_shape_manual(values=c(21,22,23,24,25,20))+ scale_color_manual(values=linepalette)
outname <- paste0(outputdir,"/main/GDPLoss_Kyotogas.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("GDPLoss_Kyotogas"=plot.0))
FigdataList <- c(FigdataList,list("GDPLoss_Kyotogas_1"=plotdata1))
FigdataList <- c(FigdataList,list("GDPLoss_Kyotogas_2"=plotdata2))

dataplot <- filter(left_join(allmodel,ScenarioOrder), SCENARIO=="1000C" & NDC=="off" & Region=="World" & Indicator=="abs" & Variable=="Pol_Cos_GDP_Los_rat")
plot.0 <- ggplot() + 
  geom_point(data=dataplot,aes(x=Y, y = Value,shape=Model,color=Model),size=1.0,fill="white") +
  geom_line(data=dataplot,aes(x=Y, y = Value,shape=Model,color=Model)) +
  MyThemeLine + scale_color_manual(values=linepalette) +xlab("year") + ylab("GDP loss rate (%)")  +  ggtitle("") +
  annotate("segment",x=2005,xend=maxy,y=0,yend=0,linetype="dashed",color="grey")+ theme(legend.title=element_blank()) 
FigList <- c(FigList,list("GDPLoss_timeseries"=plot.0))
FigdataList <- c(FigdataList,list("GDPLoss_timeseries"=dataplot))

dataplot <- filter(IPCCSR15All,Variable2 %in% c("Pol_Cos_GDP_Los_rat") & Region=="World") %>% select(-Unit) %>% left_join(scenariometaSR15)
plot.0 <- ggplot() + 
  geom_line(data=dataplot,aes(x=Y, y = Value*100,group=interaction(Scenario,ModelN),color=category),alpha=0.5) +
  MyThemeLine + scale_color_manual(values=linepalette) +xlab("year") + ylab("GDP loss rate (%)")  +  ggtitle("") +
  annotate("segment",x=2005,xend=2100,y=0,yend=0,linetype="dashed",color="grey")+ theme(legend.title=element_blank()) 
FigList <- c(FigList,list("GDPLoss_timeseries_lit"=plot.0))
FigdataList <- c(FigdataList,list("GDPLoss_timeseries_lit"=dataplot))

dataplot <- filter(left_join(allmodel_v2,ScenarioOrder), Pol_Cos_GDP_Los_rat_NPV_3pc>=-10 & Region %in% RegionAgg & NDC=="off")
plot.0 <- ggplot() + 
  geom_point(data=dataplot,aes(x=reorder(ScenarioOrder,SCENARIO), y = Pol_Cos_GDP_Los_rat_NPV_3pc,shape=Model,color=Model),size=3.0,fill="white") +
  MyThemeLine +  
  xlab("Cumulative CO2 emissions from 2011 to 2100 (GtCO2)") + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" ")) +
  theme(legend.title=element_blank())  +
  scale_shape_manual(values=c(21,22,23,24,25,20))+ scale_color_manual(values=linepalette) +
    facet_wrap(.~Region)+ annotate("segment",x=0,xend=10,y=0,yend=0,linetype="solid",color="grey")
outname <- paste0(outputdir,"/main/GDPLoss_NPV_Region.png")
ggsave(plot.0, file=outname, dpi = 150, width=10, height=6,limitsize=FALSE)
FigList <- c(FigList,list("GDPLoss_NPV_Region"=plot.0))
FigdataList <- c(FigdataList,list("GDPLoss_NPV_Region"=dataplot))

#---discount rate variation
DiscountMap <- read.table("../data/discountmap.map", sep="\t",header=T, stringsAsFactors=F)
IPCCSR15_v2_0 <- rename(IPCCSR15,Variable=Variable2) %>% filter(Variable %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Pol_Cos_GDP_Los_rat_NPV_1pc","Pol_Cos_GDP_Los_rat_NPV_5pc") & Region=="World" & Y %in% c(2030,2050,2100)) %>% select(-Unit) %>% rename(Value=NPV) %>% left_join(DiscountMap)
allmodel_v2_0 <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Pol_Cos_GDP_Los_rat_NPV_1pc","Pol_Cos_GDP_Los_rat_NPV_5pc") & Region=="World" & Y %in% c(2030,2050,2100) & Indicator=="abs" & NDC!="on")  %>% left_join(DiscountMap)

IPCCSR15_v2_CO2 <- filter(IPCCSR15,Variable2 %in% c("Emi_CO2_Cum") & Region=="World" & Y %in% c(2030,2050,2100)) %>% select(-Unit,-Variable2) %>% rename(CO2=NPV)
allmodel_v2_CO2 <- filter(allmodel,Variable %in% c("Emi_CO2_Cum") & Region=="World" & Y %in% c(2030,2050,2100) & Indicator=="abs")  %>% select(-Variable) %>% rename(CO2=Value)


dataplot <- left_join(IPCCSR15_v2_0,IPCCSR15_v2_CO2) %>% filter(CO2<=2000,Value<=10)
dataplot$Y <- as.numeric(levels(dataplot$Y))[dataplot$Y]
dataplot2 <- left_join(allmodel_v2_0,allmodel_v2_CO2) %>% filter(Model=="Integration(IST)")
plot.0 <- ggplot() + 
  geom_point(data=dataplot,aes(x=DiscountRates, y = Value,color=CO2),alpha=0.5,shape=21,size=1.0,fill="white") +
  MyThemeLine +  xlab("Discount rates (%)") + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" ")) +
  scale_color_viridis_c(name=expression(paste("Carbon budgets " * "(" * GtCO[2] * ")")))+
  annotate("segment",x=0,xend=4,y=0,yend=0,linetype="solid",color="grey") +
  geom_point(data=dataplot2,aes(x=DiscountRates, y = Value,color=CO2/1000),size=3.0,shape=22)  + 
  facet_wrap(.~Y)
outname <- paste0(outputdir,"/main/GDPLoss_DisCount.png")
ggsave(plot.0, file=outname, dpi = 150, width=7, height=3,limitsize=FALSE)
FigList <- c(FigList,list("GDPLoss_DisCount"=plot.0))
FigdataList <- c(FigdataList,list("GDPLoss_DisCount_1"=dataplot))
FigdataList <- c(FigdataList,list("GDPLoss_DisCount_2"=dataplot2))

#--- investment figure
varname <- data.frame("Variable"=c("Inv_Ene_Sup","Red_Cos_Emi_GHG","Inv_Ene_Dem_Eff_and_Dec"),"VarName"=c("Energy Supply","Non-Energy related","Energy Demand"))
dataplot <- filter(allmodel,Variable %in% varname$Variable & Region=="World"  & Indicator=="dif" & Y==2100 & NDC!="on") %>%
  inner_join(ScenarioOrder) %>% left_join(varname)
plot.0 <- ggplot() + 
  geom_bar(data=dataplot,aes(x=reorder(ScenarioOrder,SCENARIO), y = -(Value) , fill=VarName), stat="identity") +
  ylab("Additional Investment (billion $/yr)") + xlab("Mitigation policy stringency") +labs(fill="")+ guides(fill=guide_legend(reverse=TRUE)) + MyThemeLine +
  theme(legend.position="bottom", text=element_text(size=12),  
        axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
  guides(fill=guide_legend(ncol=3)) + ggtitle(paste("World ","Investment",sep=" ")) +
  facet_wrap( ~ Model,ncol=5) + scale_fill_manual(values=pastelpal)  + theme(legend.position='bottom')
outname <- paste0(outputdir,"/main/Investment.png")
ggsave(plot.0, file=outname, dpi = 150, width=9, height=3,limitsize=FALSE)
FigList <- c(FigList,list("Investment"=plot.0))
FigdataList <- c(FigdataList,list("Investment"=dataplot))

dataplot <- filter(allmodel,Variable %in% varname$Variable & Region=="World"  & Indicator=="dif" & SCENARIO=="1000C" & NDC!="on") %>% left_join(varname)
plot.0 <- ggplot() + 
  geom_bar(data=dataplot,aes(x=Y, y = -(Value) , fill=VarName), stat="identity") +
  ylab("Additional Investment (billion $/yr)") + xlab("Year") +labs(fill="") + MyThemeLine +
  theme(legend.position="bottom", text=element_text(size=12),  
        axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +  guides(fill=guide_legend(ncol=3)) +
  facet_wrap( ~ Model,ncol=5) + scale_fill_manual(values=pastelpal)  + theme(legend.position='bottom')
outname <- paste0(outputdir,"/main/Investment_1000C.png")
ggsave(plot.0, file=outname, dpi = 150, width=7, height=3,limitsize=FALSE)
FigList <- c(FigList,list("Investment_1000C"=plot.0))
FigdataList <- c(FigdataList,list("Investment_1000C"=dataplot))

InvFigList <- list()
InvFigdataList <- list()
for(md in unique(scenariomap$Model)){
  dataplot <- filter(allmodel,Variable %in% varname$Variable & Region=="World"  & Indicator=="dif" & SCENARIO=="1000C" & NDC!="on" & Model==md) %>% left_join(varname)
  dataplot2 <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los") & Indicator=="dif" & SCENARIO=="1000C" & NDC=="off" & Model==md  & Region=="World") %>% mutate(VarName="Total")
  plot.0 <- ggplot() + 
    geom_bar(data=filter(dataplot,Model==md),aes(x=Y, y = -(Value) , fill=VarName), stat="identity") +
    ylab("Saved investment (billion $/yr)") + xlab("Year") +labs(fill="") + MyThemeLine +
    theme(legend.position="bottom", text=element_text(size=12),  
          axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +  guides(fill=guide_legend(ncol=3)) + scale_fill_manual(values=pastelpal)  + theme(legend.position='bottom') +
    geom_line(data=filter(allmodel_v3,Model==md & Region=="World"),aes(x=Y, y = -(Value)),color="black", stat="identity") 
    
  InvFiglisttmp <- list(plot.0)
  InvFigdatalisttmp <- list(rbind(dataplot,dataplot2))
  names(InvFiglisttmp) <- md
  names(InvFigdatalisttmp) <- md
  InvFigList <- c(InvFigList,InvFiglisttmp)
  InvFigdataList <- c(InvFigdataList,InvFigdatalisttmp)
  
}

#---Difference figure  
rr <- "World"
plotdata <- filter(allmodel,Variable=="Pol_Cos_GDP_Los_rat" & Model!="Reference"& Region==rr & Indicator=="dif" & SCENARIO=="1000C" & NDC!="on")
plot.0 <- ggplot() + 
  geom_area(data=filter(plotdata,Model!="Integration(IST)"),aes(x=Y, y = Value , fill=Model), stat="identity") + 
  ylab("GDP loss rate differences (%) ") + xlab("Year") +labs(fill="") + MyThemeLine +
  geom_line(data=filter(plotdata,Model=="Integration(IST)"),aes(x=Y, y = Value ), stat="identity") + scale_fill_manual(values=linepalette[c(2,3,5,6)]) + 
  theme(legend.position="bottom", text=element_text(size=12),  
        axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
  guides(fill=guide_legend(ncol=1)) + scale_x_continuous(breaks=seq(min(plotdata$Y),max(plotdata$Y),10)) +  ggtitle(paste(rr,"GDP loss rate differences from Default",sep=" ")) +
  annotate("segment",x=2010,xend=max(plotdata$Y),y=0,yend=0,linetype="solid",color="grey") + theme(legend.position='right')
outname <- paste0(outputdir,"/main/GDP_loss.png")
ggsave(plot.0, file=outname, dpi = 150, width=10, height=6,limitsize=FALSE)
FigList <- c(FigList,list("GDP_loss_Dif"=plot.0))
FigdataList <- c(FigdataList,list("GDP_loss_Dif"=plotdata))

plotvarlist <- c("Pol_Cos_GDP_Los_rat_NPV_3pc","Inv_Ene_Sup","Inv_Ene_Dem_Eff_and_Dec","Pol_Cos_Cns_Los_rat_NPV_3pc")
for(jj in plotvarlist){
  plotdata <- filter(allmodel,Variable %in% c("Emi_CO2_Cum",jj) & Model %in% c("Integration(IST)","Default") & Region==rr & Indicator=="abs" & NDC!="on") %>% 
    spread(key=Variable,value=Value) %>%    rename("VV"=jj) %>% filter(Emi_CO2_Cum<=1800*1000 & Y==2100)
  plot <- ggplot() + 
    geom_point(data=plotdata,aes(x=Emi_CO2_Cum/1000, y = VV,color=Model ), stat="identity",size=2) + scale_color_manual(values=pastelpal) + 
    ylab(paste0(varalllist[varalllist$V1==jj,2]," ",varalllist[varalllist$V1==jj,3])) + xlab("Carbon budget 2011-2100 (GtCO2)") +labs(color="")+ guides(color=guide_legend(reverse=TRUE)) + MyThemeLine +
    theme(legend.position="bottom", text=element_text(size=12),axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
    guides(fill=guide_legend(ncol=1)) +  ggtitle(paste(rr,varalllist[varalllist$V1==jj,2],sep=" ")) +theme(legend.position='right')
  outname <- paste0(outputdir,rr,"/dif/",jj,".png")
  ggsave(plot, file=outname, dpi = 150, width=7, height=7,limitsize=FALSE)
  if(jj=="Pol_Cos_Cns_Los_rat_NPV_3pc"){
    FigList <- c(FigList,list("Pol_Cos_Cns_Los_rat_NPV_3pc"=plot))
    FigdataList <- c(FigdataList,list("Pol_Cos_Cns_Los_rat_NPV_3pc"=plotdata))
  }
} 

#--Regional variation
#--Difference
plotdata <- filter(allmodel,Variable=="Pol_Cos_GDP_Los_rat_NPV_3pc" & Model!="Reference"& Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM") & Indicator=="dif" & SCENARIO=="1000C" & Y==2100 & NDC!="on")
plot.0 <- ggplot() + 
  geom_bar(data=filter(plotdata,Model!="Integration(IST)"),aes(x=Region, y = Value , fill=Model), stat="identity") + 
  ylab("GDP loss rate differences (%) ") + xlab("Region") +labs(fill="")+ guides(fill=guide_legend(reverse=TRUE)) + MyThemeLine +
  scale_fill_manual(values=linepalette[c(2,3,5,6)]) +
  geom_point(data=filter(plotdata,Model=="Integration(IST)"),aes(x=Region, y = Value ), stat="identity")  + 
  theme(legend.position="bottom", text=element_text(size=12),  
        axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
  guides(fill=guide_legend(ncol=1)) + ggtitle(paste(rr,"GDP loss rate differences from Default",sep=" ")) + theme(legend.position='right') +
  annotate("segment",x=0.5,xend=6.5,y=0,yend=0,linetype="solid",color="grey")
outname <- paste0(outputdir,"/main/Region1.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("Region1"=plot.0))
FigdataList <- c(FigdataList,list("Region1"=plotdata))


#--Intensity
plotdata <- filter(allmodel,Variable %in% c("Ene_Its","Car_Its") & Model!="Reference"& Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM") & Indicator=="abs" & Model!="Integration(IST)" & SCENARIO=="Baseline" & NDC!="on") %>% 
  left_join(data.frame(Variable=c("Ene_Its","Car_Its"),Variable2=c("Energy Intensity","Carbon Intensity")))
plot.0 <- ggplot() + 
  geom_line(data=plotdata,aes(x=Y, y = Value , color=Region)) + 
  ylab("Intensity") + xlab("Year") +labs(color="")+ guides(color=guide_legend(reverse=TRUE)) + MyThemeLine +scale_color_manual(values=linepalette) +
  theme(legend.position="bottom", text=element_text(size=12),  
        axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
  facet_wrap(. ~ Variable2,scales="free")
outname <- paste0(outputdir,"/main/Intensity.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("Intensity"=plot.0))
FigdataList <- c(FigdataList,list("Intensity"=plotdata))

#-- value added
plotdata <- filter(allmodel,Variable %in% c("Sha_Val_Add_Ind_Ene") & Model!="Reference"& Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM") & Indicator=="abs" & SCENARIO %in% c("Baseline","1000C") & Y>=2020 & NDC!="on" & Model=="Default")
plot.0 <- ggplot() + 
  geom_line(data=plotdata,aes(x=Y, y = Value , color=Region, group=interaction(SCENARIO,Region),stat="identity")) + 
  geom_point(data=plotdata,aes(x=Y, y = Value , color=Region,shape=SCENARIO),size=3,fill="white") + 
  ylab("Share of value added of energy industries (%)") + xlab("Year") +labs(color="",shape="")+ guides(color=guide_legend(reverse=TRUE)) + MyThemeLine +
  scale_color_manual(values=linepalette) + scale_shape_manual(values=c(16,17))
outname <- paste0(outputdir,"/main/ShareValAdd_ind.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("ShareValAdd_ind"=plot.0))
FigdataList <- c(FigdataList,list("ShareValAdd_ind"=plotdata))

plotdata <- filter(allmodel,Variable %in% c("Sha_Val_Add_Agr") & Model!="Reference"& Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM") & Indicator=="abs" & SCENARIO %in% c("Baseline","1000C") & Y>=2020 & NDC!="on" & Model=="Default")
plot.0 <- ggplot() + 
  geom_line(data=plotdata,aes(x=Y, y = Value , color=Region, group=interaction(SCENARIO,Region),stat="identity")) + 
  geom_point(data=plotdata,aes(x=Y, y = Value , color=Region,shape=SCENARIO),size=3,fill="white") + 
  ylab("Share of value added of agriculture (%)") + xlab("Year") +labs(color="",shape="")+ guides(color=guide_legend(reverse=TRUE)) + MyThemeLine +
  scale_color_manual(values=linepalette) + scale_shape_manual(values=c(16,17))
outname <- paste0(outputdir,"/main/ShareValAdd_agr.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("ShareValAdd_agr"=plot.0))
FigdataList <- c(FigdataList,list("ShareValAdd_agr"=plotdata))

#--capital stock
plotdata <- filter(allmodel,Variable %in% c("Cap_Sto") & Model!="Reference"& Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM") & Indicator=="rate" & SCENARIO %in% c("1000C") & Y>=2010 & NDC!="on" & Model %in% c("Investment(AI)"))
plot.0 <- ggplot() + 
  geom_line(data=plotdata,aes(x=Y, y = (Value-1)*100 , color=Region, group=Region,stat="identity")) + 
  geom_point(data=plotdata,aes(x=Y, y = (Value-1)*100 , color=Region,group=Region,shape=Region),size=3,fill="white") + 
  ylab("Capital stock differences from default (%)") + xlab("Year") + MyThemeLine +
  scale_color_manual(values=pastelpal)  
outname <- paste0(outputdir,"/main/CapialStock.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("CapialStock"=plot.0))
FigdataList <- c(FigdataList,list("CapialStock"=plotdata))

#--NDC variation
#--2100 NPV total
plotdata <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Pol_Cos_GDP_Los_rat_NPV_1pc","Pol_Cos_GDP_Los_rat_NPV_5pc") & Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM")  & Y==2100 & SCENARIO=="1000C" & Indicator=="abs" & NDC=="off") %>%  spread(value=Value,key=Variable) %>% filter(Pol_Cos_GDP_Los_rat_NPV_3pc>=-10) 
plotdata2 <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Pol_Cos_GDP_Los_rat_NPV_1pc","Pol_Cos_GDP_Los_rat_NPV_5pc","Emi_CO2_Cum","Emi_Kyo_Gas_Cum") & Region %in% c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM") & Y==2100 & Indicator=="abs" & NDC=="on") %>%  spread(value=Value,key=Variable) %>% filter(Pol_Cos_GDP_Los_rat_NPV_3pc>=-10)
maxv <- ceiling(max(plotdata$Pol_Cos_GDP_Los_rat_NPV_3pc,plotdata2$Pol_Cos_GDP_Los_rat_NPV_3pc))
minv <- floor(min(plotdata$Pol_Cos_GDP_Los_rat_NPV_3pc,plotdata2$Pol_Cos_GDP_Los_rat_NPV_3pc))

plot.0 <- ggplot() + 
  geom_point(data=plotdata,aes(x=Region, y = Pol_Cos_GDP_Los_rat_NPV_3pc,shape=Model,color=Model),size=3.0,fill="white") +
  MyThemeLine + ylim(minv,maxv)  +
  xlab("Region") + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" ")) +
  theme(legend.title=element_blank()) +  scale_shape_manual(values=c(21,22,23,24,25,20))+ scale_color_manual(values=linepalette) +
  annotate("segment",x=0,xend=6.5,y=0,yend=0,linetype="solid",color="grey")
outname <- paste0(outputdir,"/main/NPV_region.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("NPV_regopm"=plot.0))
FigdataList <- c(FigdataList,list("NPV_regopm"=plotdata))

plot.0 <- ggplot() + 
  geom_point(data=plotdata2,aes(x=Region, y = Pol_Cos_GDP_Los_rat_NPV_3pc,shape=Model,color=Model),size=3.0,fill="white") +
  MyThemeLine +  xlab("Region") + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" "))+ ylim(minv,maxv) +
  theme(legend.title=element_blank()) +  scale_shape_manual(values=c(21,22,23,24,25,20))+ scale_color_manual(values=linepalette) +
  annotate("segment",x=0,xend=6.5,y=0,yend=0,linetype="solid",color="grey")
outname <- paste0(outputdir,"/main/NPV_NDCs.png")
ggsave(plot.0, file=outname, dpi = 150, width=5, height=5,limitsize=FALSE)
FigList <- c(FigList,list("NPV_NDC"=plot.0))
FigdataList <- c(FigdataList,list("NPV_NDC"=plotdata2))


#---IAMC tempalte loading and data mergeEnd
#---function
plot.1 <- function(XX,XX2,Xylab1,Xxlab1,Xtitle,Xcolorpal){
  plot <- ggplot() + 
    geom_area(data=XX,aes(x=Y, y = Value , fill=reorder(Ind,-order)), stat="identity") + 
    ylab(Xylab1) + xlab(Xxlab1) +labs(fill="")+ guides(fill=guide_legend(reverse=TRUE)) + MyThemeLine +
    theme(legend.position="bottom", text=element_text(size=12),  
          axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
    guides(fill=guide_legend(ncol=5)) + scale_x_continuous(breaks=seq(miny,maxy,10)) +  ggtitle(paste(rr,Xtitle,sep=" "))
  
  plot2 <- plot +facet_wrap(Model ~ ScenarioOrder,ncol=4) + scale_fill_manual(values=Xcolorpal) + 
    annotate("segment",x=miny,xend=maxy,y=0,yend=0,linetype="solid",color="grey") + theme(legend.position='bottom')
  if(nrow(XX)>=1){
    plot3 <- plot2 +    geom_area(data=XX2,aes(x=Y, y = Value , fill=reorder(Ind,-order)), alpha=0.5,stat="identity")
  }else{
    plot3 <- plot2
  }
  return(plot3)
}

region <- c("World")
nalist <- c(as.vector(varlist$V1),"TPES","POWER","Power_heat","Landuse","TFC_fuel","TFC_Sector","TFC_Ind","TFC_Tra","TFC_Res","TFC_Com")
allplot <- as.list(nalist)
plotflag <- as.list(nalist)
names(allplot) <- nalist
names(plotflag) <- nalist
allplotcge <- list(1)
allplotcge_dif <- list(1)

for(rr in region){
  dir.create(paste0("../output/",rr))
  dir.create(paste0("../output/",rr,"/png"))
  dir.create(paste0("../output/",rr,"/pngdet"))
  dir.create(paste0("../output/",rr,"/ppt"))
  dir.create(paste0("../output/",rr,"/dif"))
  dir.create(paste0("../output/",rr,"/var"))
  dir.create(paste0("../output/",rr,"/Integration(IST)"))
    
  maxy <- max(allmodel$Y)
  miny <- min(allmodel$Y)
  
  #---Line figures
 
   plot_all <- function(X1,Z1,X2){
    XXX <- list(1)
    for (i in 1:nrow(varlist)){
      if(nrow(filter(X1,Variable==varlist[i,1] & Region==rr & Indicator=="abs"))>0){
        miny <- min(filter(X1,Variable==varlist[i,1] & Region==rr)$Y) 
        plot.0 <- ggplot() + 
          geom_line(data=filter(X1,Variable==varlist[i,1] & Region==rr & Indicator=="abs"),aes(x=Y, y = Value , color=interaction(reorder(ScenarioOrder,SCENARIO),Model),group=interaction(SCENARIO,Model)),stat="identity") +
          geom_point(data=filter(X1,Variable==varlist[i,1] & Region==rr & Indicator=="abs"),aes(x=Y, y = Value , color=interaction(reorder(ScenarioOrder,SCENARIO),Model),shape=Model),size=3.0,fill="white") +
          MyThemeLine + scale_color_manual(values=linepalette) + scale_x_continuous(breaks=seq(miny,maxy,10)) +
          xlab("year") + ylab(varlist[i,4])  +  ggtitle(paste(rr,varlist[i,3],sep=" ")) +
          annotate("segment",x=2010,xend=maxy,y=0,yend=0,linetype="dashed",color="grey")+ 
          theme(legend.title=element_blank()) 
        if(length(scenariomap$SCENARIO)<20){
          plot.0 <- plot.0 +
            geom_point(data=filter(X1,Variable==varlist[i,1] & Model=="Reference"& Region==rr),aes(x=Y, y = Value) , color="black",shape=6,size=2.0,fill="grey") 
        }
        if(varlist[i,2]==1){
          outname <- paste0(outputdir,rr,"/",X2,"/",varlist[i,1],".png")
          ggsave(plot.0, file=outname, dpi = 150, width=10, height=6,limitsize=FALSE)
          allplotcge.tmp <- list(plot.0)
          names(allplotcge.tmp) <- paste0(rr,varlist[i,1])
          XXX <- c(XXX,allplotcge.tmp)
        }
      }
    }
    #---Area figures
    for(j in 1:nrow(areamappara)){
      X3 <- X1 %>% filter(Variable %in% as.vector(areamap$Variable)) %>% left_join(areamap,by="Variable") %>% ungroup() %>% 
        filter(Class==areamappara[j,1] & Region==rr & Model!="Reference" & Indicator=="abs") %>% select(Model,SCENARIO,Ind,Y,Value,order,ScenarioOrder)  %>% arrange(order)
      X4 <- Z1 %>% filter(Variable %in% as.vector(areamap$Variable)) %>% left_join(areamap,by="Variable") %>% ungroup() %>% 
        filter(Class==areamappara[j,1] & Model=="Reference"& Region==rr) %>% select(-SCENARIO,-Model,Ind,Y,Value,order)  %>% arrange(order)%>%
        filter(Y<=2015)
      miny <- min(X3$Y) 
      na.omit(X3$Value)
      colorpal <- areapalette
      unit_name <-areamappara[j,3]
      ylab1 <- paste0(areamappara[j,2], " (", unit_name, ")")
      xlab1 <- areamappara[j,2]
      titlename <- areamappara$Class[j]
      plot_TPES.1 <- plot.1(X3,X4,ylab1,xlab1,titlename,colorpal)
      outname <- paste0(outputdir,rr,"/",X2,"/",areamappara[j,1],".png")
      ggsave(plot_TPES.1, file=outname, dpi = 450, width=9, height=floor((length(unique(X3$SCENARIO))+length(unique(X3$Model)))/4+1)*3+2,limitsize=FALSE)
      allplotcge.tmp <- list(plot_TPES.1)
      names(allplotcge.tmp) <- paste0(rr,areamappara[j,1])
      XXX <- c(XXX,allplotcge.tmp)
    }
    return(XXX)
  }
  allmodel_def <- allmodel %>% filter(Model=="Default" & NDC!="on" & Y>=2015) %>% inner_join(ScenarioOrder)     
  allmodel_hist <- allmodel %>% filter(Model=="Reference")      
  allplotcge <- plot_all(allmodel_def,allmodel_hist,"png")
  allmodel_def <- allmodel %>% filter(SCENARIO=="1000C" & NDC!="on" & Y>=2015) %>% inner_join(ScenarioOrder)    
  allplotcge_dif <- plot_all(allmodel_def,allmodel_hist,"var")

  allmodel_def <- allmodel %>% filter(Model=="Integration(IST)" & NDC!="on" & Y>=2015) %>% inner_join(ScenarioOrder)     
  allmodel_hist <- allmodel %>% filter(Model=="Reference")      
  allplotcge_Integration <- plot_all(allmodel_def,allmodel_hist,"Fullcomb")
  
}

#---- time-series of multi carbon budgets
TimeSeriesCarb <- function(Y,X,Rg){
  p0 <- ggplot() + 
    geom_line(data=Y,aes(x=Y, y = Value , color=reorder(ScenarioOrder,SCENARIO),group=interaction(SCENARIO,Model)),stat="identity") +
    geom_point(data=Y,aes(x=Y, y = Value , color=reorder(ScenarioOrder,SCENARIO),shape=Model),size=3.0,fill="white") +
    MyThemeLine + scale_color_manual(values=linepalette) + scale_x_continuous(breaks=seq(miny,maxy,10)) +
    xlab("year") + ylab(varlist$V3[varlist$V1==X])  +  ggtitle(paste(rr,varlist$V2.y[varlist$V1==X],sep=" ")) +
    annotate("segment",x=2010,xend=maxy,y=0,yend=0,linetype="dashed",color="grey")+ 
    theme(legend.title=element_blank()) 
  return(p0)
}

TimeSeriesModel <- function(Y,X,Rg){
  p0 <- ggplot() + 
    geom_line(data=Y,aes(x=Y, y = Value , color=Model,group=interaction(SCENARIO,Model)),stat="identity") +
    geom_point(data=Y,aes(x=Y, y = Value , color=Model,shape=Model),size=3.0,fill="white") +
    MyThemeLine + scale_color_manual(values=linepalette) + scale_x_continuous(breaks=seq(miny,maxy,10)) +
    xlab("year") + ylab(varlist$V3[varlist$V1==X])  +  ggtitle(paste(rr,varlist$V2.y[varlist$V1==X],sep=" ")) +
    annotate("segment",x=2010,xend=maxy,y=0,yend=0,linetype="dashed",color="grey")+ 
    theme(legend.title=element_blank()) 
  return(p0)
}
dataextfunc <- function(XN,YN){
  return(allmodel %>% filter(Model %in% XN & NDC!="on" & Y>=2010 & Variable==YN & Region==Rg & Indicator=="abs") %>% inner_join(ScenarioOrder))  
}

Rg <- "World"
#---GDP loss for integration
VName1 <- "Pol_Cos_GDP_Los_rat"
ModelList <- c("Integration(IST)") 
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("GDPLossratIntegration(IST)"=plot.0))
FigdataList <- c(FigdataList,list("GDPLossratIntegration(IST)"=allmodel_def))

#---Energy demand for EDC
VName1 <- "Fin_Ene"
ModelList <- c("EnergyDemand(EDC)","Default")
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Fin_Ene_EDC"=plot.0))
FigdataList <- c(FigdataList,list("Fin_Ene_EDC"=allmodel_def))

VName1 <- "Ele_rat_Ele"
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Ele_rat_Ele_EDC"=plot.0))
FigdataList <- c(FigdataList,list("Ele_rat_Ele_EDC"=allmodel_def))

#---Food related for FTS
VName1 <- "Foo_Ene_Sup_Liv_Per_Cap"
ModelList <- c("Food(FST)","Default")
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Foo_Ene_Sup_Liv_Per_Cap_FST"=plot.0))
FigdataList <- c(FigdataList,list("Foo_Ene_Sup_Liv_Per_Cap_FST"=allmodel_def))

VName1 <- "Fod_Wst"
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Fod_Wst_FST"=plot.0))
FigdataList <- c(FigdataList,list("Fod_Wst_FST"=allmodel_def))

#---Capital stock for GI
VName1 <- "Cap_Sto"
ModelList <- c("Investment(AI)","Default")
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Cap_sto_GI"=plot.0))
FigdataList <- c(FigdataList,list("Cap_sto_GI"=allmodel_def))

#---Capital Cost for ESC
VName1 <- "Cap_Cos_Ele_SolarPV"
ModelList <- c("EnergySupply(ESC)","Default")
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Cap_Cos_Ele_SolarPV_ESC"=plot.0))
FigdataList <- c(FigdataList,list("Cap_Cos_Ele_SolarPV_ESC"=allmodel_def))

VName1 <- "Cap_Cos_Ele_Win_Ons"
ModelList <- c("EnergySupply(ESC)","Default")
allmodel_def <- dataextfunc(ModelList,VName1)
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
FigList <- c(FigList,list("Cap_Cos_Ele_WinOns_ESC"=plot.0))
FigdataList <- c(FigdataList,list("Cap_Cos_Ele_WinOns_ESC"=allmodel_def))

#---- decomposition
Decomp4fig <- filter(Decomp0,decele %in% c("va","fd_output","output_va","residual","fd") & Region=="World" & Indicator=="dif" & Y %in% c(2100,2050) & SCENARIO %in% c("500C","1000C") & NDC=="off")
dec_fig_func <- function(X1,X2){
  p0 <- ggplot() + 
    geom_bar(data=X1,aes(x=reorder(AggSecCO2,AggSecOrd), y = Value *100, fill=reorder(DecName,DecOrd),group=SCENARIO),stat="identity") +
    geom_point(data=X2,aes(x=reorder(AggSecCO2,AggSecOrd), y = Value *100),shape=1,color="black",stat="identity") +
    MyThemeLine + scale_fill_manual(values=c(linepalette[1],linepalette[3],linepalette[5],linepalette[6]))  +
    xlab("Sector") + ylab("GDP recovery contribution (%)")  + 
    annotate("segment",x=0.5,xend=6.5,y=0,yend=0,linetype="dashed",color="grey")+ 
    theme(legend.title=element_blank(),legend.position="bottom")
  return(p0)
}

decfiglistall<-0
for(sc in c("500C","1000C")){
  for(yy in c(2050,2100)){
    Decomp4fig1 <- filter(Decomp4fig,decele!="fd" & Y==yy & SCENARIO==sc)
    Decomp4fig2 <- filter(Decomp4fig,decele=="fd" & Y==yy & SCENARIO==sc)
    plot.0 <- dec_fig_func(Decomp4fig1,Decomp4fig2)+facet_grid(~ Model)
    decfiglist <- list(plot.0)
    names(decfiglist) <- paste0(sc,"_",yy)
    
    if(length(decfiglistall)==0){
      decfiglistall <- c(decfiglist)
    }else{
      decfiglistall <- c(decfiglistall,decfiglist)
    }
    for(dec in unique(scenariomap$Model)){
      Decomp4fig1 <- filter(Decomp4fig,decele!="fd" & Y==yy & SCENARIO==sc & Model==dec)
      Decomp4fig2 <- filter(Decomp4fig,decele=="fd" & Y==yy & SCENARIO==sc & Model==dec)
      plot.0 <- dec_fig_func(Decomp4fig1,Decomp4fig2)
      decfiglist2 <- list(plot.0)
      decfigdataList.tmp <- list(rbind(Decomp4fig1,Decomp4fig2))
      names(decfiglist2) <- paste0("dec",sc,"_",dec,"_",yy)
      names(decfigdataList.tmp) <- paste0("dec",sc,"_",dec,"_",yy) 
      FigList <- c(FigList,decfiglist2)
      FigdataList <- c(FigdataList,decfigdataList.tmp)
      
    }
  }
}

#--- Inclusion of impact and air pollution
ScenarioTotcostOrder <- data.frame(c("500C","1000C","1400C"),c("0500","1000","1400")) 
Factorlabel <- data.frame(c("AirPolBenefit","CCImpact","DefaultMitCost","STBenefitMitCost","Total"),c("3 Air pollution mortality change","4 Climate change impacts","1 Mitigation cost in default scenarios","2 Benefit of social transformation in mitigation cost","5 Total")) 
names(ScenarioTotcostOrder)<- c("SCENARIO","ScenarioTotcostOrder")
names(Factorlabel)<- c("Variable","Vlabel")
Rg <- c("World","R5OECD90+EU","R5REF","R5ASIA","R5MAF","R5LAM")
yearlist <- c("2030","2050","2100")
plotdata <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat_NPV_3pc","Clm_Chn_Imp_GDP_los_rat_NPV_3pc_Rel_BaU","Air_Pol_Imp_GDP_los_rat_NPV_3pc_Rel_BaU")  & NDC!="on" & Indicator=="abs" & Indicator=="abs"& Model!="Reference"& Region %in% Rg) 
#plotdata2 <- spread(plotdata1,value=Value,key=Model)
plotdata1 <- left_join(plotdata,filter(plotdata,Model=="Default") %>% select(-Model) %>% rename(Value2=Value)) %>% filter(Model=="Default" & Variable=="Air_Pol_Imp_GDP_los_rat_NPV_3pc_Rel_BaU") %>% select(-Value) %>% rename(Value=Value2)
plotdata2 <- left_join(plotdata,filter(plotdata,Model=="Default") %>% select(-Model) %>% rename(Value2=Value)) %>% filter(Model!="Default" & Variable=="Pol_Cos_GDP_Los_rat_NPV_3pc")
plotdata2$STBenefitMitCost <- plotdata2$Value-plotdata2$Value2
plotdata2.1 <- plotdata2 %>% select(-Value,-Value2,-Variable) %>%  rename(Value2=STBenefitMitCost)
plotdata2.2 <- filter(plotdata,Model=="Default" & Variable=="Pol_Cos_GDP_Los_rat_NPV_3pc") %>% select(-Variable,-Model) 
plotdata2.3 <- left_join(plotdata2.1,plotdata2.2) %>% rename(STBenefitMitCost=Value2,DefaultMitCost=Value) %>% left_join(select(plotdata1,-Model,-Variable)) %>% rename(AirPolBenefit=Value) %>% gather(key="Variable",value="Value",-Region,-Y,-Indicator,-SCENARIO,-Model,-NDC) 
plotdata3 <- rbind(plotdata %>% filter(Model!="Default" & Variable!="Pol_Cos_GDP_Los_rat_NPV_3pc" & Variable!="Air_Pol_Imp_GDP_los_rat_NPV_3pc_Rel_BaU"),plotdata2.3) %>% filter(SCENARIO %in% ScenarioTotcostOrder$SCENARIO)
#Get total
plotdata4 <-plotdata3 %>%  spread(value=Value,key=Variable) %>% rename(CCImpact=Clm_Chn_Imp_GDP_los_rat_NPV_3pc_Rel_BaU)
plotdata4$Total <- plotdata4$DefaultMitCost+plotdata4$STBenefitMitCost+plotdata4$CCImpact+plotdata4$AirPolBenefit
plotdata5 <- gather(plotdata4,key="Variable",value="Value",-Region,-Y,-Indicator,-SCENARIO,-Model,-NDC) %>% filter(SCENARIO %in% ScenarioTotcostOrder$SCENARIO) %>% left_join(Factorlabel) %>%
  filter(Y %in% yearlist & Model=="Integration(IST)")%>% left_join(ScenarioTotcostOrder)
plotg.1 <-ggplot()+ 
  geom_bar(data=filter(plotdata5,Vlabel!="5 Total"),aes(x=reorder(ScenarioTotcostOrder,SCENARIO), y = Value, fill=Vlabel,group=SCENARIO),stat="identity") +
  geom_point(data=filter(plotdata5,Vlabel=="5 Total"),aes(x=reorder(ScenarioTotcostOrder,SCENARIO), y = Value),shape=1,color="black",stat="identity") +
  MyThemeLine + scale_fill_manual(values=c(linepalette[3],linepalette[1],linepalette[5],linepalette[6]))  +
  xlab("Mitigation levels expressed by carbon budgets") + ylab("Economic loss (positive) and gain (negative) (%)")  + 
  annotate("segment",x=0.5,xend=3.5,y=0,yend=0,linetype="dashed",color="grey") + coord_flip() + 
  theme(legend.title=element_blank(),legend.position="bottom") + guides(fill=guide_legend(nrow=2,byrow=TRUE)) + 
  theme(strip.text = element_text(size = 6)) + facet_grid(Region~Y, scales ="free_y")         
FigList <- c(FigList,list('AirClmAllNPV'=plotg.1))
FigdataList <- c(FigdataList,list('AirClmAllNPV'=plotdata5))

ScenarioTotcostOrder <- data.frame(c("Baseline","500C","1000C","1400C"),c("Baseline","0500","1000","1400")) 
names(ScenarioTotcostOrder)<- c("SCENARIO","ScenarioTotcostOrder")
Factorlabel <- data.frame(c("Pol_Cos_GDP_Los_rat","Clm_Chn_Imp_GDP_los_rat","Air_Pol_Imp_GDP_los_rat"),c("1 Climate change mitigation cost","2 Climate change impacts","3 Air pollution mortality change impacts")) 
names(Factorlabel)<- c("Variable","Vlabel")
yearlist <- c("2015","2020","2030","2050","2100")
plotdata <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat","Clm_Chn_Imp_GDP_los_rat","Air_Pol_Imp_GDP_los_rat")  & NDC!="on" & Indicator=="abs"& Model!="Reference"& Region %in% Rg) 
plotdata_air <- filter(plotdata,Variable %in% c("Air_Pol_Imp_GDP_los_rat")  & Model=="Default") %>% select(-Model) %>% mutate(Model="Integration(IST)")
plotdata1 <- rbind(plotdata,plotdata_air) %>% filter(Y %in% yearlist & ((Model=="Integration(IST)" & SCENARIO %in% ScenarioTotcostOrder$SCENARIO) | SCENARIO=="Baseline")) %>% left_join(Factorlabel) %>% left_join(ScenarioTotcostOrder)
plotg.1 <-ggplot()+ 
  geom_line(data=plotdata1,aes(x=Y, y = Value, color=Vlabel,group=Variable),stat="identity") +
  geom_point(data=plotdata1,aes(x=Y, y = Value, color=Vlabel,group=Variable),alpha=1,shape=21,size=1.0,fill="white") + 
  MyThemeLine + scale_color_manual(values=c(linepalette[1],linepalette[5],linepalette[6]))  +
  xlab("Year") + ylab("Economic loss (positive) and gain (negative) (%)")  + 
  annotate("segment",x=2020,xend=2100,y=0,yend=0,linetype="dashed",color="grey") +  
  theme(legend.title=element_blank(),legend.position="bottom") + guides(color=guide_legend(nrow=2,byrow=TRUE)) + 
  theme(strip.text = element_text(size = 10)) + facet_grid(Region~ScenarioTotcostOrder, scales ="free_y")
FigList <- c(FigList,list('AirClmAll'=plotg.1))
FigdataList <- c(FigdataList,list('AirClmAll'=plotdata1))

##Air pollution ralted things
vlist <- c("Pop_Mor_AP","Air_Pol_Imp_GDP_los_rat","Con_PM25_Pop_Wei")
for(vl in vlist){
  yearlist <- c("2015","2020","2030","2050","2100")
  allmodel_def <- allmodel %>% filter(Model %in% c("Default","Integration(IST)") & Y %in% yearlist & Variable %in% vl & Region %in% Rg & Indicator=="abs" & SCENARIO %in% c("Baseline",ScenarioTotcostOrder$SCENARIO) & NDC!="on") %>% inner_join(ScenarioOrder)
  VName1 <- vl
  plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
  plot.1 <- plot.0 + facet_grid(~Region, scales ="free_y")
  eval(parse(text=paste0("FigList <- c(FigList,list('",vl,"'=plot.1))")))
  eval(parse(text=paste0("FigdataList <- c(FigdataList,list('",vl,"'=allmodel_def))")))
}

for(vl in vlist){
  yearlist <- c("2015","2020","2030","2050","2100")
  allmodel_def <- allmodel %>% filter(Model %in% c("Default","Integration(IST)") & Y %in% yearlist & Variable %in% vl & Region %in% Rg & Indicator=="abs" & SCENARIO %in% c("1000C") & NDC!="on") %>% inner_join(ScenarioOrder)
  VName1 <- vl
  plot.0 <- TimeSeriesModel(allmodel_def,VName1,Rg)
  plot.1 <- plot.0 + facet_grid(~Region, scales ="free_y")
  eval(parse(text=paste0("FigList <- c(FigList,list('",vl,"ISTcomp'=plot.1))")))
  eval(parse(text=paste0("FigdataList <- c(FigdataList,list('",vl,"ISTcomp'=allmodel_def))")))
}

allmodel_def <- allmodel %>% filter(Model %in% c("Default","Integration(IST)") & Y>=2010 & Variable %in% c("Clm_Chn_Imp_GDP_los_rat") & Region %in% Rg & Indicator=="abs" & SCENARIO %in% c("Baseline",ScenarioTotcostOrder$SCENARIO) & NDC!="on") %>% inner_join(ScenarioOrder)
VName1 <- "Clm_Chn_Imp_GDP_los_rat"
plot.0 <- TimeSeriesCarb(allmodel_def,VName1,Rg)
plot.1 <- plot.0 + facet_wrap(~Region, ncol=3,scales ="free_y")
eval(parse(text=paste0("FigList <- c(FigList,list('",VName1,"'=plot.1))")))
eval(parse(text=paste0("FigdataList <- c(FigdataList,list('",VName1,"'=allmodel_def))")))

#---- Merge plots
source("plotmerge.R")

#source("dataload.r")


