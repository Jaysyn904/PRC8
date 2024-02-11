@echo on

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "epicspellobjs" "epicspellscripts\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_epicspells.hak .\epicspellscripts .\epicspellobjs
pause
:end
