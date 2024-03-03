@echo on

tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "newspellbookobjs" "newspellbook\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_nsb.hak .\newspellbook .\newspellbookobjs
:end
