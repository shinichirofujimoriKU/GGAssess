SET
CumNPVMap_%1(Variable2,Variable2)/
Prc_car  .       Prc_Car_NPV_%1pc
GDP_MER  .       GDP_MER_NPV_%1pc
Pol_Cos_GDP_los  .       Pol_Cos_GDP_los_NPV_%1pc
/
;

Discount("%1pc",Y10)$(Y10.val>=2020)=(1+%1/100)**(Y10.val-2020);
NPV(ModelN,Scenario,Region,Variable2,Unit,Y)$((Y5(Y) OR Y10(Y)) AND SUM((Variable2p,Y10)$(CumNPVMap_%1(Variable2p,Variable2) AND IPCCSR15All(ModelN,Scenario,Region,Variable2p,Unit,Y10,"Value") AND Discount("%1pc",Y10)),1))
=SUM((Variable2p,Y10)$(CumNPVMap_%1(Variable2p,Variable2) AND Discount("%1pc",Y10) AND Y10.val<=Y.val),IPCCSR15All(ModelN,Scenario,Region,Variable2p,Unit,Y10,"Value")/Discount("%1pc",Y10));
NPV(ModelN,Scenario,Region,"Pol_Cos_GDP_los_rat_NPV_%1pc",Unit,Y)$(NPV(ModelN,Scenario,Region,"GDP_MER_NPV_%1pc",Unit,Y) AND (Y5(Y) OR Y10(Y)))=NPV(ModelN,Scenario,Region,"Pol_Cos_GDP_los_NPV_%1pc",Unit,Y)/NPV(ModelN,Scenario,Region,"GDP_MER_NPV_%1pc",Unit,Y)*100;
