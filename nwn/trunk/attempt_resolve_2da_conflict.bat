@echo off

SETLOCAL

echo ---------------------------------------------------------------------------
echo -This script requires 3 files                                             -
echo -1) An unedited copy of the file you had edited at the version you had    -
echo -    before update. ie. if the backup of your edited file is named        -
echo -    spells.2da.1.350, this file would be a clean copy of spells.2da      -
echo -    version 1.350                                                        -
echo -2) Your edited copy. The backup created during the update will work here.-
echo -3) A clean copy of the newest version of the file.                       -
echo -                                                                         -
echo -This script will calculate a diff between 1) and 2) and use it to patch  -
echo -3). The diff will be stored in a file named diffile in case you need to  -
echo -review it.                                                               -
echo -All the files are assumed to be located under 2das\                       -
echo ---------------------------------------------------------------------------

echo Please give the name of the unedited copy.
SET /P base=

echo Please give the name of the edited copy.
SET /P mod=

echo Please give the name of the clean update.
SET /P target=

tools\diff --ignore-space-change --unified 2das\%base% 2das\%mod% > diffile

echo Doing a dry run to see if the patch will work

tools\cat diffile | tools\patch --ignore-whitespace --dry-run 2das\%target%

echo Do you want to continue?
SET /P cont=[y/N]
IF NOT %cont%==y GOTO end

tools\cat diffile | tools\patch --ignore-whitespace 2das\%target%

:end

ENDLOCAL