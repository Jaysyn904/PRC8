#!/bin/bash
#
# @echo off
#  This file is a template makefile used to create the real makefile that
#  that is passed to NMAKE to buld the PRC project.  The batch file
#  make.bat creates the lists of source files and uses ssed to merge them
#  into this file where the ~~~xxx~~~ placeholders are, then runs the
#  resultant makefile to build the project.  Thus the bat file and this
#  makefile template form a pair of files that do the build in tandem.
#  The following directory tree is what the files expect to see:
# 
#  scripts - contains all of the source scripts
# 
#  2das - Contains all of the source 2da files
# 
#  tlk - Contains the custom tlk file
# 
#  gfx - Contains all of the graphic images, icons, textures, etc. that
#  go in the prc pack.
# 
#  others - Contains various other files that go in the hak such as
#  creature blueprints, item blueprints, etc.
# 
#  tools - Contains all of the EXE files used by the makefile to do the build.
# 
#  objs - All of hte compiled script object files are placed here.  If this
#  directory does not exist it will be created.
# 
#  There is some outside information that the makefile needs to know, it expects
#  this information to be export in variables in the config.make file.  The variables
#  it expects to be export are as follows:
# 
#  NWN_DIR - The folder where you have NWN installed.
# 
#  PRC_VERSION - The version number of the PRC build, this is only used for the RAR
#  file name
# 
#  If just run w/o any arguments the makefile will build all haks/erfs/etc. and
#  install them in the appropriate spots in your NWN directory.  The following
#  additional build targets are supported, they are passed on the command
#  line to make.bat, eg. "make rar"
# 
#  hak - This is the same as specifying no arguments, i.e. the haks/erfs/etc. are
#  built and are installed in the NWN directory.
# 
#  rar - Does what hak does, then builds a rar file containing all of the output
#  files.
# 
#
#  let the user know we are building a makefile, this could take a while.
echo Building makefile
#
#  make directories
mkdir objs 2>nul
mkdir epicspellobjs 2>nul
mkdir raceobjs 2>nul
mkdir psionicsobjs 2>nul
mkdir spellobjs 2>nul
mkdir newspellbookobjs 2>nul
mkdir ocfixerfobjs 2>nul
#
#  generate temporary files for each of the source sets
#  scripts, graphics files, 2das, and misc. other files.
#  each of these temp files will be stuffed into a macro
#  in the makefile.
dir -1 ./erf                    | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/erf\//g'              >erffiles.temp
dir -1 ./scripts |grep nss           | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/scripts\//g'          >scripts.temp
dir -1 ./spells | grep nss            | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/spells\//g'           >spells.temp
dir -1 ./epicspellscripts | grep nss  | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/epicspellscripts\//g' >epicspellscripts.temp
dir -1 ./racescripts | grep nss       | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/racescripts\//g'      >racescripts.temp
dir -1 ./psionics | grep nss          | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/psionics\//g'         >psionics.temp
dir -1 ./gfx                    | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/gfx\//g'              >gfx.temp
dir -1 ./2das                   | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/2das\//g'             >2das.temp
dir -1 ./race2das               | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/race2das\//g'         >race2das.temp
dir -1 ./others                 | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/others\//g'           >others.temp
dir -1 ./Craft2das              | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/Craft2das\//g'        >craft2das.temp
dir -1 ./include                | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/include\//g'          >include.temp
dir -1 ./newspellbook | grep nss      | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/newspellbook\//g'     >newspellbook.temp
dir -1 ./ocfixerf               | sort | grep -E "^[^.]" | ssed -R '$! {s/$/ \\/g};s/^/ocfixerf\//g'         >ocfix.temp
#
#  use FINDSTR to find script files with "void main()" or "int StartingConditional()"
#  in them, these are the ones we want to compile.
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./scripts/*.nss          | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/scripts\//objs\//g'                   >objs.temp
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./spells/*.nss           | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/spells\//spellobjs\//g'               >spellobjs.temp
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./epicspellscripts/*.nss | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/epicspellscripts\//epicspellobjs\//g' >epicspellobjs.temp
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./racescripts/*.nss      | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/racescripts\//raceobjs\//g'           >raceobjs.temp
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./psionics/*.nss         | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/psionics\//psionicsobjs\//g'          >psionicsobjs.temp
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./newspellbook/*.nss     | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/newspellbook\//newspellbookobjs\//g'  >newspellbookobjs.temp
grep -l -i -E 'void *main *( *)|int *StartingConditional *( *)' ./ocfixerf/*.nss         | sort | ssed -R '$! {s/$/ \\/g};s/nss/ncs/g;s/ocfixerf\//ocfixerfobjs\//g'          >ocfixobjs.temp
#
#  Now using our generic makefile as a base, glue all of the temp files into it making
#  a fully formatted makefile we can run nmake on.
cat makefile.linux.template | ssed -R '/~~~erffiles~~~/r erffiles.temp' | ssed -R '/~~~scripts~~~/r scripts.temp' | ssed -R '/~~~spells~~~/r spells.temp' | ssed -R '/~~~epicspellscripts~~~/r epicspellscripts.temp' | ssed -R '/~~~racescripts~~~/r racescripts.temp' | ssed -R '/~~~psionicsscripts~~~/r psionics.temp' | ssed -R '/~~~newspellbook~~~/r newspellbook.temp' | ssed -R '/~~~ocfix~~~/r ocfix.temp' | ssed -R '/~~~2das~~~/r 2das.temp' | ssed -R '/~~~craft2das~~~/r craft2das.temp' | ssed -R '/~~~race2das~~~/r race2das.temp' | ssed -R '/~~~gfx~~~/r gfx.temp' | ssed -R '/~~~others~~~/r others.temp' | ssed -R '/~~~objs~~~/r objs.temp' | ssed -R '/~~~spellobjs~~~/r spellobjs.temp' | ssed -R '/~~~epicspellobjs~~~/r epicspellobjs.temp' | ssed -R '/~~~raceobjs~~~/r raceobjs.temp' | ssed -R '/~~~psionicsobjs~~~/r psionicsobjs.temp' | ssed -R '/~~~newspellbookobjs~~~/r newspellbookobjs.temp' | ssed -R '/~~~ocfixobjs~~~/r ocfixobjs.temp' | ssed -R '/~~~include~~~/r include.temp' | ssed -R 's/~~~[a-zA-Z0-9_]+~~~/ \\/g' > makefile.linux.temp
#
# SETLOCAL
#
#  set local variables for the source and object trees.
export MAKEERFPATH=erf
export MAKE2DAPATH=2das
export MAKESCRIPTPATH=scripts
export MAKESPELLSPATH=spells
export MAKESPELLOBJSPATH=spellobjs
export MAKEEPICSPELLSCRIPTPATH=epicspellscripts
export MAKEOBJSPATH=objs
export MAKEEPICSPELLOBJSPATH=epicspellobjs
export MAKETLKPATH=tlk
export MAKECRAFT2DASPATH=Craft2das
export MAKERACE2DASPATH=race2das
export MAKERACESRCPATH=racescripts
export MAKERACEOBJSPATH=raceobjs
export MAKEPSIONICSSRCPATH=psionics
export MAKEPSIONICSOBJSPATH=psionicsobjs
export MAKEMISCPATH=others
export MAKENEWSPELLBOOKPATH=newspellbook
export MAKENEWSPELLBOOKOBJSPATH=newspellbookobjs
export MAKEOCFIXERFPATH=ocfixerf
export MAKEOCFIXERFOBJSPATH=ocfixerfobjs
#
#  before doing the real build build the dependencies for include files.
make -f makefile.linux.temp MAKEFILE=makefile.linux.temp depends
#
#  the objs path is not part of CVS, make sure it exists.
mkdir $MAKEOBJSPATH >nul 2>nul
#
#  run nmake to do the build.
make -d -f makefile.linux.temp $1 $2 $3 $4 $5 $6 $7 $8 $9 > debug.txt
#
# ENDLOCAL
#
#  delete temp files
rm -f erffiles.temp
rm -f scripts.temp
rm -f spells.temp
rm -f epicspellscripts.temp
rm -f gfx.temp
rm -f 2das.temp
rm -f others.temp
rm -f objs.temp
rm -f spellobjs.temp
rm -f epicspellobjs.temp
rm -f craft2das.temp
rm -f race2das.temp
rm -f racescripts.temp
rm -f raceobjs.temp
rm -f psionics.temp
rm -f psionicsobjs.temp
rm -f include.temp
rm -f newspellbook.temp
rm -f newspellbookobjs.temp
rm -f ocfix.temp
rm -f ocfixobjs.temp
#
# sleep
