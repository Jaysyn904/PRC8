@echo off
REM This file is a template makefile used to create the real makefile that
REM that is patools\ssed to NMAKE to buld the PRC project.  The batch file
REM make.bat creates the lists of source files and uses tools\ssed to merge them
REM into this file where the ~~~xxx~~~ placeholders are, then runs the
REM resultant makefile to build the project.  Thus the bat file and this
REM makefile template form a pair of files that do the build in tandem.
REM The following directory tree is what the files expect to see:
REM
REM scripts - contains all of the source scripts
REM
REM 2das - Contains all of the source 2da files
REM
REM tlk - Contains the custom tlk file
REM
REM gfx - Contains all of the graphic images, icons, textures, etc. that
REM go in the prc pack.
REM
REM others - Contains various other files that go in the hak such as
REM creature blueprints, item blueprints, etc.
REM
REM tools - Contains all of the EXE files used by the makefile to do the build.
REM
REM objs - All of hte compiled script object files are placed here.  If this
REM directory does not exist it will be created.
REM
REM There is some outside information that the makefile needs to know, it expects
REM this information to be set in variables in the config.make file.  The variables
REM it expects to be set are as follows:
REM
REM NWN_DIR - The folder where you have NWN installed.
REM
REM PRC_VERSION - The version number of the PRC build, this is only used for the RAR
REM file name
REM
REM If just run w/o any arguments the makefile will build all haks/erfs/etc. and
REM install them in the appropriate spots in your NWN directory.  The following
REM additional build targets are supported, they are patools\ssed on the command
REM line to make.bat, eg. "make rar"
REM
REM hak - This is the same as specifying no arguments, i.e. the haks/erfs/etc. are
REM built and are installed in the NWN directory.
REM
REM rar - Does what hak does, then builds a rar file containing all of the output
REM files.
REM

REM let the user know we are building a makefile, this could take a while.
echo Building makefile

REM make directories
md objs
md epicspellobjs
md raceobjs
md psionicsobjs
md spellobjs

REM generate temporary files for each of the source sets
REM scripts, graphics files, 2das, and misc. other files.
REM each of these temp files will be stuffed into a macro
REM in the makefile.
dir /b erf | tools\ssed -R "$! {s/$/ \\/g};s/^/erf\\/g" >erffiles.temp
dir /b scripts\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/^/scripts\\/g" >scripts.temp
dir /b spells\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/^/spells\\/g" >spells.temp
dir /b epicspellscripts\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/^/epicspellscripts\\/g" >epicspellscripts.temp
dir /b racescripts\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/^/racescripts\\/g" >racescripts.temp
dir /b psionics\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/^/psionics\\/g" >psionics.temp
dir /b gfx | tools\ssed -R "$! {s/$/ \\/g};s/^/gfx\\/g" >gfx.temp
dir /b 2das | tools\ssed -R "$! {s/$/ \\/g};s/^/2das\\/g" >2das.temp
dir /b race2das | tools\ssed -R "$! {s/$/ \\/g};s/^/race2das\\/g" >race2das.temp
dir /b others | tools\ssed -R "$! {s/$/ \\/g};s/^/others\\/g" >others.temp
dir /b craft2das | tools\ssed -R "$! {s/$/ \\/g};s/^/craft2das\\/g" >craft2das.temp
dir /b include | tools\ssed -R "$! {s/$/ \\/g};s/^/include\\/g" >include.temp

