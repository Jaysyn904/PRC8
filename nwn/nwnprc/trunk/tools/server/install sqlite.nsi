; Script generated with the Venis Install Wizard

!ifndef PRCSPVERSION
	!define PRCSPVERSION "183"
!endif

!ifndef PRCSPINSTALLVERSION
	!define PRCSPINSTALLVERSION "1.8.3"
!endif

; Define your application name
!define APPNAME "PRC Server Pack"
!define APPNAMEANDVERSION "PRC Server Pack ${PRCSPINSTALLVERSION}"

; Enable LZMA compression for the smallest EXE.
SetCompressor lzma

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\PRC Server Pack"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "Setup PRC Server ${PRCSPINSTALLVERSION}.exe"
Var NWNVERSION
Var NWNPATH
Var NWNPRCPATH
Var NWNMINVERSION

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_TEXT "The PRC Server Pack is now installed.  You can now run NWNX2 to start a server."

!define MUI_WELCOMEPAGE_TEXT "The PRC Server Pack will now be installed into your installation of Neverwinter Nights.\r\n\r\n\r\nNeverwinter Nights version $NWNVERSION is currently installed at $NWNPATH."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "PRC Pack" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$NWNPATH\"
	File "LetoScript.dll"
	File "licence.txt"
	File "madCHook.dll"
	File "NWNX.ini"
	File "NWNX2.exe"
	File "NWNX2.html"
	File "NWNX2_Changelog.txt"
    File "nwnx_core_readme.txt"
	File "nwnx_funcs.dll"
    File "nwnx_funcs_readme.txt"
	File "nwnx_leto.dll"
	File "nwnx_odbc2.html"
	File "nwnx_odbc.dll"
	File "nwnx_odbc2_changelog.txt"
	File "nwnx-module.dll"
    File "nwnx_profiler.dll"
    File "nwnx_profiler.html"
    File "PRC_ServerPack_Install.html"
    File "PRC_ServerPack_ReadMe.txt"

	;Precacher specifics
	File "Precacher_SQLite.bat"
	File "Precacher_MySQL.bat"
	File "sqlite.exe"
	File "7za.exe"
	File "bioware2das.7z"
	File "..\prc.jar"
	File "newMySQLinstall.sql"
	
	;erf for manipulating hak/erf erc
	File "..\erf.exe"
	
	CreateShortCut "$DESKTOP\NWNX2.lnk" "$NWNPATH\NWNX2.exe"
	CreateDirectory "$SMPROGRAMS\PRC Pack"
	CreateShortCut "$SMPROGRAMS\PRC Pack\NWNX2.lnk" "$NWNPATH\NWNX2.exe"
	CreateShortCut "$SMPROGRAMS\PRC Pack\Server Uninstall.lnk" "$NWNPRCPATH\PRCPack\Server Uninstall.exe"
	
	; Now try to output the dir to a 2da file
	FileOpen $0 $NWNPATH\override\directory.2da w
	FileWrite $0 "2DA V2.0$\n"
	FileWrite $0 "$\n"
	FileWrite $0 "   Dir$\n"	
	FileWrite $0 "0  $\"$NWNPATH$\"$\n"
	FileClose $0	

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$NWNPRCPATH\PRCPack"
	WriteRegStr HKLM "Software\${APPNAME}" "PRCPath" "$NWNPRCPATH"
	WriteRegStr HKLM "Software\${APPNAME}" "NWNPath" "$NWNPATH"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$NWNPRCPATH\PRCPack\Server Uninstall.exe"
	WriteUninstaller "$NWNPRCPATH\PRCPack\Server Uninstall.exe"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall
	; Read the install paths from the registry.  Then delete them.
	ReadRegStr $NWNPRCPATH HKLM "Software\${APPNAME}" "PRCPath"
	ReadRegStr $NWNPATH HKLM "Software\${APPNAME}" "NWNPath"

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

	; Delete self
	Delete "$NWNPRCPATH\PRCPack\Server Uninstall.exe"

	; Delete Shortcuts
	Delete "$SMPROGRAMS\PRC Pack\NWNX2.lnk.lnk"
	Delete "$SMPROGRAMS\PRC Pack\Server Uninstall.lnk"
	Delete "$DESKTOP\NWNX2.lnk"

	; Clean up PRC Pack
    Delete "$NWNPATH\LetoScript.dll"
	Delete "$NWNPATH\licence.txt"
	Delete "$NWNPATH\madCHook.dll"
	Delete "$NWNPATH\NWNX2.exe"
	Delete "$NWNPATH\NWNX2_Changelog.txt"
	Delete "$NWNPATH\NWNX2.html"
	Delete "$NWNPATH\NWNX.ini"
    Delete "$NWNPATH\nwnx_core_readme.txt"
	Delete "$NWNPATH\nwnx_funcs.dll"
    Delete "$NWNPATH\nwnx_funcs_readme.txt"
	Delete "$NWNPATH\nwnx_leto.dll"
	Delete "$NWNPATH\nwnx_odbc2.html"
	Delete "$NWNPATH\nwnx_odbc.dll"
	Delete "$NWNPATH\nwnx-module.dll"
	Delete "$NWNPATH\nwnx_odbc2_changelog.txt"
    Delete "$NWNPATH\nwnx_profiler.dll"
    Delete "$NWNPATH\nwnx_profiler.html"
    Delete "$NWNPATH\PRC_ServerPack_Install.html"
    Delete "$NWNPATH\PRC_ServerPack_ReadMe.txt"

	
	;Precacher specifics
	Delete "$NWNPATH\Precacher_SQLite.bat"
	Delete "$NWNPATH\Precacher_MySQL.bat"
	Delete "$NWNPATH\sqlite.exe"
	Delete "$NWNPATH\7za.exe"
	Delete "$NWNPATH\bioware2das.7z"
	Delete "$NWNPATH\prc.jar"
	Delete "newMySQLinstall.sql"
	
	;erf for manipulating hak/erf erc
	Delete "$NWNPATH\erf.exe"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\PRC Pack"
	RMDir "$NWNPRCPATH\PRCPack\"

