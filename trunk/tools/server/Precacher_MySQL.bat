rd /s /q precacher2das
mkdir precacher2das
7za x bioware2das.7z -oprecacher2das
erf -x hak\prc_2das.hak 
erf -x hak\prc_race.hak
copy cls_feat*.2da precacher2das\*.2da
copy cls_skill*.2da precacher2das\*.2da
copy race_feat*.2da precacher2das\*.2da
copy spells.2da precacher2das\*.2da
copy racialappear.2da precacher2das\*.2da
copy racialtypes.2da precacher2das\*.2da
copy classes.2da precacher2das\*.2da
copy feat.2da precacher2das\*.2da
copy domains.2da precacher2das\*.2da
copy appearance.2da precacher2das\*.2da
copy portraits.2da precacher2das\*.2da
copy soundset.2da precacher2das\*.2da
copy wingmodel.2da precacher2das\*.2da
copy tailmodel.2da precacher2das\*.2da
copy gender.2da precacher2das\*.2da
copy hen_companion.2da precacher2das\*.2da
copy hen_familiar.2da precacher2das\*.2da
copy custom2das\*.2da precacher2das\*.2da
del *.2da
del *.nss
del *.ncs
java -Xmx100m -jar prc.jar 2datosql precacher2das MySQL
rd /s /q precacher2das
@pause

rem del 7za.exe
rem del erf.exe
rem del bioware2das.7z
rem del prc.jar
rem del sqlite.exe
rem del Precacher_SQLite.bat
rem del Precacher_MySQL.bat
