javac -Xlint:all -g -source 11 -target 11 prc/*.java prc/autodoc/*.java prc/utils/*.java prc/makedep/*.java
xcopy "Main Manual Files" manual /iey
java -Xmx1024m -Xms300m -cp "imageio_tga_1.1.0.jar;." prc/autodoc/Main
