#Merge plot
dir.create(paste0("../output/4paper"))
dir.create(paste0("../output/vector"))

alphabet <- c("a","b","c","d","e","f","g","h","i","j","k")
#1) Policy cost
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["GDPLoss_CO2"]]), pattern = "guide-box")
pp0.1 <- plot_grid(NULL,FigList[["GDPLoss_CO2"]] + theme(legend.position="none"), FigList[["GDPLoss_Kyotogas"]] + theme(legend.position="none"),p_legend1,ncol=4,rel_widths =c(0.3,2,2,0.5),align = "hv")
pp0.2 <- plot_grid(FigList[["GDPLoss_overtime"]],FigList[["GDP_loss_Dif"]],ncol=2,rel_widths =c(1,1))
#pp0 <- plot_grid(pp0.1,pp0.2,ncol=1) +  
pp0 <- plot_grid(NULL,FigList[["GDPLoss_CO2"]],FigList[["GDPLoss_Kyotogas"]],NULL,FigList[["GDPLoss_overtime"]],FigList[["GDP_loss_Dif"]]+ggtitle(""),ncol=3,rel_widths =c(0.1,1,1),align = "hv") +  
  draw_plot_label(label = alphabet[1:4], size = 12,x = c(0,1/2,0,0.5), y = c(1, 1,0.5,0.5))
ggsave(pp0, file=paste0("../output/4paper/fig1",".png"),width=10, height=8,limitsize=FALSE)
ggsave(pp0, file=paste0("../output/vector/fig1.svg"), width=10, height=8,limitsize=FALSE)

#2)Investment
pp1 <- plot_grid(FigList[["Investment"]]+ theme(legend.position="none")+ggtitle(""),FigList[["Investment_1000C"]],ncol=1) +  
  draw_plot_label(label = alphabet[1:2], size = 12,x = c(0,0), y = c(1,0.5))
ggsave(pp1, file=paste0("../output/4paper/fig2",".png"), dpi = 250, width=12, height=8,limitsize=FALSE)
ggsave(pp1, file=paste0("../output/vector/fig2.svg"), dpi = 250, width=12, height=8,limitsize=FALSE)

#3) Regional implications
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["ShareValAdd_agr"]]), pattern = "guide-box")
pp2.1 <- plot_grid(FigList[["Region1"]]+ggtitle(""), FigList[["Intensity"]],ncol=2,rel_widths =c(2,2),align = "hv")
pp2.2 <- plot_grid(FigList[["ShareValAdd_ind"]]+ theme(legend.position="none"),FigList[["ShareValAdd_agr"]]+ theme(legend.position="none"),p_legend1,ncol=3,rel_widths =c(1.0,1.0,0.3),align = "h")
pp2 <- plot_grid(FigList[["GDPLoss_NPV_Region"]],pp2.1,pp2.2,ncol=1,rel_heights =c(1.5,1.0,1)) +  
  draw_plot_label(label = alphabet[1:5], size = 12,x = c(0,0,0.5,0,0.5), y = c(1, 0.58, 0.58,0.30,0.30))
ggsave(pp2, file=paste0("../output/4paper/fig3.png"), dpi = 250, width=10, height=15,limitsize=FALSE)
ggsave(pp2, file=paste0("../output/vector/fig3.svg"), dpi = 250, width=10, height=15,limitsize=FALSE)

#4) NDC and discount rates
p_legend1 <- gtable::gtable_filter(ggplotGrob(FigList[["NPV_NDC"]]), pattern = "guide-box")
pp3.1 <- plot_grid(FigList[["NPV_NDC"]]+ theme(legend.position="none"),FigList[["NPV_regopm"]]+ theme(legend.position="none"),p_legend1,ncol=3,rel_widths =c(1,1,0.22),align = "hv")
pp3 <- plot_grid(FigList[["GDPLoss_DisCount"]],pp3.1,ncol=1,rel_heights =c(0.8,1)) +  
  draw_plot_label(label = alphabet[1:5], size = 12,x = c(0,0.30,0.60,0,0.5), y = c(1, 1, 1,0.55,0.55))

ggsave(pp3, file=paste0("../output/4paper/fig4.png"), width=10, height=10,limitsize=FALSE)
ggsave(pp3, file=paste0("../output/vector/fig4.svg"), width=10, height=10,limitsize=FALSE)

#X1) literature GDP loss
ggsave(FigList[["GDPLoss_overtime_lit"]], file=paste0("../output/4paper/figX1.png"), width=5, height=4,limitsize=FALSE)
ggsave(FigList[["GDPLoss_overtime_lit"]], file=paste0("../output/vector/figX1.svg"), width=5, height=4,limitsize=FALSE)

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

#X7) Carbon prices
ppX7 <- plot_grid(allplotcge[["WorldPrc_Car"]],allplotcge_dif[["WorldPrc_Car"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX7, file=paste0("../output/4paper/figX7.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX7, file=paste0("../output/vector/figX7.svg"), width=10, height=4,limitsize=FALSE)

#X8) NPV consumption loss 
ppX8 <- plot_grid(FigList[["Pol_Cos_Cns_Los_rat_NPV_3pc"]]+ggtitle("")+ylab("Cumulative consumption loss rates in NPV (%)"),allplotcge_dif[["WorldPol_Cos_Cns_Los_rat"]],ncol=2,rel_heights =c(1,1)) 
ggsave(ppX8, file=paste0("../output/4paper/figX8.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX8, file=paste0("../output/vector/figX8.svg"), width=10, height=4,limitsize=FALSE)

#X9) Final energy and electricity 
ppX9 <- plot_grid(allplotcge_dif[["WorldFin_Ene"]]+ggtitle("")+ylab("Final energy (EJ/yr)"),allplotcge_dif[["WorldEle_rat_Ele"]]+ggtitle("")+ylab("Electrification rate (%)"),ncol=2,rel_heights =c(1,1)) 
ggsave(ppX9, file=paste0("../output/4paper/figX9.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX9, file=paste0("../output/vector/figX9.svg"), width=10, height=4,limitsize=FALSE)

#X10) Food and food waste
ppX10 <- plot_grid(allplotcge_dif[["WorldCap_Cos_Ele_SolarPV"]]+ggtitle("")+ylab("Capital cost of solar PV (US$/kW)"),allplotcge_dif[["WorldCap_Cos_Ele_Win_Ons"]]+ggtitle("")+ylab("Capital cost of wind turbine (US$/kW)"),ncol=2,rel_heights =c(1,1)) 
ggsave(ppX10, file=paste0("../output/4paper/figX10.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX10, file=paste0("../output/vector/figX10.svg"), width=10, height=4,limitsize=FALSE)


#X11) Food and food waste
ppX11 <- plot_grid(allplotcge_dif[["WorldFoo_Ene_Sup_Liv_Per_Cap"]]+ggtitle("")+ylab("Livestock oriented food (kcal/person/day)"),allplotcge_dif[["WorldFod_Wst"]]+ggtitle("")+ylab("Food waste generation (Mt/yr)"),ncol=2,rel_heights =c(1,1)) 
ggsave(ppX11, file=paste0("../output/4paper/figX11.png"), width=10, height=4,limitsize=FALSE)
ggsave(ppX11, file=paste0("../output/vector/figX11.svg"), width=10, height=4,limitsize=FALSE)


