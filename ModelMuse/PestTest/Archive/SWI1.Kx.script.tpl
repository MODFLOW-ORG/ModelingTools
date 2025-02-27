ptf @
#Script for PLPROC

#Read parameter values
HK = @                        HK@
# Pilot points are not used with HK.

#Read MODFLOW-2005 grid information file
cl_Discretization = read_mf_grid_specs(file="SWI1.gsf")
# Layer     1

#Read data to modify
read_list_file(reference_clist='cl_Discretization',skiplines=1, &
  slist=s_PIndex1;column=2, &
  plist=p_Value1;column=3, &
  file='SWI1.Kx.PstValues')

# Modfify data values
temp1=new_plist(reference_clist=cl_Discretization,value=0.0)
# Setting values for layer     1
  # Setting values for parameter HK
    # Substituting parameter values in zones
    p_Value1(select=(s_PIndex1 == 1)) = p_Value1 * HK

#Write new data values
write_column_data_file(header='no', &
  file='arrays\SWI1.Kx_1.arrays';delim="space", &
  plist=p_Value1)

# Remove sLists and pLists
s_PIndex1.remove()
p_Value1.remove()
temp1.remove()

