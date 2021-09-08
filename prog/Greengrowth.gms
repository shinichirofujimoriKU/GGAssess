$setglobal gdxloc ../modeloutput

SET
  SCENARIO,REMF,VEMF
  Y/2000*2100/
  Y5(Y)/2005,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
  decele/fd,output,fd_output,output_va,del_output,outputratio,residual,va/
  AggSecCO2/Industry,Transport,OtherEnergySupply,Power,Service,Agriculture/
  R/USA,XE25,XER,TUR,XOC,CHN,IND,JPN,XSE,XSA,CAN,BRA,XLM,CIS,XME,XNF,XAF,WLD,Asia,ASIA2,Non-OECD,Industrial,Transition,Developing,OECD90,REF,MAF,LAM/
  Indicator2/abs,gdp,npvabs3pc,npvgdp3pc,npvper3pc,npvabs5pc,npvgdp5pc,npvper5pc,per,"Impact(%GDP)"/
  Y2015_2020(Y)/2015,2020/

;
PARAMETER
  IAMC_template(SCENARIO,REMF,VEMF,Y)
  DifDef(SCENARIO,REMF,VEMF,Y)
  RateDef(SCENARIO,REMF,VEMF,Y)
  IAMCTemplate(SCENARIO,REMF,*,Y,*)
  Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO,decele)
  Loss_dcp_agg(SCENARIO,REMF,Y,AggSecCO2,decele,*)
  AirPolLutionLoad(*,SCENARIO,REMF,*,*,Y)
;
ALIAS(SCENARIO,SCENARIO2),(Y,YY);
$gdxin "%gdxloc%/global_17_emf.gdx"
$load   SCENARIO,REMF,VEMF
$load   IAMC_Template

$gdxin "%gdxloc%/analysis.gdx"
$load   Loss_dcp_agg_gdp

TABLE
CCImpact(SCENARIO,REMF,Y,Indicator2)
$offlisting
$ondelim
$include ../modeloutput/impact/impact_all.csv
$offdelim
$onlisting
;
ALIAS(REMF,REMF1);

SET
BaseSceMap(SCENARIO,SCENARIO2)/
$include ../data/scenariomapgams.map
/
Rmap(R,REMF)/
USA  .  USA
XE25  .  XE25
XER  .  XER
TUR  .  TUR
XOC  .  XOC
CHN  .  CHN
IND  .  IND
JPN  .  JPN
XSE  .  XSE
XSA  .  XSA
CAN  .  CAN
BRA  .  BRA
XLM  .  XLM
CIS  .  CIS
XME  .  XME
XNF  .  XNF
XAF  .  XAF
WLD  .  World
Asia  .  R5ASIA
ASIA2  .  ASIA2
OECD90  .  R5OECD90+EU
REF  .  R5REF
MAF  .  R5MAF
LAM  .  R5LAM
/
Rmap2(REMF,REMF1)/
USA	.	World
XE25	.	World
XER	.	World
TUR	.	World
XOC	.	World
CHN	.	World
IND	.	World
JPN	.	World
XSE	.	World
XSA	.	World
CAN	.	World
BRA	.	World
XLM	.	World
CIS	.	World
XME	.	World
XNF	.	World
XAF	.	World
USA	.	R5OECD90+EU
XE25	.	R5OECD90+EU
XER	.	R5OECD90+EU
TUR	.	R5OECD90+EU
XOC	.	R5OECD90+EU
CHN	.	R5ASIA
IND	.	R5ASIA
JPN	.	R5OECD90+EU
XSE	.	R5ASIA
XSA	.	R5ASIA
CAN	.	R5OECD90+EU
BRA	.	R5LAM
XLM	.	R5LAM
CIS	.	R5REF
XME	.	R5MAF
XNF	.	R5MAF
XAF	.	R5MAF
/
;
DifDef(SCENARIO,REMF,VEMF,Y)$(SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y)) AND IAMC_template(SCENARIO,REMF,VEMF,Y))=
  IAMC_template(SCENARIO,REMF,VEMF,Y)-SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y));
RateDef(SCENARIO,REMF,VEMF,Y)$(SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y)) AND IAMC_template(SCENARIO,REMF,VEMF,Y))=
  IAMC_template(SCENARIO,REMF,VEMF,Y)/SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y));
IAMCTemplate(SCENARIO,REMF,VEMF,Y,"abs")=IAMC_template(SCENARIO,REMF,VEMF,Y);
IAMCTemplate(SCENARIO,REMF,VEMF,Y,"dif")=DifDef(SCENARIO,REMF,VEMF,Y);
IAMCTemplate(SCENARIO,REMF,VEMF,Y,"rate")=RateDef(SCENARIO,REMF,VEMF,Y);

