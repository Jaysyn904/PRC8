@echo on
REM tools\nwn_script_comp.exe -c -j4 -y --max-include-depth=32 -d ".\spellobjs" --dirs ".\spells,.\include" ".\spells"

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "spellobjs" "spells\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_spells.hak .\spells .\spellobjs
pause
:end
