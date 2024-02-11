@echo on

java -Xmx200m -jar tools\prc.jar spellbookmaker
@echo off
echo Change AMS_VERSION in prc_inc_switch.nss!
pause
if exist tlk\prc8_consortium.tlk.xml tools\xml2tlk.exe tlk\prc8_consortium.tlk.xml tlk\prc8_consortium.tlk

:end
