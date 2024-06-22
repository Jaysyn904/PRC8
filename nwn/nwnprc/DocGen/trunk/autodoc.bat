make
xcopy "Main Manual Files" manual /iey
java -Xmx1024m -Xms300m -cp "imageio_tga_1.1.0.jar;." prc/autodoc/Main
