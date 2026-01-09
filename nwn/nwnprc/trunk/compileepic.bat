@echo off
tools\nwn_script_comp.exe -c -j4 -y --verbose --max-include-depth=32 -d ".\epicspellobjs" --dirs ".\epicspellscripts,.\include" ".\epicspellscripts"
REM tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "epicspellobjs" "epicspellscripts\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_epicspells.hak .\epicspellscripts .\epicspellobjs
pause
:end
