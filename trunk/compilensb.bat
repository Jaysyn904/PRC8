@echo on

tools\nwnsc -w -i "include" -n "C:\Program Files (x86)\Steam\steamapps\common\Neverwinter Nights" -b "newspellbookobjs" "newspellbook\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc_newspellbook.hak .\newspellbook .\newspellbookobjs
:end
