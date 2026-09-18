ptf @
etf %
# WEL: Well package file created on 9/18/2026 by ModelMuse version 5.4.0.14.
# (and then modified by a parameter estimation program.)
BEGIN OPTIONS
    AUXILIARY IFACE IFLOWFACE
    BOUNDNAMES
    PRINT_INPUT
    SAVE_FLOWS
    AUTO_FLOW_REDUCE  1.000000000000E-006 
END OPTIONS

BEGIN DIMENSIONS
  MAXBOUND     6
END DIMENSIONS

BEGIN PERIOD      1
     1  8562 %                    0.0047523612896198  *  @                    Seepage@%      0     0 'Disposal_Pond'  # Data Set 6: Layer cell2d Q IFACE IFLOWFACE boundname Intersected by Disposal_Pond with formula: ((0.03 * ObjectIntersectArea) / ObjectArea) * 1.
     1  8664 %                    0.0144984322548595  *  @                    Seepage@%      0     0 'Disposal_Pond'  # Data Set 6: Layer cell2d Q IFACE IFLOWFACE boundname Intersected by Disposal_Pond with formula: ((0.03 * ObjectIntersectArea) / ObjectArea) * 1.
     1  8573 %                    0.00265878580457467  *  @                    Seepage@%      0     0 'Disposal_Pond'  # Data Set 6: Layer cell2d Q IFACE IFLOWFACE boundname Intersected by Disposal_Pond with formula: ((0.03 * ObjectIntersectArea) / ObjectArea) * 1.
     1  8751 %                    0.00809042065094594  *  @                    Seepage@%      0     0 'Disposal_Pond'  # Data Set 6: Layer cell2d Q IFACE IFLOWFACE boundname Intersected by Disposal_Pond with formula: ((0.03 * ObjectIntersectArea) / ObjectArea) * 1.
     1     1 -1.000000000000E-003      0     0 'West_Well'  # Data Set 6: Layer cell2d Q IFACE IFLOWFACE boundname Intersected by West_Well with formula: -0.001
     1     2 -2.000000000000E-003      0     0 'Eastern_Well'  # Data Set 6: Layer cell2d Q IFACE IFLOWFACE boundname Intersected by Eastern_Well with formula: -0.002
END PERIOD 

