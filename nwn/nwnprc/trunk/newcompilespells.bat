REM echo Current dir: %cd%
REM dir ..
REM dir ..\psionics
REM pause

@ECHO OFF

cls

REM nwn_script_comp.exe -c -j4 -y -O0 --root "C:\Games\Steam\steamapps\common\Neverwinter Nights" --dirs "C:\Users\Jason\Documents\Neverwinter Nights\modules\temp0,D:\NWN Repos\PRC8\nwn\nwnprc\trunk\include" "C:\Users\Jason\Documents\Neverwinter Nights\modules\temp0"

REM nwn_script_comp.exe -c -j4 -y --max-include-depth=32 ^
  REM --root "C:\Games\Steam\steamapps\common\Neverwinter Nights" ^
  REM --dirs ".\psionics,.\include" ^
  REM -d ".\psionicsobjs" ^
  REM ".\psionics"

nwn_script_comp.exe -c -j4 -y . --max-include-depth=32 -d ".\spellobjs" --dirs ".\spells,.\include" ".\spells"


REM :loop
REM "C:\NWN Work\nwnsc.exe" -s -o -w -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -i "C:\Users\Jason\Documents\Neverwinter Nights\modules\temp0";"D:\NWN Repos\PRC8\nwn\nwnprc\trunk\include" "C:\Users\Jason\Documents\Neverwinter Nights\modules\temp0\*.nss"
REM if %errorLevel% == -1 goto :loop
pause



REM @echo on

REM tools\nwnsc -w -i "include" -n "C:\Games\Steam\steamapps\common\Neverwinter Nights" -b "psionicsobjs" "psionics\*.nss"
REM tools\nwn_erf.exe -e hak --quiet -c -f CompiledResources\prc8_psionics.hak .\psionics .\psionicsobjs
REM pause
REM :end