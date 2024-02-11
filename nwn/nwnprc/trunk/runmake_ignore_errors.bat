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

SETLOCAL

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
SET MAKEMISCPATH=others
SET MAKENEWSPELLBOOKPATH=newspellbook
SET MAKENEWSPELLBOOKOBJSPATH=newspellbookobjs

REM run nmake to do the build.
tools\nmake -NOLOGO -k -f makefile.temp IGNOREERRORS=true %1 %2 %3 %4 %5 %6 %7 %8 %9

notepad compile_errors.log
del compile_errors.log

ENDLOCAL

pause