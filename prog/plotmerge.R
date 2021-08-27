#---- This file is to merge plots and excel outpu 
dir.create(paste0("../output/4paper"))
dir.create(paste0("../output/vector"))
dir.create(paste0("../output/data"))
alphabet <- c("a","b","c","d","e","f","g","h","i","j","k","l","m","n")

#---- excel
# workbookオブジェクトの作成
options( java.parameters = "-Xmx4g" )
xlslist <- read.table("../data/Excellist.txt", sep="\t",header=F, stringsAsFactors=F)
wb <- createWorkbook(type="xlsx")
for(xl in xlslist$V1){
  sheet <- createSheet(wb, sheet=xlslist$V2[xlslist==xl])  # シート名が"sheet1"であるsheetオブジェクトの作成
  addDataFrame(FigdataList[[xl]], sheet, startColumn=1)  # sheetオブジェクトにデータフレームを入力
}
saveWorkbook(wb, file="../output/data/Figure.xlsx") # Excelファイルを出力


#1) Policy cost
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["GDPLoss_CO2"]]), pattern = "guide-box")
pp0.1 <- plot_grid(NULL,FigList[["GDPLoss_CO2"]] + theme(legend.position="none"),NULL,FigList[["GDPLoss_Kyotogas"]] + theme(legend.position="none"),p_legend1,ncol=5,rel_widths =c(0.1,1,0.1,1,0.5),align = "hv")
pp0.2 <- plot_grid(FigList[["GDPLoss_timeseries"]],NULL,ncol=2,rel_widths =c(1,0.67),align = "h")
pp0.3 <- plot_grid(FigList[["GDP_loss_Dif"]]+ggtitle(""),FigList[["GDPLossratIntegration(IST)"]]+ggtitle(""),ncol=2,rel_widths =c(1,0.8))
pp0 <- plot_grid(pp0.1,pp0.2,pp0.3,ncol=1,align = "hv",rel_heights =c(1,1,1)) +  
  draw_plot_label(label = alphabet[1:5], size = 12,x = c(0,1/2,0,0,0.5), y = c(1, 1,0.67,0.33,0.33))
ggsave(pp0, file=paste0("../output/4paper/fig1",".png"),width=10, height=12,limitsize=FALSE)
ggsave(pp0, file=paste0("../output/vector/fig1.svg"), width=10, height=12,limitsize=FALSE)


#Decomposition figure
#---- load icon
iconlist <- read.table("../data/iconlist.txt", sep="\t",header=T, stringsAsFactors=F)
arrowpos <- read.table("../data/arrowposition.txt", sep="\t",header=F, stringsAsFactors=F)
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["dec1000C_EnergyDemand(EDC)_2100"]] +guides(fill=guide_legend(nrow=2))), pattern = "guide-box")
p_legend2 <- gtable::gtable_filter(ggplotGrob(FigList[["Cap_Cos_Ele_WinOns_ESC"]]+guides(shape=FALSE) +guides(color=guide_legend(nrow=3))+theme(legend.position="bottom")), pattern = "guide-box")
p_legend3 <- gtable::gtable_filter(ggplotGrob(FigList[["Fin_Ene_EDC"]]+guides(color=FALSE) +guides(shape=guide_legend(nrow=1))+theme(legend.position="bottom")), pattern = "guide-box")
p_legend4 <- gtable::gtable_filter(ggplotGrob(FigList[["Cap_Cos_Ele_WinOns_ESC"]]+guides(color=FALSE) +guides(shape=guide_legend(nrow=1))+theme(legend.position="bottom")), pattern = "guide-box")
p_legend5 <- gtable::gtable_filter(ggplotGrob(FigList[["Fod_Wst_FST"]]+guides(color=FALSE) +guides(shape=guide_legend(nrow=1))+theme(legend.position="bottom")), pattern = "guide-box")
p_legend6 <- gtable::gtable_filter(ggplotGrob(FigList[["Cap_sto_GI"]]+guides(color=FALSE) +guides(shape=guide_legend(nrow=1))+theme(legend.position="bottom")), pattern = "guide-box")

