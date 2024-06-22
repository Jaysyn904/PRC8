Manual generator:

To use the Autodoc, create directories 2da/, tlk/ and rawicons/ in
the location you will be running it from. This location should also
contain the directory templates/ and the file settings from the CVS.
Make a copy of Main Manual Files/ called manual/

Place dialog.tlk and prc_consortium.tlk equivalents for each language
specified in settings in tlk/. Place all class, domain, (master)feat,
skill and spell icons (no scrolls required) in rawicons/.

Place the following 2das in 2da/

From NWN base:

    racialtypes.2da
    all race_feat_*.2da
    all cls_*.2da
    all *.tlk

From the PRC:

    classes.2da
    domains.2da
    feat.2da
    masterfeats.2da
    skills.2da
    spells.2da

    all cls_*.2da
    all craft_*.2da


If you have make installed, run "make" and "make run" to generate the manual.
There are other run options present in the makefile for those interested.
If you do not have make, run
	javac -source 1.5 -target 1.5 prc/autodoc/*.java
and
	java -Xmx300m -Xms300m prc/autodoc/Main

use parameters --help or -? to get info about other possible parameters.




-------------------------------------------------------------------------------
Script generator:

Use:
Compile the CodeGen class.
Run it:
	java CodeGen namePrefix templatePath 2daPaths...

where namePrefix   = the base name that all the resulting scripts will share
      templatePath = the filename of the template used to generate the scripts
      2daPaths...  = any number of filenames of 2das used to fill in the
                     blanks in the template

The template consists of normal text with the locations to be replaced with
texts from the 2das marked with ~~~Identifier~~~, where Identifier is the label
of a colum from one of the 2das. The label matching is case-insensitive.

The 2das are applied in the order given. This only has effect on the filename,
which is built up from the namePrefix + Suffix column of each of the 2das
where it is present + .nss, unless you add a new identifier from the 2da.

The 2das may contain any number of columns. Each column's label is matched
against a location marked for replacement in the template. If a column
labeled Suffix is present, it's value is added to the filename as described
above.


See codegen_example -directory for example template and 2das. To see the
results from it, run (replace \ with / if not running on windoze)

	java CodeGen exa_ codegen_example\example.nss codegen_example\Foo.2da codegen_example\Bar.2da

## Build Docs

As it currently goes, this seems to run best on windows (`xcopy` is required).  There is a makefile, but xcopy + make
are not cooperating with each other, so here are the commands to build the docs.

```commandline
make
xcopy "Main Manual Files" manual /iey
java -Xmx1024m -Xms300m -cp "imageio_tga_1.1.0.jar;." prc/autodoc/Main
```

This has been conveniently placed in a batch file called `autodoc.bat` for Windows users.

## Testing the Site

You'll want to use a server to host the docs so you can load them correctly.  I like python for this

```commandline
python -m http.server
```