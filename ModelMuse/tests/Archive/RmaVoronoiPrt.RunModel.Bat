@echo off
rem Get start time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
@echo on
if exist "arrays\RmaVoronoiPrt.Kx_1.arrays" del "arrays\RmaVoronoiPrt.Kx_1.arrays"
if exist "RmaVoronoiPrt.Mf6Values" del "RmaVoronoiPrt.Mf6Values"
if exist "RmaVoronoiPrt.wel" del "RmaVoronoiPrt.wel"
if exist "mfsim.lst" del "mfsim.lst"
if exist "RmaVoronoiPrt.bhd" del "RmaVoronoiPrt.bhd"
if exist "RmaVoronoiPrt.cbc" del "RmaVoronoiPrt.cbc"
if exist "RmaVoronoiPrt.chob_out_chd.csv" del "RmaVoronoiPrt.chob_out_chd.csv"
if exist "RmaVoronoiPrt.InnerSolution.CSV" del "RmaVoronoiPrt.InnerSolution.CSV"
if exist "RmaVoronoiPrt.lst" del "RmaVoronoiPrt.lst"
if exist "RmaVoronoiPrt.ob_gw_out_head.csv" del "RmaVoronoiPrt.ob_gw_out_head.csv"
if exist "RmaVoronoiPrt.OuterSolution.CSV" del "RmaVoronoiPrt.OuterSolution.CSV"
if exist "RmaVoronoiPrt.PRT1.lst" del "RmaVoronoiPrt.PRT1.lst"
if exist "RmaVoronoiPrt.PRT1.trk" del "RmaVoronoiPrt.PRT1.trk"
if exist "RmaVoronoiPrt.PRT1.trk.hdr" del "RmaVoronoiPrt.PRT1.trk.hdr"
"plproc.exe" RmaVoronoiPrt.Kx.script
"EnhancedTemplateProcessor.exe" RmaVoronoiPrt.wel.tpl RmaVoronoiPrt.pval
mf6.exe
"Mf6ObsExtractor.exe" RmaVoronoiPrt.Mf6ExtractValues
@echo off
rem Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem Get elapsed time:
set /A elapsed=end-start

rem Show elapsed time:
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%
echo elapsed time: %hh% hours, %mm% minutes %ss%.%cc% seconds

