SET
ModelN
Region
Scenario
Unit
Variable2/"Emi_CO2","Prc_Car",Emi_CO2_Cum,Emi_Kyo_Gas_Cum,Emi_Kyo_Gas,Emi_CH4,EMI_N2O,EMI_F_G
Pol_Cos_GDP_Los
GDP_MER
Pol_Cos_GDP_Los_rat
Prc_Car_NPV_5pc
GDP_MER_NPV_5pc
Pol_Cos_GDP_Los_NPV_5pc
Pol_Cos_GDP_Los_rat_NPV_5pc
Prc_Car_NPV_3pc
GDP_MER_NPV_3pc
Pol_Cos_GDP_Los_NPV_3pc
Pol_Cos_GDP_Los_rat_NPV_3pc
Prc_Car_NPV_4pc
GDP_MER_NPV_4pc
Pol_Cos_GDP_Los_NPV_4pc
Pol_Cos_GDP_Los_rat_NPV_4pc
Prc_Car_NPV_2pc
GDP_MER_NPV_2pc
Pol_Cos_GDP_Los_NPV_2pc
Pol_Cos_GDP_Los_rat_NPV_2pc
Prc_Car_NPV_1pc
GDP_MER_NPV_1pc
Pol_Cos_GDP_Los_NPV_1pc
Pol_Cos_GDP_Los_rat_NPV_1pc
/
VarPolCost(Variable2)/Pol_Cos_GDP_Los/
Year
dum/1*100000/
Y/2000*2100/
;
$gdxin "../modeloutput/IPCCSR15All.gdx"
$load ModelN,Region,Scenario,Unit,Year
*$load Variable2

SET
CO2Emi/0*10000/
Year5(Year)/X2015,X2025,X2035,X2045,X2055,X2065,X2075,X2085,X2095/
Year10(Year)/X2010,X2020,X2030,X2040,X2050,X2060,X2070,X2080,X2090,X2100/
StartendYear(Year)/X2010,X2100/
StartYear(Year)/X2010/
YearMap(Year,Y)/
$include ../data/Yearmap.txt
/
Y5(Y)/2015,2025,2035,2045,2055,2065,2075,2085,2095/
Y10(Y)/2010,2020,2030,2040,2050,2060,2070,2080,2090,2100/
StartendY(Y)/2010,2100/
StartY(Y)/2010/
Y5map(Y,Y,Y)/
2015   .       2010   .       2020
2025   .       2020   .       2030
2035   .       2030   .       2040
2045   .       2040   .       2050
2055   .       2050   .       2060
2065   .       2060   .       2070
2075   .       2070   .       2080
2085   .       2080   .       2090
2095   .       2090   .       2100
/
SSP/SSP1*SSP5/
RCP/19,26,34,45,60/
Scenariomap(Scenario,SSP,RCP)/
SSP1-19        .        SSP1        .        19
SSP1-26        .        SSP1        .        26
SSP1-34        .        SSP1        .        34
SSP1-45        .        SSP1        .        45
SSP2-19        .        SSP2        .        19
SSP2-26        .        SSP2        .        26
SSP2-34        .        SSP2        .        34
SSP2-45        .        SSP2        .        45
SSP2-60        .        SSP2        .        60
SSP3-34        .        SSP3        .        34
SSP3-45        .        SSP3        .        45
SSP3-60        .        SSP3        .        60
SSP4-19        .        SSP4        .        19
SSP4-26        .        SSP4        .        26
SSP4-34        .        SSP4        .        34
SSP4-45        .        SSP4        .        45
SSP4-60        .        SSP4        .        60
SSP5-19        .        SSP5        .        19
SSP5-26        .        SSP5        .        26
SSP5-34        .        SSP5        .        34
SSP5-45        .        SSP5        .        45
SSP5-60        .        SSP5        .        60
/
ModSceMod(ModelN,Scenario)/
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_1.5C_cost100"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_1.5C_full"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_1.5C_nofuel"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_Med2C_cost100"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_Med2C_full"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_Med2C_limbio"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_Med2C_nobeccs"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_Med2C_nofuel"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_Med2C_none"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_tax_hi_full"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_tax_hi_none"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_tax_lo_full"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_tax_lo_none"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_WB2C_cost100"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_WB2C_full"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_WB2C_limbio"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_WB2C_nobeccs"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_WB2C_nofuel"
"REMIND-MAgPIE 1_7-3_0"  .  "EMF33_WB2C_none"
/

