@echo off

REM   Make a predictive MODFLOW run.
REM   Run DRY and GAGEINTERP.

echo.

Echo gen2003heads.bat is running MODFLOW-2005...

REM start "MODFLOW-2000 model run" /min /low /wait mf2k-db-pcgn mod16_spheads_tsflux_ssfix.nam
REM start "MODFLOW-2005 model run" /min /low /wait ..\..\mf2005\release\mf2005-dbopt mod16opt.nam
..\..\mf2005\release\mf2005-dbopt mod16gen2003heads.nam

Echo gen2003heads.bat is running DRY.EXE...

dry mod16gen2003heads.lst

Echo gen2003heads.bat is running GAGEINTERP...

gageinterp

REM   Run J_OSOM to convert ._os file produced by MODFLOW-2000
REM   to a ._om file with no omitted simulated equivalents.

REM Echo Run_tr.bat is running J_OSOM...
REM j_osom mod16trosom

echo.
echo gen2003heads.bat is done.

