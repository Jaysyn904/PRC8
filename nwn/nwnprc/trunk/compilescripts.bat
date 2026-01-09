@echo on
REM tools\nwn_script_comp.exe -c -j4 -y --max-include-depth=32 -d ".\objs" --dirs ".\scripts,.\include" ".\scripts"

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "objs" "scripts\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_scripts.hak .\scripts .\objs
pause
:end
