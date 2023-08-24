@echo on

java -Xmx2000m -jar tools\prc_psi.jar amsspellbookmaker -psi
pause
if exist tlk\prc_consortium.tlk.xml tools\xml2tlk.exe tlk\prc_consortium.tlk.xml tlk\prc_consortium.tlk

:end
