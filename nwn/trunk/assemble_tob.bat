@echo on

java -Xmx200m -jar tools\prc.jar amsspellbookmaker -tob
pause
if exist tlk\prc_consortium.tlk.xml tools\xml2tlk.exe tlk\prc_consortium.tlk.xml tlk\prc_consortium.tlk

:end