REM use FINDSTR to find script files with "void main()" or "int StartingConditional()"
REM in them, these are the ones we want to compile.
tools\grep -G -l --regexp="void *main *( *)" --regexp="int *StartingConditional *( *)" scripts\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/nss/ncs/g;s/scripts\\/objs\\/g" >objs.temp
tools\grep -G -l --regexp="void *main *( *)" --regexp="int *StartingConditional *( *)" spells\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/nss/ncs/g;s/spells\\/spellobjs\\/g" >spellobjs.temp
tools\grep -G -l --regexp="void *main *( *)" --regexp="int *StartingConditional *( *)" epicspellscripts\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/nss/ncs/g;s/epicspellscripts\\/epicspellobjs\\/g" >epicspellobjs.temp
tools\grep -G -l --regexp="void *main *( *)" --regexp="int *StartingConditional *( *)" racescripts\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/nss/ncs/g;s/racescripts\\/raceobjs\\/g" >raceobjs.temp
tools\grep -G -l --regexp="void *main *( *)" --regexp="int *StartingConditional *( *)" psionics\*.nss | tools\ssed -R "$! {s/$/ \\/g};s/nss/ncs/g;s/psionics\\/psionicsobjs\\/g" >psionicsobjs.temp

REM Now using our generic makefile as a base, glue all of the temp files into it making
REM a fully formatted makefile we can run nmake on.
type makefile.template.winold | tools\ssed -R "/~~~erffiles~~~/r erffiles.temp" | tools\ssed -R "/~~~scripts~~~/r scripts.temp" | tools\ssed -R "/~~~spells~~~/r spells.temp" | tools\ssed -R "/~~~epicspellscripts~~~/r epicspellscripts.temp" | tools\ssed -R "/~~~racescripts~~~/r racescripts.temp" | tools\ssed -R "/~~~psionicsscripts~~~/r psionics.temp" | tools\ssed -R "/~~~2das~~~/r 2das.temp" | tools\ssed -R "/~~~craft2das~~~/r craft2das.temp" | tools\ssed -R "/~~~race2das~~~/r race2das.temp" | tools\ssed -R "/~~~gfx~~~/r gfx.temp" | tools\ssed -R "/~~~others~~~/r others.temp" | tools\ssed -R "/~~~objs~~~/r objs.temp" | tools\ssed -R "/~~~spellobjs~~~/r spellobjs.temp" | tools\ssed -R "/~~~epicspellobjs~~~/r epicspellobjs.temp" | tools\ssed -R "/~~~raceobjs~~~/r raceobjs.temp" | tools\ssed -R "/~~~psionicsobjs~~~/r psionicsobjs.temp" | tools\ssed -R "/~~~include~~~/r include.temp" | tools\ssed -R "s/~~~[a-zA-Z0-9_]+~~~/ \\/g" > makefile.temp

rem SETLOCAL

REM set local variables for the source and object trees.
SET MAKEERFPATH=erf
SET MAKE2DAPATH=2das
SET MAKESCRIPTPATH=scripts
SET MAKESPELLSPATH=spells
SET MAKESPELLOBJSPATH=spellobjs
SET MAKEEPICSPELLSCRIPTPATH=epicspellscripts
SET MAKEOBJSPATH=objs
SET MAKEEPICSPELLOBJSPATH=epicspellobjs
SET MAKETLKPATH=tlk
SET MAKECRAFT2DASPATH=craft2das
SET MAKERACE2DASPATH=race2das
SET MAKERACESRCPATH=racescripts
SET MAKERACEOBJSPATH=raceobjs
SET MAKEPSIONICSSRCPATH=psionics
SET MAKEPSIONICSOBJSPATH=psionicsobjs

REM before doing the real build build the dependencies for include files.
tools\nmake -NOLOGO -f makefile.temp MAKEFILE=makefile.temp depends

REM the objs path is not part of CVS, make sure it exists.
mkdir %MAKEOBJSPATH% >nul 2>nul

REM run nmake to do the build.
tools\nmake -NOLOGO -f makefile.temp %1 %2 %3 %4 %5 %6 %7 %8 %9

REM ENDLOCAL

REM delete temp files
del erffiles.temp
del scripts.temp
del spells.temp
del epicspellscripts.temp
del gfx.temp
del 2das.temp
del others.temp
del objs.temp
del spellobjs.temp
del epicspellobjs.temp
del craft2das.temp
del race2das.temp
del racescripts.temp
del raceobjs.temp
del psionics.temp
del psionicsobjs.temp
del include.temp
del makefile.temp
