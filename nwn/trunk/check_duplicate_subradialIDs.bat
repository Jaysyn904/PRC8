@echo on

java -Xmx200m -jar tools\prc.jar dupsubrad -f 7038 2das\spells.2da
pause
rem if exist tlk\prc_consortium.tlk.xml tools\xml2tlk.exe tlk\prc_consortium.tlk.xml tlk\prc_consortium.tlk

:end
