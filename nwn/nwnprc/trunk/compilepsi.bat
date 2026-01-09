@echo on
REM tools\nwn_script_comp.exe -c -j4 -y --max-include-depth=32 -d ".\psionicsobjs" --dirs ".\psionics,.\include" ".\psionics"

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "psionicsobjs" "psionics\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_psionics.hak .\psionics .\psionicsobjs
pause
:end
