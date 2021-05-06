$setglobal gdxloc ../modeloutput

SET
  SCENARIO,REMF,VEMF
  Y/2000*2100/
  decele/fd,output,fd_output,output_va,del_output,outputratio,residual,va/
  AggSecCO2/Industry,Transport,OtherEnergySupply,Power,Service,Agriculture/
  R/USA,XE25,XER,TUR,XOC,CHN,IND,JPN,XSE,XSA,CAN,BRA,XLM,CIS,XME,XNF,XAF,WLD,Asia,ASIA2,Non-OECD,Industrial,Transition,Developing,OECD90,REF,MAF,LAM/
;
PARAMETER
  IAMC_template(SCENARIO,REMF,VEMF,Y)
  DifDef(SCENARIO,REMF,VEMF,Y)
  RateDef(SCENARIO,REMF,VEMF,Y)
  IAMCTemplate(SCENARIO,REMF,VEMF,Y,*)
  Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO,decele)
  Loss_dcp_agg(SCENARIO,REMF,Y,AggSecCO2,decele,*)
;
ALIAS(SCENARIO,SCENARIO2);
$gdxin "%gdxloc%/global_17_emf.gdx"
$load   SCENARIO,REMF,VEMF
$load   IAMC_Template

$gdxin "%gdxloc%/analysis.gdx"
$load   Loss_dcp_agg_gdp

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
;
DifDef(SCENARIO,REMF,VEMF,Y)$(SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y)) AND IAMC_template(SCENARIO,REMF,VEMF,Y))=
  IAMC_template(SCENARIO,REMF,VEMF,Y)-SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y));
RateDef(SCENARIO,REMF,VEMF,Y)$(SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y)) AND IAMC_template(SCENARIO,REMF,VEMF,Y))=
  IAMC_template(SCENARIO,REMF,VEMF,Y)/SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),IAMC_template(SCENARIO2,REMF,VEMF,Y));
IAMCTemplate(SCENARIO,REMF,VEMF,Y,"abs")=IAMC_template(SCENARIO,REMF,VEMF,Y);
IAMCTemplate(SCENARIO,REMF,VEMF,Y,"dif")=DifDef(SCENARIO,REMF,VEMF,Y);
IAMCTemplate(SCENARIO,REMF,VEMF,Y,"rate")=RateDef(SCENARIO,REMF,VEMF,Y);


Loss_dcp_agg(SCENARIO,REMF,Y,AggSecCO2,decele,"abs")=SUM(Rmap(R,REMF),Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO,decele));
Loss_dcp_agg(SCENARIO,REMF,Y,AggSecCO2,decele,"dif")=SUM(Rmap(R,REMF),Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO,decele)-SUM(SCENARIO2$BaseSceMap(SCENARIO,SCENARIO2),Loss_dcp_agg_gdp(Y,R,AggSecCO2,SCENARIO2,decele)));

execute_unload "%gdxloc%/global_17_emf_diff.gdx" IAMCTemplate,Loss_dcp_agg
;
