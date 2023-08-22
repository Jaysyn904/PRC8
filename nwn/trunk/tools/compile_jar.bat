javac prc\prc\*.java prc\prc\autodoc\*.java prc\prc\makedep\*.java prc\prc\utils\*.java
cd prc
jar -cvfm ..\prc.jar ..\manifest.txt *.*
pause