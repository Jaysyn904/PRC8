del /q module
del /q xmltemp
mkdir module
mkdir xmltemp

copy "C:\Games\NeverwinterNights\NWN\modules\prctrials.mod" prctrials.mod
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.ModReader prctrials.mod xmltemp
@java -cp "C:\Documents and Settings\user\Desktop\PRC Stuff\rmg\tools\modpacker\nwn-tools.jar" org.progeeks.nwn.GffToXml module xmltemp/*  
del /q module\*.ncs

pause