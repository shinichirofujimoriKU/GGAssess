SET
ModelN
Region
Scenario
Unit
Variable2/"Emi_CO2","Prc_Car","Prc_Car_NPV",Emi_CO2_Cum
GDP_MER,GDP_MER_NPV
Pol_Cos_GDP_Los,Pol_Cos_GDP_Los_NPV
Pol_Cos_GDP_Los_rat,Pol_Cos_GDP_Los_rat_NPV
/
Year
;
$gdxin "../modeloutput/IPCCSR15All.gdx"
$load ModelN,Region,Scenario,Unit,Year
*$load Variable2

SET
CO2Emi/0*10000/
Year5(Year)/X2015,X2025,X2035,X2045,X2055,X2065,X2075,X2085,X2095/
Year10(Year)/X2010,X2020,X2030,X2040,X2050,X2060,X2070,X2080,X2090,X2100/
StartendY(Year)/X2010,X2100/
StartY(Year)/X2010/
Year5map(Year,Year,Year)/
X2015   .       X2010   .       X2020
X2025   .       X2020   .       X2030
X2035   .       X2030   .       X2040
X2045   .       X2040   .       X2050
X2055   .       X2050   .       X2060
X2065   .       X2060   .       X2070
X2075   .       X2070   .       X2080
X2085   .       X2080   .       X2090
X2095   .       X2090   .       X2100
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
StartendYTCRE(ModelN,Scenario,Region,Variable2,Unit,Year)
CumNPVMap(Variable2,Variable2)/
Prc_car  .       Prc_Car_NPV
GDP_MER  .       GDP_MER_NPV
Pol_Cos_GDP_los  .       Pol_Cos_GDP_los_NPV
/
;
Alias(Year,Year1,Year2),(Variable2,Variable2p)

PARAMETER
IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year,*)
NPV(ModelN,Scenario,Region,Variable2,Unit)
CumCO2Emis(ModelN,Scenario,Region,Variable2,Unit)
Discount(Year10)
;
$gdxin "../modeloutput/IPCCSR15All.gdx"
$load IPCCSR15All_load=IPCCSR15All

IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year,"Value")$(NOT IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,"X2100","Value"))=0;

IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year5,"Value")$(IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year5,"Value")=0)=
        SUM((Year2,Year1)$(Year5map(Year5,Year1,Year2)),IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year1,"Value")+IPCCSR15All_load(ModelN,Scenario,Region,Variable2,Unit,Year2,"Value"))/2;

CumCO2Emis(ModelN,Scenario,Region,"Emi_CO2_Cum",Unit)=((SUM(Year$(Year5(Year) OR Year10(Year)),IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CO2",Unit,Year,"Value"))*2-SUM(Year$(StartendY(Year)),IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CO2",Unit,Year,"Value")))*5/2
-IPCCSR15All_load(ModelN,Scenario,Region,"Emi_CO2",Unit,"X2010","Value"))/1000;

Discount(Year10)=1.05**(10*(ORD(Year10)-1));
NPV(ModelN,Scenario,Region,Variable2,Unit)$(SUM((Variable2p,Year10)$(CumNPVMap(Variable2p,Variable2) AND IPCCSR15All_load(ModelN,Scenario,Region,Variable2p,Unit,Year10,"Value") AND Discount(Year10)),1))
=SUM((Variable2p,Year10)$(CumNPVMap(Variable2p,Variable2) AND Discount(Year10)),IPCCSR15All_load(ModelN,Scenario,Region,Variable2p,Unit,Year10,"Value")/Discount(Year10));
NPV(ModelN,Scenario,Region,"Pol_Cos_GDP_los_rat_NPV",Unit)$(NPV(ModelN,Scenario,Region,"GDP_MER_NPV",Unit))=NPV(ModelN,Scenario,Region,"Pol_Cos_GDP_los_NPV",Unit)/NPV(ModelN,Scenario,Region,"GDP_MER_NPV",Unit)*100;


NPV(ModelN,Scenario,Region,"Emi_CO2_Cum",Unit)=SUM(Variable2,CumCO2Emis(ModelN,Scenario,Region,Variable2,Unit));



execute_unload '../modeloutput/cumulativeEmissions.gdx' CumCO2Emis
NPV
IPCCSR15All_load
;

