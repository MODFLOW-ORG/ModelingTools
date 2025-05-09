# CTP: GWE Constant Temperature Package file created on 5/9/2025 by ModelMuse version 5.3.1.16.
BEGIN OPTIONS
    AUXILIARY IFACE
    BOUNDNAMES
    PRINT_INPUT
    SAVE_FLOWS
END OPTIONS

BEGIN DIMENSIONS
  MAXBOUND     2
END DIMENSIONS

BEGIN PERIOD      1
     1     4     5  1.000000000000E+000      0 'Object3'  # Stress periods: Layer Row Column Temperature IFACE boundname
     1     5     7  1.000000000000E+000      0 'Object5'  # Stress periods: Layer Row Column Temperature IFACE boundname
END PERIOD 

