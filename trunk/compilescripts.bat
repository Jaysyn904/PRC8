@echo on

tools\nwnsc -w -i "include" -n "C:\Program Files (x86)\Steam\steamapps\common\Neverwinter Nights" -b "objs" "scripts\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc_scripts.hak .\scripts .\objs
pause
:end
