@echo on

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "spellobjs" "spells\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_spells.hak .\spells .\spellobjs
pause
:end