SectionEnd

; This function loads the NWN installed version and path from the registry
; aborting the install if they are not there.
Function .onInit
	; Minimum version of NWN that the installer requires, just set
	; the string to the part after the 1., i.e. for 1.62 set the
	; string to "62"
	StrCpy $NWNMINVERSION "69"

	; Read the NWN intall path and installed version from the registry.  If we get any
	; errors assume NWN is not installed correctly.
	ReadRegStr $NWNVERSION HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Neverwinter" "Version"
	ReadRegStr $NWNPATH HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Neverwinter" "Location"
	IfErrors noNWN
		
	; Validate that NWNMINVERSION or later of NWN is installed.
	Push $0
	StrCpy $0 $NWNVERSION 2 2
	IntCmp $0 $NWNMINVERSION okNWN badNWN
	Pop $0
	
	okNWN:
	; Validate that XP1 and XP2 are installed
	Push $0
	ClearErrors
	ReadRegStr $0 HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Undrentide" "GUID"
	IfErrors noXP
	ClearErrors
	ReadRegStr $0 HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Underdark" "GUID"
	IfErrors noXP
	Pop $0
	
	; Get the parent directory of the $NWNPATH to use for the prc pack, since
	; the NWN install path always has the nwn\ folder which contains the game,
	; we want the PRC installer EXE and readme's to be parallel to that.
	Push $NWNPATH
	Call GetParent
	Pop $NWNPRCPATH
	
	Return
	
	badNWN:
	MessageBox MB_OK|MB_ICONEXCLAMATION "The PRC pack requires at least version 1.69 of NWN and HotU.  You must upgrade NWN before installing the PRC pack."
	Abort
	
	noXP:
	MessageBox MB_OK|MB_ICONEXCLAMATION "The PRC pack requires Shadows of Undrentide and Hordes of the Underdark to be installed.  You must upgrade NWN before installing the PRC pack.  If you installed the expansions by copying the files directly and did not install them using Bioware's setup applications, then you must reinstall using Bioware's setup applications."
	Abort
	
	noNWN:
	MessageBox MB_OK|MB_ICONEXCLAMATION "Neverwinter Nights is not installed on your PC.  The PRC pack cannot be installed until Neverwinter Nights is installed."
	Abort
FunctionEnd

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