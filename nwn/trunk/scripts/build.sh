#!/bin/sh

twodas=`ls ../2das/*.2da | grep -v CVS | tr '\n' ' '`
gfxs=`ls -d ../gfx/* | grep -v CVS | tr '\n' ' '`
others=`ls -d ../others/* | grep -v CVS | tr '\n' ' '`
scripts=`ls *.nss | tr '\n' ' '`

# Take out the include files
#scripts=""
#for i in $tmp_scripts ; do
#	tst=`grep -w main "$i"`
#	if test "$tst" ; then
#		scripts="$scripts$i "
#	fi
#done

sed "s#~~~scripts~~~#$scripts#g" Makefile | sed "s#~~~2das~~~#$twodas#g" | sed "s#~~~others~~~#$others#g" | sed "s#~~~gfxs~~~#$gfxs#g" > Makefile.temp
make -f Makefile.temp $*
rm -f Makefile.temp
