@echo on

tools\nwnsc -w -i "include" -n "C:\Program Files (x86)\Steam\steamapps\common\Neverwinter Nights" -b "epicspellobjs" "epicspellscripts\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc_epicspells.hak .\epicspellscripts .\epicspellobjs
pause
:end
