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
library(RDCOMClient)

OrRdPal <- brewer.pal(9, "OrRd")
set2Pal <- brewer.pal(8, "Set2")
YlGnBupal <- brewer.pal(9, "YlGnBu")
Redspal <- brewer.pal(9, "Reds")
pastelpal <- brewer.pal(9, "Pastel1")
pastelpal <- brewer.pal(8, "Set1")

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
system(paste("gams Greengrowth.gms",sep=" "))

linepalette <- c("#4DAF4A","#FF7F00","#377EB8","#E41A1C","#984EA3","#F781BF","#8DD3C7","#FB8072","#80B1D3","#FDB462","#B3DE69","#FCCDE5","#D9D9D9","#BC80BD","#CCEBC5","#FFED6F","#7f878f","#A65628","#FFFF33")
landusepalette <- c("#8DD3C7","#FF7F00","#377EB8","#4DAF4A","#A65628")
scenariomap <- read.table("../data/scenariomap.map", sep="\t",header=T, stringsAsFactors=F)
scenariomap2 <- read.table("../data/scenariomap2.map", sep="\t",header=T, stringsAsFactors=F)
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

#---IAMC tempalte loading and data merge
CGEload0 <- rgdx.param(paste0('../modeloutput/global_17_emf_diff.gdx'),'IAMCTemplate') 
Getregion <- as.vector(unique(CGEload0$REMF))
if(length(Getregion)==1){region <- Getregion}
allmodel0 <- CGEload0 %>% rename("Value"=IAMCTemplate,"Variable"=VEMF) %>% 
  left_join(scenariomap,by="SCENARIO") %>% filter(SCENARIO %in% as.vector(scenariomap[,1]) & REMF %in% region) %>% 
  select(-SCENARIO) %>% rename(Region="REMF",SCENARIO="Name",Indicator=".i5")

file.copy(paste0(fileloc,"AIMCGE/individual/IEAEB1062CGE/output/IEAEBIAMCTemplate.gdx"), paste0("../data/IEAEBIAMCTemplate.gdx"),overwrite = TRUE)
IEAEB0 <- rgdx.param('../data/IEAEBIAMCTemplate.gdx','IAMCtemp17') %>% rename("Value"=IAMCtemp17,"Variable"=VEMF,"Y"=St,"Region"=Sr17,"SCENARIO"=SceEneMod) %>%
  select(Region,Variable,Y,Value,SCENARIO) %>% filter(Region %in% region) %>% mutate(Model="Reference")
IEAEB0$Y <- as.numeric(levels(IEAEB0$Y))[IEAEB0$Y]
IEAEB1 <- filter(IEAEB0,Y<=2015 & Y>=1990) %>% mutate(Indicator="abs")

allmodel0$Y <- as.numeric(levels(allmodel0$Y))[allmodel0$Y]
allmodel <- rbind(allmodel0,IEAEB1)  

