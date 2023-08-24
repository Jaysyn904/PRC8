; Java Launcher
;--------------
 
;You want to change the next four lines
Name "CharacterCreator"
Caption "PRC/CODI Java Characer Creator"
Icon "prc.ico"
OutFile "CharacterCreator.exe"
 
SilentInstall silent
AutoCloseWindow true
ShowInstDetails nevershow
 
;You want to change the next two lines too
!define JAR "CC.jar"
 
Section ""
  Call GetJRE
  Pop $R0
 
  ; change for your purpose (-jar etc.)
  StrCpy $0 '"$R0" -Xmx200M -Xms200M -jar ${JAR}'
 
 
  SetOutPath $EXEDIR
  ExecWait $0
SectionEnd
 
Function GetJRE
;
;  Find JRE (javaw.exe)
;  1 - in .\jre directory (JRE Installed with application) [removed as it's not for this]
;  2 - in JAVA_HOME environment variable
;  3 - in the registry
;  4 - assume javaw.exe in current dir or PATH
 
  Push $R0
  Push $R1
 
; ClearErrors
; StrCpy $R0 "$EXEDIR\jre\bin\javaw.exe"
; IfFileExists $R0 JreFound
; StrCpy $R0 ""
 
  ClearErrors
  ReadEnvStr $R0 "JAVA_HOME"
  StrCpy $R0 "$R0\bin\javaw.exe"
  IfErrors 0 JreFound
 
  ClearErrors
  ReadRegStr $R1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
  ReadRegStr $R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$R1" "JavaHome"
  StrCpy $R0 "$R0\bin\javaw.exe"
 
  IfErrors 0 JreFound
  StrCpy $R0 "javaw.exe"
 
 JreFound:
  Pop $R1
  Exch $R0
FunctionEnd
