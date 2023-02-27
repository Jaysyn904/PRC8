@echo on

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "ocfixerfobjs" "ocfixerf\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc_ocfix.erf .\ocfixerf .\ocfixerfobjs
pause
:end