*Climate change impact
CCImpact(SCENARIO,REMF,Y,"abs")=CCImpact(SCENARIO,REMF,Y,"Impact(%GDP)")*IAMCTemplate(SCENARIO,REMF,"GDP_MER",Y,"abs");
CCImpact(SCENARIO,REMF,Y,"gdp")=IAMCTemplate(SCENARIO,REMF,"GDP_MER",Y,"abs");
CCImpact(SCENARIO,REMF,YY,"npvabs5pc")$(Y5(YY))=SUM(Y$(YY.val>=Y.val AND Y.val>=2020),CCImpact(SCENARIO,REMF,Y,"abs")*1.05**(-(Y.val-2020)));
CCImpact(SCENARIO,REMF,YY,"npvgdp5pc")$(Y5(YY))=SUM(Y$(YY.val>=Y.val AND Y.val>=2020),IAMCTemplate(SCENARIO,REMF,"GDP_MER",Y,"abs")*1.05**(-(Y.val-2020)));
CCImpact(SCENARIO,REMF,YY,"npvabs3pc")$(Y5(YY))=SUM(Y$(YY.val>=Y.val AND Y.val>=2020),CCImpact(SCENARIO,REMF,Y,"abs")*1.03**(-(Y.val-2020)));
CCImpact(SCENARIO,REMF,YY,"npvgdp3pc")$(Y5(YY))=SUM(Y$(YY.val>=Y.val AND Y.val>=2020),IAMCTemplate(SCENARIO,REMF,"GDP_MER",Y,"abs")*1.03**(-(Y.val-2020)));
CCImpact(SCENARIO,REMF,Y,Indicator2)$(CCImpact(SCENARIO,REMF,Y,Indicator2)=0)=SUM(REMF1$(Rmap2(REMF1,REMF)),CCImpact(SCENARIO,REMF1,Y,Indicator2));
CCImpact(SCENARIO,REMF,Y,"npvper5pc")$(CCImpact(SCENARIO,REMF,Y,"npvgdp5pc"))=CCImpact(SCENARIO,REMF,Y,"npvabs5pc")/CCImpact(SCENARIO,REMF,Y,"npvgdp5pc");
CCImpact(SCENARIO,REMF,Y,"npvper3pc")$(CCImpact(SCENARIO,REMF,Y,"npvgdp3pc"))=CCImpact(SCENARIO,REMF,Y,"npvabs3pc")/CCImpact(SCENARIO,REMF,Y,"npvgdp3pc");
CCImpact(SCENARIO,REMF,Y,"per")$(CCImpact(SCENARIO,REMF,Y,"gdp"))=CCImpact(SCENARIO,REMF,Y,"abs")/CCImpact(SCENARIO,REMF,Y,"gdp");
IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_rat",Y,"abs")=CCImpact(SCENARIO,REMF,Y,"per");
IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los",Y,"abs")=CCImpact(SCENARIO,REMF,Y,"abs");
IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_rat_NPV_5pc",Y,"abs")=CCImpact(SCENARIO,REMF,Y,"npvper5pc");
IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_rat_NPV_3pc",Y,"abs")=CCImpact(SCENARIO,REMF,Y,"npvper3pc");
IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_NPV_5pc",Y,"abs")=CCImpact(SCENARIO,REMF,Y,"npvabs5pc");
IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_NPV_3pc",Y,"abs")=CCImpact(SCENARIO,REMF,Y,"npvabs3pc");
$batinclude sub_relBaU.gms Clm_Chn_Imp_GDP_los_rat
$batinclude sub_relBaU.gms Clm_Chn_Imp_GDP_los
$batinclude sub_relBaU.gms Clm_Chn_Imp_GDP_los_rat_NPV_5pc
$batinclude sub_relBaU.gms Clm_Chn_Imp_GDP_los_NPV_5pc
$batinclude sub_relBaU.gms Clm_Chn_Imp_GDP_los_rat_NPV_3pc
$batinclude sub_relBaU.gms Clm_Chn_Imp_GDP_los_NPV_3pc
*IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_rat_Rel_BaU",Y,"abs")$(IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_rat",Y,"abs") AND IAMCTemplate("SSP2_BaU_NoCC",REMF,"Clm_Chn_Imp_GDP_los_rat",Y,"abs"))=IAMCTemplate(SCENARIO,REMF,"Clm_Chn_Imp_GDP_los_rat",Y,"abs")-IAMCTemplate("SSP2_BaU_NoCC",REMF,"Clm_Chn_Imp_GDP_los_rat",Y,"abs");

*air pollution
$gdxin '../modeloutput/air/HealthRisk_PM25.gdx'
$load AirPolLutionLoad=EMFtemp

AirPolLutionLoad("AIM/CGE",SCENARIO,REMF,"VSL_Mor_AP_PM25","billion US$/yr",Y)$(SUM(YY,AirPolLutionLoad("AIM/CGE",SCENARIO,REMF,"VSL_Mor_AP_PM25","billion US$/yr",YY)) AND Y2015_2020(Y))=AirPolLutionLoad("AIM/CGE","SSP2_BaU_NoCC",REMF,"VSL_Mor_AP_PM25","billion US$/yr",Y);
$batinclude interpolate.gms 2020 2030
$batinclude interpolate.gms 2030 2050
$batinclude interpolate.gms 2050 2100

*AirPolLutionLoad("AIM/CGE",SCENARIO,REMF,"VSL_Mor_AP_PM25","billion US$/yr",Y)$(Y.val>2050 AND Y.val<2100 AND Y5(Y))=[(2100-Y.val)*AirPolLutionLoad("AIM/CGE",SCENARIO,REMF,"VSL_Mor_AP_PM25","billion US$/yr","2050")+(Y.val-2050)*AirPolLutionLoad("AIM/CGE",SCENARIO,REMF,"VSL_Mor_AP_PM25","billion US$/yr","2100")]/(2100-2050);

*Decomposition
Loss_dcp_agg(SCENARIO,REMF,Y,AggSecCO2,decele,"abs")=SUM(Rmap(R,REMF),Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO,decele));
Loss_dcp_agg(SCENARIO,REMF,Y,AggSecCO2,decele,"dif")=SUM(Rmap(R,REMF),Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO,decele)-SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO2,decele)));

execute_unload "%gdxloc%/global_17_emf_diff.gdx" IAMCTemplate,Loss_dcp_agg,AirPolLutionLoad
;
