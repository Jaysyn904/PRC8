COMPILER = javac
FLAGS = -Xlint:all -g -source 11 -target 11
RUNPARAMS = -Xmx300m -Xms300m -cp "imageio_tga_1.1.0.jar\;."
TARGET = prc/*.java \
		 prc/autodoc/*.java \
		 prc/utils/*.java \
		 prc/makedep/*.java


default:
	$(COMPILER) $(FLAGS) $(TARGET)

jar:
	jar -cvfm prc.jar prc\\prc.mf prc\\*


run:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main

run_quiet:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main -q

run_no_spinner:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main -s

run_log:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main -s > log.txt

run_icons:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main -i

run_icons_log:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main -is > log.txt

run_icons_quiet:
	xcopy /iey "Main Manual Files" manual
	java $(RUNPARAMS) prc/autodoc/Main -iq
