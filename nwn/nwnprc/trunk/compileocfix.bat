@echo on
REM tools\nwn_script_comp.exe -c -j4 -y --max-include-depth=32 -d ".\ocfixerfobjs" --dirs ".\ocfixerf,.\include" ".\ocfixerf"
tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "ocfixerfobjs" "ocfixerf\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_ocfix.erf .\ocfixerf .\ocfixerfobjs
pause
:end