pp1.1 <- plot_grid(
  FigList[["dec1000C_Investment(GI)_2100"]]+ theme(legend.position="none"),NULL,FigList[["dec1000C_EnergySupply(ESC)_2100"]]+ theme(legend.position="none"),NULL,FigList[["dec1000C_EnergyDemand(EDC)_2100"]]+ theme(legend.position="none"),NULL,
  FigList[["dec1000C_Food(FST)_2100"]]+ theme(legend.position="none"),NULL,FigList[["dec1000C_Integration(IST)_2100"]]+ theme(legend.position="none"),
  ncol=1,nrow=9,rel_heights =c(1,0.15,1,0.15,1,0.15,1,0.15,1))
pp1.2.1 <- plot_grid(FigList[["Fin_Ene_EDC"]]+ggtitle("")+ theme(legend.position="none"),FigList[["Ele_rat_Ele_EDC"]]+ggtitle("")+theme(legend.position="none"),nrow=1)
pp1.2.2 <- plot_grid(FigList[["Cap_Cos_Ele_SolarPV_ESC"]]+ theme(legend.position="none")+ggtitle(""),FigList[["Cap_Cos_Ele_WinOns_ESC"]]+ggtitle("")+theme(legend.position="none"),nrow=1,align = "hv")
pp1.2.3 <- plot_grid(FigList[["Foo_Ene_Sup_Liv_Per_Cap_FST"]]+ theme(legend.position="none")+ggtitle(""),FigList[["Fod_Wst_FST"]]+ggtitle("")+ theme(legend.position="none"),nrow=1,align = "hv")
pp1.2.4 <- plot_grid(FigList[["Cap_sto_GI"]]+ theme(legend.position="none")+ggtitle(""),NULL,nrow=1,align = "hv")
pp1.2 <- plot_grid(pp1.2.4,p_legend6,NULL,pp1.2.2,p_legend4,NULL,pp1.2.1,p_legend3,NULL,pp1.2.3,p_legend5,p_legend2,NULL,p_legend1,NULL,ncol=1,nrow=15,
                   rel_heights =c(0.9,0.1,0.10,0.9,0.1,0.10,0.9,0.1,0.10,0.9,0.1,0.3,0.3,0.2,0.2))
garr1 <- list()
for(i in 1:nrow(arrowpos)){
  garr1[[i]] <- grid::curveGrob(arrowpos[i,1], arrowpos[i,2], arrowpos[i,3], arrowpos[i,4],curvature=0, gp=gpar(fill="black"),arrow=arrow(type="closed", length=unit(3,"mm")))
}
xposfig1 <- c(0.25,0.25,0.45,0.25,0.45,0.25,0.45,0.65,0.65,0.65,0.65,0.65)
panelnote <- c("Capital Formation","SolarPV cost","Wind power cost","Energy demand","Electrification rate","food consumption","Food waste")
pp1 <- plot_grid(NULL,NULL,pp1.2,NULL,pp1.1,nrow=1,rel_widths =c(0.5,0.25,1.1,0.25,1)) +  
  draw_plot_label(label = alphabet[1:12], size = 12,x = xposfig1, y = c(1, 0.81, 0.81,0.60,0.60,0.40,0.40,1,0.81,0.60,0.40,0.22))+
  draw_plot_label(label = panelnote[1:7], size = 12,hjust = 0, x = xposfig1[1:7]+0.03,fontface="plain", y = c(1, 0.81, 0.81,0.60,0.60,0.40,0.40))+
  draw_grob(garr1[[1]])+draw_grob(garr1[[2]])+draw_grob(garr1[[3]])+draw_grob(garr1[[4]])+
  draw_grob(garr1[[5]])+draw_grob(garr1[[6]])+draw_grob(garr1[[7]])+draw_grob(garr1[[8]])+draw_grob(garr1[[9]])+
  draw_text(c("   Green Investment (GI)","Energy Supply Change (ESC)","Energy Demand Change (EDC)","Food System Transformation (FST)","Integration of Social Transformation (IST)"), size = 15,x = c(0.00,0.00,0.00,0.00,0), hjust=-0.1,vjust=0,y = c(0.84,0.64,0.44,0.22,0.02))

