mkdir 2da
mkdir tlk
copy ..\nwnprc\2das\*.2da 2da\*.2da
copy ..\nwnprc\race2das\*.2da 2da\*.2da
copy ..\nwnprc\craft2das\*.2da 2da\*.2da
..\nwnprc\tools\xml2tlk.exe ..\nwnprc\tlk\prc_consortium.tlk.xml ..\nwnprc\tlk\prc_consortium.tlk
copy ..\nwnprc\tlk\*.tlk tlk\*.tlk
xcopy /iey "Main Manual Files" manual

nmake -NOLOGO

nmake -NOLOGO run_icons
pause