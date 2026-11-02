#!/bin/sh

# Passes any make target (all, scripts, install, test, clean) to Makefile.temp
# after populating ~~~scripts~~~ with entry-point .nss files defining main().
tmp_scripts=`ls *.nss | tr '\n' ' '`

# Take out the include files
scripts=""
for i in $tmp_scripts ; do
	tst=`grep -w main "$i"`
	if test "$tst" ; then
		scripts="$scripts$i "
	fi
done

sed "s#~~~scripts~~~#$scripts#g" Makefile > Makefile.temp
make -f Makefile.temp $*
ret=$?
rm -f Makefile.temp
exit $ret