sizex <- c(15,22,0.15)
for(ii in iconlist$Name){
  if(ii!="integrate.png"){
    image1 <- readJPEG(paste0("../data/icon/",iconlist$Name[iconlist$Name==ii]))
  }else{
    image1 <- readPNG(paste0("../data/icon/",iconlist$Name[iconlist$Name==ii]))
  }
  pp1 <- pp1  + annotation_raster(image1, xmin = iconlist$x[iconlist$Name==ii], xmax = iconlist$x[iconlist$Name==ii]+sizex[3], ymin = iconlist$y[iconlist$Name==ii]-sizex[3]*sizex[1]/sizex[2], ymax = iconlist$y[iconlist$Name==ii])
}  
ggsave(pp1, file=paste0("../output/4paper/fig2",".png"), width=sizex[1], height=sizex[2],limitsize=FALSE)

#3) Regional implications
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["ShareValAdd_agr"]]), pattern = "guide-box")
pp2.1 <- plot_grid(FigList[["Region1"]]+ggtitle(""), FigList[["Intensity"]],ncol=2,rel_widths =c(2,2),align = "hv")
pp2.2 <- plot_grid(FigList[["ShareValAdd_ind"]]+ theme(legend.position="none"),FigList[["ShareValAdd_agr"]]+ theme(legend.position="none"),p_legend1,ncol=3,rel_widths =c(1.0,1.0,0.3),align = "h")
pp2 <- plot_grid(FigList[["GDPLoss_NPV_Region"]],pp2.1,pp2.2,ncol=1,rel_heights =c(1.5,1.0,1)) +  
  draw_plot_label(label = alphabet[1:5], size = 12,x = c(0,0,0.5,0,0.5), y = c(1, 0.58, 0.58,0.30,0.30))
ggsave(pp2, file=paste0("../output/4paper/fig3.png"), dpi = 250, width=11, height=15,limitsize=FALSE)
ggsave(pp2, file=paste0("../output/vector/fig3.svg"), dpi = 250, width=11, height=15,limitsize=FALSE)

#4) NDC and discount rates
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["NPV_NDC"]]), pattern = "guide-box")
pp3.1 <- plot_grid(FigList[["NPV_NDC"]]+ theme(legend.position="none"),FigList[["NPV_regopm"]]+ theme(legend.position="none"),p_legend1,ncol=3,rel_widths =c(1,1,0.4),align = "hv")
pp3 <- plot_grid(FigList[["GDPLoss_DisCount"]],pp3.1,ncol=1,rel_heights =c(0.8,1)) +  
  draw_plot_label(label = alphabet[1:5], size = 12,x = c(0,0.30,0.60,0,0.5), y = c(1, 1, 1,0.55,0.55))

ggsave(pp3, file=paste0("../output/4paper/fig4.png"), width=12, height=10,limitsize=FALSE)
ggsave(pp3, file=paste0("../output/vector/fig4.svg"), width=12, height=10,limitsize=FALSE)
write.xlsx(FigdataList[["GDPLoss_DisCount_1"]], file = "../output/data/Figure.xlsx", sheetName="Fig4abc1",append = FALSE, row.names=FALSE)
write.xlsx(FigdataList[["GDPLoss_DisCount_2"]], file = "../output/data/Figure.xlsx", sheetName="Fig4abc2",append = FALSE, row.names=FALSE)
write.xlsx(FigdataList[["NPV_regopm"]], file = "../output/data/Figure.xlsx", sheetName="Fig4d",append = FALSE, row.names=FALSE)
write.xlsx(FigdataList[["NPV_NDC"]], file = "../output/data/Figure.xlsx", sheetName="Fig4e",append = FALSE, row.names=FALSE)

#X1) literature GDP loss
ggsave(FigList[["GDPLoss_timeseries_lit"]], file=paste0("../output/4paper/figX1.png"), width=5, height=4,limitsize=FALSE)
ggsave(FigList[["GDPLoss_timeseries_lit"]], file=paste0("../output/vector/figX1.svg"), width=5, height=4,limitsize=FALSE)

