@echo off

REM Grep for the message that means the db has been saved to disk
tools\grep.exe -Fq "Storing Bioware2DACache" "%NWN_DIR%"\logs\nwclientlog1.txt

REM If the message was not present, sleep 5 sec and recurse
if %ERRORLEVEL%==1 (
	tools\sleep.exe 5s
	precachemonitorloop.bat
) else (
	echo Done
)