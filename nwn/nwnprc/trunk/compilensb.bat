@echo on
REM tools\nwn_script_comp.exe -c -j4 -y --max-include-depth=32 -d ".\newspellbookobjs" --dirs ".\newspellbook,.\include" ".\newspellbook"
tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "newspellbookobjs" "newspellbook\*.nss"
tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_nsb.hak .\newspellbook .\newspellbookobjs
:end