#X2) GDP loss
ppX1 <- plot_grid(allplotcge[["WorldPol_Cos_GDP_Los"]],allplotcge[["WorldPol_Cos_GDP_Los_rat"]],ncol=2,rel_heights =c(1,1)) +  
  draw_plot_label(label = alphabet[1:2], size = 12,x = c(0,0.5), y = c(1, 1))
ggsave(ppX1, file=paste0("../output/4paper/figX2.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX1, file=paste0("../output/vector/figX2.svg"), width=10, height=4,limitsize=FALSE)

#X3) CO2 emissions
ppX2 <- plot_grid(allplotcge[["WorldEmi_CO2"]],allplotcge[["WorldEmi_Kyo_Gas"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX2, file=paste0("../output/4paper/figX3.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX2, file=paste0("../output/vector/figX3.svg"), width=10, height=4,limitsize=FALSE)

#X4) TPES
ggsave(allplotcge[["WorldTPES"]], file=paste0("../output/4paper/figX4.png"), width=10, height=15,limitsize=FALSE)
ggsave(allplotcge[["WorldTPES"]], file=paste0("../output/vector/figX4.svg"), width=10, height=15,limitsize=FALSE)

#X5) Landuse
ggsave(allplotcge[["WorldLanduse"]], file=paste0("../output/4paper/figX5.png"), width=10, height=15,limitsize=FALSE)
ggsave(allplotcge[["WorldLanduse"]], file=paste0("../output/vector/figX5.svg"), width=10, height=15,limitsize=FALSE)

#X6) Climate
ppX6 <- plot_grid(allplotcge[["WorldTem_Glo_Mea"]],allplotcge_dif[["WorldTem_Glo_Mea"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX6, file=paste0("../output/4paper/figX6.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX6, file=paste0("../output/vector/figX6.svg"), width=10, height=4,limitsize=FALSE)

#X6_1) TPES by social transformation
ggsave(allplotcge_dif[["WorldTPES"]]+ggtitle(""), file=paste0("../output/4paper/figX6.1.png"), width=10, height=8,limitsize=FALSE)
ggsave(allplotcge_dif[["WorldTPES"]]+ggtitle(""), file=paste0("../output/vector/figX6.1.svg"), width=10, height=8,limitsize=FALSE)

#X6_2) Non-CO2 emissions 
ppX62 <- plot_grid(allplotcge_dif[["WorldEmi_CH4"]],allplotcge_dif[["WorldEmi_N2O"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX62+ggtitle(""), file=paste0("../output/4paper/figX6.2.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX62+ggtitle(""), file=paste0("../output/vector/figX6.2.svg"), width=10, height=4,limitsize=FALSE)

#X7) Carbon prices
ppX7 <- plot_grid(allplotcge[["WorldPrc_Car"]],allplotcge_dif[["WorldPrc_Car"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX7, file=paste0("../output/4paper/figX7.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX7, file=paste0("../output/vector/figX7.svg"), width=10, height=4,limitsize=FALSE)

#X8) NPV consumption loss 
ppX8 <- plot_grid(FigList[["Pol_Cos_Cns_Los_rat_NPV_3pc"]]+ggtitle("")+ylab("Cumulative consumption loss rates in NPV (%)"),allplotcge_dif[["WorldPol_Cos_Cns_Los_rat"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX8, file=paste0("../output/4paper/figX8.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX8, file=paste0("../output/vector/figX8.svg"), width=10, height=4,limitsize=FALSE)

#X9) Final energy and electricity 
ppX9 <- plot_grid(decfiglist[["1000C_2050"]],decfiglist[["1000C_2100"]],decfiglist[["500C_2100"]],ncol=1,rel_heights =c(1,1)) +
  draw_plot_label(label = alphabet[1:3], size = 12,x = c(0,0,0), y = c(1, 0.67, 0.33))
ggsave(ppX9, file=paste0("../output/4paper/figX9.png"), width=10, height=12,limitsize=FALSE)
ggsave(ppX9, file=paste0("../output/vector/figX9.svg"), width=10, height=12,limitsize=FALSE)

