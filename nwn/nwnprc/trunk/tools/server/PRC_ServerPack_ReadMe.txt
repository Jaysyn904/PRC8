PRC Server Pack v1.8

This is an server package for the PRC, avalibale in self-install and manual-install editions. This should only be installed after the main PRC packages. To make full use of this you should be using PRC 3.2 or higher. 

More detailed install information in server_pack_install.html, mostly useful if doing a manual install.

This package includes:

NWNX            2.6.1
NWNX-core       2.7-beta4 (this is the dll)
NWNX-ODBC       0.9.2.5
NWNX-Letoscript 03+build 24
NWNX-Profiler   1.62
SQLite          3.7.10
Precacher       part of prc.jar

You do not need to download anything else, but for reference:
NWNX is avaliable from www.nwnx.org.
NWNX core, NWNX profiler and NWNX-ODBC are available from Virusman's site (see http://www.nwnx.org/phpBB2/viewtopic.php?t=1141)
NWNX-Letoscript is avaliable from http://sourceforge.net/projects/leto
Source code for NWNX and its plugins is available from the above sites.
SQLite is avaliable from www.sqlite.org.
The Precacher is based on a version made for the PRC by Yuritch, but rewritten into java by the PRC. As a .jar file its source code and the source code for sqlite are included in the .jar.

For full instructions, see the PRC Web site http://www.nwn2prc.com/index.php?location=manual . In particular see the PRC Server Pack installation instructions (PRC_ServerPack_Install.html) and http://www.nwn2prc.com/index.php?location=manual&lang=en&section=installation&page=prc_server_pg01 (these are a little out of date but may be useful).

Changelog
v1.8.3  Updated Changelog files. Updated PRC.JAR precacher file to be compatible with latest version of SQLite; Provided latest versions of sqlite.exe and nwnx-odbc.dll. Updated batch scripting and installation files.
v1.8    Removed NWNX-InvFixpl as no longer needed. Removed linux nwnx as there's now a precompiled binary (see http://www.nwnx.org/phpBB2/viewtopic.php?t=1038).
v1.7    Installation instructions added, plus precacher is now much faster
v1.6    Removed a few unneeded bioware 2das, updated rest to NWN 1.68, added NWNx for Linux to the manual-install version
v1.3    New version to go with PRC 3.0c & NWN 1.67
v1.2    Replaced Yuriched precacher with a java version
        Removed many bioware 2das because they arent needed and dont meet biowares specifications
v1.1    Fixed issue with incorect version of SQLite
        Added SSed step to filter output from precacher to be SQLite compatible
        Added bioware 2das to the cacher
        Added override\directory.2da creation
v1.0    Initial Release
