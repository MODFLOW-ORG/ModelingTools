@echo off
rem Get start time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
@echo on
if exist "GweTest.Mf6Values" del "GweTest.Mf6Values"
if exist "GweTest.Temperature.esl" del "GweTest.Temperature.esl"
if exist "GweTest.bhd" del "GweTest.bhd"
if exist "GweTest.cbc" del "GweTest.cbc"
if exist "GweTest.Chem.cbc" del "GweTest.Chem.cbc"
if exist "GweTest.Chem.InnerSolution.CSV" del "GweTest.Chem.InnerSolution.CSV"
if exist "GweTest.Chem.lkt_budget" del "GweTest.Chem.lkt_budget"
if exist "GweTest.Chem.lkt_budget.csv" del "GweTest.Chem.lkt_budget.csv"
if exist "GweTest.Chem.lkt_conc" del "GweTest.Chem.lkt_conc"
if exist "GweTest.Chem.lst" del "GweTest.Chem.lst"
if exist "GweTest.Chem.mvt_budget" del "GweTest.Chem.mvt_budget"
if exist "GweTest.Chem.mvt_budget.csv" del "GweTest.Chem.mvt_budget.csv"
if exist "GweTest.Chem.mwt_budget" del "GweTest.Chem.mwt_budget"
if exist "GweTest.Chem.mwt_conc" del "GweTest.Chem.mwt_conc"
if exist "GweTest.Chem.mwt_concentration_ob.csv" del "GweTest.Chem.mwt_concentration_ob.csv"
if exist "GweTest.Chem.mwt_mwt_ob.csv" del "GweTest.Chem.mwt_mwt_ob.csv"
if exist "GweTest.Chem.ob_gw_out_concentration.csv" del "GweTest.Chem.ob_gw_out_concentration.csv"
if exist "GweTest.Chem.OuterSolution.CSV" del "GweTest.Chem.OuterSolution.CSV"
if exist "GweTest.Chem.sft_budget" del "GweTest.Chem.sft_budget"
if exist "GweTest.Chem.sft_conc" del "GweTest.Chem.sft_conc"
if exist "GweTest.Chem.uzt_budget" del "GweTest.Chem.uzt_budget"
if exist "GweTest.Chem.uzt_conc" del "GweTest.Chem.uzt_conc"
if exist "GweTest.Chem.uzt-conc_ob.csv" del "GweTest.Chem.uzt-conc_ob.csv"
if exist "GweTest.Chem.uzt-uzt_ob.csv" del "GweTest.Chem.uzt-uzt_ob.csv"
if exist "GweTest.InnerSolution.CSV" del "GweTest.InnerSolution.CSV"
if exist "GweTest.LakConvergence.CSV" del "GweTest.LakConvergence.CSV"
if exist "GweTest.lst" del "GweTest.lst"
if exist "GweTest.maw_bud" del "GweTest.maw_bud"
if exist "GweTest.maw_head" del "GweTest.maw_head"
if exist "GweTest.mvr_budget" del "GweTest.mvr_budget"
if exist "GweTest.mvr_budget.csv" del "GweTest.mvr_budget.csv"
if exist "GweTest.OuterSolution.CSV" del "GweTest.OuterSolution.CSV"
if exist "GweTest.rvob_out_riv.csv" del "GweTest.rvob_out_riv.csv"
if exist "GweTest.sfr_budget" del "GweTest.sfr_budget"
if exist "GweTest.SfrConvergence.csv" del "GweTest.SfrConvergence.csv"
if exist "GweTest.stage" del "GweTest.stage"
if exist "GweTest.Temperature.cbc" del "GweTest.Temperature.cbc"
if exist "GweTest.Temperature.InnerSolution.CSV" del "GweTest.Temperature.InnerSolution.CSV"
if exist "GweTest.Temperature.lke_budget" del "GweTest.Temperature.lke_budget"
if exist "GweTest.Temperature.lke_budget.csv" del "GweTest.Temperature.lke_budget.csv"
if exist "GweTest.Temperature.lke_concentration_ob.csv" del "GweTest.Temperature.lke_concentration_ob.csv"
if exist "GweTest.Temperature.lke_temp" del "GweTest.Temperature.lke_temp"
if exist "GweTest.Temperature.lst" del "GweTest.Temperature.lst"
if exist "GweTest.Temperature.mve_budget" del "GweTest.Temperature.mve_budget"
if exist "GweTest.Temperature.mve_budget.csv" del "GweTest.Temperature.mve_budget.csv"
if exist "GweTest.Temperature.mwe_budget" del "GweTest.Temperature.mwe_budget"
if exist "GweTest.Temperature.mwe_mwe_ob.csv" del "GweTest.Temperature.mwe_mwe_ob.csv"
if exist "GweTest.Temperature.mwe_temp" del "GweTest.Temperature.mwe_temp"
if exist "GweTest.Temperature.mwe_temperature_ob.csv" del "GweTest.Temperature.mwe_temperature_ob.csv"
if exist "GweTest.Temperature.ob_gw_out_temperature.csv" del "GweTest.Temperature.ob_gw_out_temperature.csv"
if exist "GweTest.Temperature.OuterSolution.CSV" del "GweTest.Temperature.OuterSolution.CSV"
if exist "GweTest.Temperature.sfe_budget" del "GweTest.Temperature.sfe_budget"
if exist "GweTest.Temperature.sfe_mass_flow_ob.csv" del "GweTest.Temperature.sfe_mass_flow_ob.csv"
if exist "GweTest.Temperature.sfe_temp" del "GweTest.Temperature.sfe_temp"
if exist "GweTest.Temperature.uze_budget" del "GweTest.Temperature.uze_budget"
if exist "GweTest.Temperature.uze_temp" del "GweTest.Temperature.uze_temp"
if exist "GweTest.Temperature.uze-temp_ob.csv" del "GweTest.Temperature.uze-temp_ob.csv"
if exist "GweTest.Temperature.uze-uzt_ob.csv" del "GweTest.Temperature.uze-uzt_ob.csv"
if exist "GweTest.uzf_budget" del "GweTest.uzf_budget"
if exist "GweTest.UzfConvergence.CSV" del "GweTest.UzfConvergence.CSV"
if exist "GweTest.water_content" del "GweTest.water_content"
if exist "mfsim.lst" del "mfsim.lst"
"EnhancedTemplateProcessor.exe" GweTest.Temperature.esl.tpl GweTest.pval
mf6.exe
"Mf6ObsExtractor.exe" GweTest.Mf6ExtractValues
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

