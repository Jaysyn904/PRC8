@echo off
tools\nwn_script_comp.exe -c -j4 -y --verbose --max-include-depth=32 -d ".\raceobjs" --dirs ".\racescripts,.\include" ".\racescripts"

REM tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "raceobjs" "racescripts\*.nss"
pause
:end
