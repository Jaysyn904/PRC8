@echo off

SETLOCAL

echo ------------------------------------------------------------------------
echo - This script resaves 2da files. The purpose is to keep whitespace     -
echo - uniform, thus preventing lines where just whitespace changed being   -
echo - marked as changed in a later CVS commit.                             -
echo -                                                                      -
echo - If the tool you use for 2da editing does not create similar          -
echo - whitespace as prc.jar 2da utility does, please run this before       -
echo - committing.                                                          -
echo -                                                                      -
echo - All the files are assumed to be located under 2das\                  -
echo ------------------------------------------------------------------------

:start

echo Please give the name of the 2da to resave, without the terminating ".2da".

SET /P target=

java -Xmx200m -jar tools\prc.jar 2da -r 2das\%target%.2da

echo Do you want to resave another 2da file?
SET /P cont=[y/N]

IF NOT %cont%==y GOTO end
SET target=
SET cont=
GOTO start

:end

ENDLOCAL