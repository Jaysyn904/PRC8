@echo on

mkdir xml_temp
java -Xmx200m -jar tools\prc.jar itempropmaker
pause
java -cp tools\modpacker\nwn-tools.jar org.progeeks.nwn.XmlToGff others xml_temp/*
pause
:end
