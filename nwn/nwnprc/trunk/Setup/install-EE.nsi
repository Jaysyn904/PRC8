; Script generated with the Venis Install Wizard

!ifndef PRCVERSION
	!define PRCVERSION ""
!endif

!ifndef PRCINSTALLVERSION
	!define PRCINSTALLVERSION ""
!endif

; Define your application name
!define APPNAME "PRC"
!define APPNAMEANDVERSION "PRC ${PRCINSTALLVERSION}"

; Enable LZMA compression for the smallest EXE.
SetCompressor lzma

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir ""
; The text to prompt the user to enter a directory
DirText "This will install the Player Resource Consortium into your Neverwinter Nights install. $\r$\n$\nPlease choose your NWN folder in Documents. The format usually looks like the example below. $\r$\n$\nC:\Users\[Username]\Documents\Neverwinter Nights"
OutFile "..\CompiledResources\PRC${PRCVERSION}.exe"

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_TEXT "The PRC is now installed. You can now run the PRC Module Updater to add the PRC to modules. It is in your Neverwinter Nights/PRC folder."
;!define MUI_FINISHPAGE_RUN_TEXT "Install the PRC in modules now"
;!define MUI_FINISHPAGE_RUN "$INSTDIR\PRC\PRCModuleUpdater.exe"
;!define MUI_FINISHPAGE_RUN_PARAMETERS "$\"PRC8.hif$\""

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;!insertmacro MUI_UNPAGE_CONFIRM
;!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "PRC" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\hak\"
	File "..\CompiledResources\PRC8.hif"
	File "..\CompiledResources\prc8_2das.hak"
	File "..\CompiledResources\prc8_epicspells.hak"
	File "..\CompiledResources\prc8_spells.hak"
	File "..\CompiledResources\prc8_race.hak"
	File "..\CompiledResources\prc8_craft2das.hak"
	File "..\CompiledResources\prc8_misc.hak"
	File "..\CompiledResources\prc8_psionics.hak"
	File "..\CompiledResources\prc8_scripts.hak"
	File "..\CompiledResources\prc8_textures.hak"
	File "..\CompiledResources\prc8_include.hak"
	File "..\CompiledResources\prc8_psionics.hak"
	File "..\CompiledResources\prc8_nsb.hak"
	File "..\CompiledResources\prc8_ocfix.hif"
	SetOutPath "$INSTDIR\PRC\"
	File "..\CompiledResources\PRC8ModuleUpdater.exe"
	File "..\Tools\nwnsc.exe"
	SetOutPath "$INSTDIR\tlk\"
	File "..\tlk\prc8_consortium.tlk"
	SetOutPath "$INSTDIR\erf\"
	File "..\CompiledResources\prc8_consortium.erf"
	File "..\CompiledResources\prc8_ocfix.erf"
	
	SetOutPath "$INSTDIR\override\"
	File "..\CompiledResources\personal_switch.2da"	

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

 ; GetParent
 ; input, top of stack  (e.g. C:\Program Files\Poop)
 ; output, top of stack (replaces, with e.g. C:\Program Files)
 ; modifies no other variables.
 ;
 ; Usage:
 ;   Push "C:\Program Files\Directory\Whatever"
 ;   Call GetParent
 ;   Pop $R0
 ;   ; at this point $R0 will equal "C:\Program Files\Directory"

 Function GetParent

   Exch $R0
   Push $R1
   Push $R2
   Push $R3

   StrCpy $R1 0
   StrLen $R2 $R0

   loop:
     IntOp $R1 $R1 + 1
     IntCmp $R1 $R2 get 0 get
     StrCpy $R3 $R0 1 -$R1
     StrCmp $R3 "\" get
     Goto loop

   get:
     StrCpy $R0 $R0 -$R1

     Pop $R3
     Pop $R2
     Pop $R1
     Exch $R0

 FunctionEnd

; eof
