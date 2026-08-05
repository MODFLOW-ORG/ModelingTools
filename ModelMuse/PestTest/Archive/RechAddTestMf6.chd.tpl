ptf @
etf %
# CHD: Time-Variant Specified-Head package file created on 8/5/2026 by ModelMuse version 5.4.0.13.
# (and then modified by a parameter estimation program.)
BEGIN OPTIONS
    AUXILIARY IFACE IFLOWFACE
    BOUNDNAMES
    PRINT_INPUT
    SAVE_FLOWS
END OPTIONS

BEGIN DIMENSIONS
  MAXBOUND     1
END DIMENSIONS

BEGIN PERIOD      1
     1    10    10 %                    @                    CHD_MF6@ * 0%      0     0 'Object4'  # Data Set 6: Layer Row Column Shead IFACE IFLOWFACE boundname
END PERIOD 

