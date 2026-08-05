ptf @
etf %
# WEL: Well package file created on 8/5/2026 by ModelMuse version 5.4.0.13.
# (and then modified by a parameter estimation program.)
BEGIN OPTIONS
    AUXILIARY IFACE IFLOWFACE
    BOUNDNAMES
    PRINT_INPUT
    SAVE_FLOWS
    AUTO_FLOW_REDUCE  1.000000000000E-006 
END OPTIONS

BEGIN DIMENSIONS
  MAXBOUND     1
END DIMENSIONS

BEGIN PERIOD      1
     1     3     7 %                    @                    Q_Par1@ * -0.02%      0     0 'Object7'  # Data Set 6: Layer Row Column Q IFACE IFLOWFACE boundname Intersected by Object7 with formula: -0.02 multiplied by the parameter value for "Q_Par1."
END PERIOD 

BEGIN PERIOD      2
     1     3     7 %                    @                    Q_Par1@ * -0.03%      0     0 'Object7'  # Data Set 6: Layer Row Column Q IFACE IFLOWFACE boundname Intersected by Object7 with formula: -0.03 multiplied by the parameter value for "Q_Par1."
END PERIOD 

