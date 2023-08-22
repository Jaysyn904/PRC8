@echo on

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "psionicsobjs" "psionics\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc_psionics.hak .\psionics .\psionicsobjs
pause
:end