#---function
plot.1 <- function(XX,Xylab1,Xxlab1,Xtitle,Xcolorpal){
  plot <- ggplot() + 
    geom_area(data=XX,aes(x=Y, y = Value , fill=reorder(Ind,-order)), stat="identity") + 
    ylab(Xylab1) + xlab(Xxlab1) +labs(fill="")+ guides(fill=guide_legend(reverse=TRUE)) + MyThemeLine +
    theme(legend.position="bottom", text=element_text(size=12),  
          axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
    guides(fill=guide_legend(ncol=5)) + scale_x_continuous(breaks=seq(miny,maxy,10)) +  ggtitle(paste(rr,Xtitle,sep=" "))
  
  plot2 <- plot +facet_wrap(Model ~ SCENARIO,ncol=4) + scale_fill_manual(values=Xcolorpal) + 
    annotate("segment",x=miny,xend=maxy,y=0,yend=0,linetype="solid",color="grey") + theme(legend.position='bottom')
  if(nrow(XX)>=1){
    plot3 <- plot2 +    geom_area(data=XX2,aes(x=Y, y = Value , fill=reorder(Ind,-order)), stat="identity")
  }else{
    plot3 <- plot2
  }
  return(plot3)
}

#---IAMC tempalte loading and data mergeEnd
region <- c("World")
nalist <- c(as.vector(varlist$V1),"TPES","POWER","Power_heat","Landuse","TFC_fuel","TFC_Sector","TFC_Ind","TFC_Tra","TFC_Res","TFC_Com")
allplot <- as.list(nalist)
plotflag <- as.list(nalist)
names(allplot) <- nalist
names(plotflag) <- nalist


for(rr in region){
  dir.create(paste0("../output/",rr))
  dir.create(paste0("../output/",rr,"/png"))
  dir.create(paste0("../output/",rr,"/pngdet"))
  dir.create(paste0("../output/",rr,"/ppt"))
  dir.create(paste0("../output/",rr,"/dif"))
  dir.create(paste0("../output/",rr,"/var"))
  maxy <- max(allmodel$Y)

#---Difference figure  
  plodata <- filter(allmodel,Variable=="Pol_Cos_GDP_Los_rat" & Model!="Reference"& Region==rr & Indicator=="dif" & SCENARIO=="1000C")
  plot <- ggplot() + 
    geom_area(data=filter(plodata,Model!="FullComb"),aes(x=Y, y = Value , fill=Model), stat="identity") + 
    ylab("GDP loss rate differences (%) ") + xlab("Year") +labs(fill="")+ guides(fill=guide_legend(reverse=TRUE)) + MyThemeLine +
    geom_line(data=filter(plodata,Model=="FullComb"),aes(x=Y, y = Value ), stat="identity") + scale_fill_manual(values=pastelpal) + 
    theme(legend.position="bottom", text=element_text(size=12),  
          axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
    guides(fill=guide_legend(ncol=1)) + scale_x_continuous(breaks=seq(miny,maxy,10)) +  ggtitle(paste(rr,"GDP loss rate differences from Default",sep=" ")) +
    annotate("segment",x=miny,xend=maxy,y=0,yend=0,linetype="solid",color="grey") + theme(legend.position='right')
  outname <- paste0(outputdir,rr,"/dif/GDP_loss.png")
  ggsave(plot, file=outname, dpi = 150, width=10, height=6,limitsize=FALSE)

  plotvarlist <- c("Pol_Cos_GDP_Los_rat_NPV","Inv_Ene_Sup","Inv_Ene_Dem_Eff_and_Dec")
  for(jj in plotvarlist){
    plodata <- filter(allmodel,Variable %in% c("Emi_CO2_Cum",jj) & Model %in% c("FullComb","Def") & Region==rr & Indicator=="abs") %>% 
      spread(key=Variable,value=Value) %>%    rename("VV"=jj)
    plot <- ggplot() + 
      geom_point(data=filter(plodata,Y==2100),aes(x=Emi_CO2_Cum/1000, y = VV,color=Model ), stat="identity",size=15) + scale_color_manual(values=pastelpal) + 
      ylab(paste0(varalllist[varalllist$V1==jj,2]," ",varalllist[varalllist$V1==jj,3])) + xlab("Carbon budget 2011-2100 (GtCO2)") +labs(color="")+ guides(color=guide_legend(reverse=TRUE)) + MyThemeLine +
      theme(legend.position="bottom", text=element_text(size=12),axis.text.x=element_text(angle=45, vjust=0.9, hjust=1, size = 12)) +
      guides(fill=guide_legend(ncol=1)) +  ggtitle(paste(rr,varalllist[varalllist$V1==jj,2],sep=" ")) +theme(legend.position='right')
    outname <- paste0(outputdir,rr,"/dif/",jj,".png")
    ggsave(plot, file=outname, dpi = 150, width=7, height=7,limitsize=FALSE)
  } 
  
#---Line figures
  plot_all <- function(X1,X2,X3){
    for (i in 1:nrow(varlist)){
      if(nrow(filter(X1,Variable==varlist[i,1] & Region==rr & Indicator=="abs"))>0){
        miny <- min(filter(X1,Variable==varlist[i,1] & Region==rr)$Y) 
        plot.0 <- ggplot() + 
          geom_line(data=filter(X1,Variable==varlist[i,1] & Region==rr & Indicator=="abs"),aes(x=Y, y = Value , color=interaction(SCENARIO,Model),group=interaction(SCENARIO,Model)),stat="identity") +
          geom_point(data=filter(X1,Variable==varlist[i,1] & Region==rr & Indicator=="abs"),aes(x=Y, y = Value , color=interaction(SCENARIO,Model),shape=Model),size=3.0,fill="white") +
          MyThemeLine + scale_color_manual(values=linepalette) + scale_x_continuous(breaks=seq(miny,maxy,10)) +
          xlab("year") + ylab(varlist[i,4])  +  ggtitle(paste(rr,varlist[i,3],sep=" ")) +
          annotate("segment",x=2005,xend=maxy,y=0,yend=0,linetype="dashed",color="grey")+ 
          theme(legend.title=element_blank()) 
        if(length(scenariomap$SCENARIO)<20){
          plot.0 <- plot.0 +
          geom_point(data=filter(X1,Variable==varlist[i,1] & Model=="Reference"& Region==rr),aes(x=Y, y = Value) , color="black",shape=6,size=2.0,fill="grey") 
        }
        if(varlist[i,2]==1){
          outname <- paste0(outputdir,rr,"/",X2,"/",varlist[i,1],".png")
          ggsave(plot.0, file=outname, dpi = 150, width=10, height=6,limitsize=FALSE)
        }
      }
    }
#---Area figures
    for(j in 1:nrow(areamappara)){
      XXX <- X1 %>% filter(Variable %in% as.vector(areamap$Variable)) %>% left_join(areamap,by="Variable") %>% ungroup() %>% 
        filter(Class==areamappara[j,1] & Region==rr & Model!="Reference" & Indicator=="abs") %>% select(Model,SCENARIO,Ind,Y,Value,order)  %>% arrange(order)
      miny <- min(XXX$Y) 
      na.omit(XXX$Value)
      colorpal <- areapalette
      unit_name <-areamappara[j,3]
      ylab1 <- paste0(areamappara[j,2], " (", unit_name, ")")
      xlab1 <- areamappara[j,2]
      titlename <- areamappara$Class[j]
      plot_TPES.1 <- plot.1(XXX,ylab1,xlab1,titlename,colorpal)
      outname <- paste0(outputdir,rr,"/",X2,"/",areamappara[j,1],".png")
      ggsave(plot_TPES.1, file=outname, dpi = 450, width=9, height=floor((length(unique(XX$SCENARIO))+length(unique(XX$Model)))/4+1)*3+2,limitsize=FALSE)
    }
  }
  allmodel_def <- allmodel %>% filter(Model=="Def")     
  unloadfolder <- "png"
  plot_all(allmodel_def,unloadfolder)
  allmodel_def <- allmodel %>% filter(SCENARIO=="1000C")     
  unloadfolder <- "var"
  plot_all(allmodel_def,unloadfolder)
}

#---- Main figure parts
##---- NPV comparison with IPCC 
#---IAMC tempalte loading and data merge
IPCCSR15 <- rgdx.param(paste0('../modeloutput/CumulativeEmissions.gdx'),'NPV') 
IPCCSR15_v2 <- filter(IPCCSR15,Variable2 %in% c("Pol_Cos_GDP_Los_rat_NPV","Emi_CO2_Cum")) %>% select(-Unit) %>% spread(value=NPV,key=Variable2) 
allmodel_v2 <- filter(allmodel,Variable %in% c("Pol_Cos_GDP_Los_rat_NPV","Emi_CO2_Cum") & Y==2100) %>%  spread(value=Value,key=Variable) 

plot.0 <- ggplot() + 
  geom_point(data=filter(IPCCSR15_v2,Region=="World",Pol_Cos_GDP_Los_rat_NPV>=0),aes(x=Emi_CO2_Cum, y = Pol_Cos_GDP_Los_rat_NPV , color=Emi_CO2_Cum),shape=16,size=1.0,fill="white") +
  MyThemeLine + scale_color_gradient(low="green",high="red")+  
  xlab("Cumulative CO2 emissions from 2011 to 2100 (GtCO2)") + ylab("Net present value of cumulative GDP loss rates (%)")  +  ggtitle(paste("",sep=" ")) +
  theme(legend.title=element_blank()) 
plot.01 <- plot.0 +  
  geom_point(data=filter(allmodel_v2,Region=="World",Pol_Cos_GDP_Los_rat_NPV>=0),aes(x=Emi_CO2_Cum/1000, y = Pol_Cos_GDP_Los_rat_NPV,shape=Model),size=3.0,fill="white") +
  scale_shape_manual(values=c(21,22,23,24,25,20))
outname <- paste0(outputdir,"/main/GDPLoss.png")
ggsave(plot.01, file=outname, dpi = 150, width=10, height=6,limitsize=FALSE)
