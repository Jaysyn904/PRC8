@echo on

java -Xmx2000m -jar tools\prc_psi.jar amsspellbookmaker -psi
pause
if exist tlk\prc8_consortium.tlk.xml tools\xml2tlk.exe tlk\prc8_consortium.tlk.xml tlk\prc8_consortium.tlk

:end
