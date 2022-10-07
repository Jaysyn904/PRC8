@echo off

SETLOCAL

echo ------------------------------------------------------------------------
echo - This script compiles one file. This allows testing of includes using -
echo - a single script rather than a full compile.                          -
echo - marked as changed in a later CVS commit.                             -
echo -                                                                      -
echo - The directory the script is located in needs to be specified         -
echo - relative to the main nwnprc directory eg. scripts\prc_onenter        -
echo ------------------------------------------------------------------------

:start

echo Please give the name of the script to compile, without the terminating ".nss".

SET /P target=

tools\nwnnsscomp -cgoq -i include %target%.nss

echo Do you want to compile another file?
SET /P cont=[y/N]

IF NOT %cont%==y GOTO end
SET target=
SET cont=
GOTO start

:end

ENDLOCAL