StartendYTCRE(ModelN,Scenario,Region,Variable2,Unit,Year)
IntRate/1pc*5pc/
VarCumMap(Variable2,Variable2)/
Emi_CO2_Cum	.	Emi_CO2
Emi_Kyo_Gas_Cum	.	Emi_Kyo_Gas
/
;
Alias(Year,Year1,Year2),(Variable2,Variable2p),(Y,Y1,Y2);

PARAMETER
IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year,*)
IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y,*)
NPV(ModelN,Scenario,Region,Variable2,Unit,Y)
CumCO2Emis(ModelN,Scenario,Region,Variable2,Unit,Y)
Discount(IntRate,Y10)
;
$gdxin "../modeloutput/IPCCSR15All.gdx"
$load IPCCSR15All_load=IPCCSR15All

IPCCSR15All_load(ModelN,Scenario,Region,"Emi_Kyo_Gas","Mt CO2-equiv/yr",Year,"Value")$(IPCCSR15All_load(ModelN,Scenario,Region,"Emi_Kyo_Gas","Mt CO2-equiv/yr",Year,"Value")=0 AND IPCCSR15All_load(ModelN,Scenario,Region,"Emi_F_G","Mt CO2-equiv/yr",Year,"Value") AND IPCCSR15All_load(ModelN,Scenario,Region,"Emi_N2O","kt N2O/yr",Year,"Value") AND IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CH4","Mt CH4/yr",Year,"Value") AND IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CO2","Mt CO2/yr",Year,"Value"))=IPCCSR15All_load(ModelN,Scenario,Region,"Emi_F_G","Mt CO2-equiv/yr",Year,"Value")+IPCCSR15All_load(ModelN,Scenario,Region,"Emi_N2O","kt N2O/yr",Year,"Value")/1000*298+IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CH4","Mt CH4/yr",Year,"Value")*25+IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CO2","Mt CO2/yr",Year,"Value");


IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year,"Value")$(NOT IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,"X2100","Value"))=0;

IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y,"Value")=SUM(YearMap(Year,Y),IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year,"Value"));
IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y5,"Value")$(IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y5,"Value")=0)=
        SUM((Y2,Y1)$(Y5map(Y5,Y1,Y2)),IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y1,"Value")+IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y2,"Value"))/2;

IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y,"Value")$(VarPolCost(Variable2) AND ModSceMod(ModelN,Scenario))=IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,Y,"Value")*(-1);

CumCO2Emis(ModelN,Scenario,Region,Variable2,Unit,Y2)$(SUM(Variable2p$VarCumMap(Variable2,Variable2p),1) AND Y5(Y2) OR Y10(Y2))=SUM(Variable2p$VarCumMap(Variable2,Variable2p),(SUM(Y$((Y5(Y) OR Y10(Y)) AND ORD(Y)<=ORD(Y2)),IPCCSR15All(ModelN,Scenario,Region,Variable2p,Unit,Y,"Value"))*2-IPCCSR15All(ModelN,Scenario,Region,Variable2p,Unit,"2010","Value")-IPCCSR15All(ModelN,Scenario,Region,Variable2p,Unit,Y2,"Value"))*5/2
-IPCCSR15All(ModelN,Scenario,Region,Variable2,Unit,"2010","Value"))/1000;

IPCCSR15All(ModelN,Scenario,Region,"Pol_Cos_GDP_los_Rat",Unit,Y,"Value")$(IPCCSR15All(ModelN,Scenario,Region,"GDP_MER",Unit,Y,"Value"))=IPCCSR15All(ModelN,Scenario,Region,"Pol_Cos_GDP_los",Unit,Y,"Value")/IPCCSR15All(ModelN,Scenario,Region,"GDP_MER",Unit,Y,"Value");

$batinclude ../prog/NPV.gms 5
$batinclude ../prog/NPV.gms 4
$batinclude ../prog/NPV.gms 3
$batinclude ../prog/NPV.gms 2
$batinclude ../prog/NPV.gms 1


NPV(ModelN,Scenario,Region,Variable2,Unit,Y)$(CumCO2Emis(ModelN,Scenario,Region,Variable2,Unit,Y))=CumCO2Emis(ModelN,Scenario,Region,Variable2,Unit,Y);



execute_unload '../modeloutput/cumulativeEmissions.gdx' CumCO2Emis
NPV
IPCCSR15All
;

