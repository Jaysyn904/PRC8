@echo on

tools\nwnsc -w -i "include" -n "C:\Program Files (x86)\Steam\steamapps\common\Neverwinter Nights" -b "ocfixerfobjs" "ocfixerf\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc_ocfix.erf .\ocfixerf .\ocfixerfobjs
pause
:end
