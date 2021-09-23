system(paste("gams Greengrowth.gms",sep=" "))

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
