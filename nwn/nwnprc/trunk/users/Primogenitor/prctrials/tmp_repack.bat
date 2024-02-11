
del /q gfftemp
mkdir gfftemp

@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.XmlToGff gfftemp module/*
copy ..\..\..\tools\nwnnsscomp.exe gfftemp\nwnnsscomp.exe
cd gfftemp
nwnnsscomp -g -i "C:\Documents and Settings\user\Desktop\PRC Stuff\prc\include" *.nss
del nwnnsscomp.exe
cd..
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker gfftemp prctrials.mod
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModPacker hak prctrials.hak

copy prctrials.mod "C:\Games\NeverwinterNights\NWN\modules\prctrials.mod"
copy prctrials.hak "C:\Games\NeverwinterNights\NWN\hak\prctrials.hak"

pause
cd C:\Games\NeverwinterNights\NWN
nwmain.exe +TestNewModule "prctrials"