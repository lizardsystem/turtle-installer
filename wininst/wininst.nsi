!ifndef APPNAME
  !error "APPNAME undefined, please pass this in the command line (Turtle Urban)."
!endif

!ifndef APPNAMESAFE
  !error "APPNAMESAFE undefined, please pass this in the command line (turtle-urban)."
!endif

!ifndef MODULENAME
  !error "MODULENAME undefined, please pass this in the command line (turtle_urban)."
!endif

!ifndef PUBLISHERNAME
  !echo "Be sure to pass PUBLISHERNAME as defined variable in the command line."
  !define PUBLISHERNAME "Nelen & Schuurmans"
  !echo "Using default PUBLISHERNAME: ${PUBLISHERNAME}"
!endif

!ifndef PYTHONVERSION
  !echo "Be sure to pass PYTHONVERSION as defined variable in the command line."
  !define PYTHONVERSION "2.5"
  !echo "Using default PYTHONVERSION: ${PYTHONVERSION}"
!endif

!ifndef PYTHONBITS
  !echo "Be sure to pass PYTHONBITS as defined variable in the command line."
  !define PYTHONBITS "32"
  !echo "Using default PYTHONBITS: ${PYTHONBITS}"
!endif

!define REGKEY          "Software\${PUBLISHERNAME}\${APPNAME}"
!define REGKEYUNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
!define LIBDIRNAME      "lib-python-${PYTHONVERSION}-${PYTHONBITS}bit"

; Set the name of the language
LoadLanguageFile "Dutch.nlf"

AddBrandingImage top 31

; The name of the installer
Name "${APPNAME}"

; Caption of the installer
Caption "Installatie ${APPNAME}"

; The name of the setup file
OutFile "${APPNAMESAFE}-setup-python-${PYTHONVERSION}-${PYTHONBITS}bit.exe"

; Set default installation directory. Ideally we would like to use the $APPNAME
; variable but InstallDir does not seem to support that.
InstallDir "$PROGRAMFILES\${PUBLISHERNAME}\${APPNAME}"

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "${REGKEY}" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

ShowInstDetails hide

Function .onInit
  ; Extract InstallOptions files
  ; $PLUGINSDIR will automatically be removed when the installer closes
  InitPluginsDir
  File "/oname=$PLUGINSDIR\logo.bmp" logo.bmp
FunctionEnd

Function un.onInit
FunctionEnd

Function .onGUIInit
  SetBrandingImage "$PLUGINSDIR\logo.bmp"
FunctionEnd

Function un.onGUIInit
  SetBrandingImage "$INSTDIR\logo.bmp"
FunctionEnd

;--------------------------------
; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------
; The stuff to install

Section "${APPNAME} (required)"

  SectionIn RO

  DetailPrint "Installeren ${APPNAME}..."

  Sleep 1000

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; We copy the logo that is used by the installer in the installation
  ; directory so it is also available to the uninstaller
  File "logo.bmp"

  ; src module
  SetOutPath "$INSTDIR\src\${MODULENAME}"
  File /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.py"
  File /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.tbx"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.prj"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.txt"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.dll"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.exe"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.svg"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.gif"
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.xsl"
  SetOverwrite off
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.ini"
  SetOverwrite on

  ; copy stub scripts which are referred to by the .tbx
  SetOutPath "$INSTDIR\src\${MODULENAME}"
  File "stubs\*-script.py"

  ; src turtlebase/nens
  SetOutPath "$INSTDIR\src"
  File /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\nens"
  File /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\turtlebase"

  ; libs
  SetOutPath "$INSTDIR\${LIBDIRNAME}"
  File /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" "..\${LIBDIRNAME}\*"

  ; Write the installation path into the registry
  WriteRegStr HKLM "${REGKEY}" "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "${REGKEYUNINSTALL}" "DisplayName" "${APPNAME}"
  WriteRegStr HKLM "${REGKEYUNINSTALL}" "Publisher" "${PUBLISHERNAME}"
  WriteRegStr HKLM "${REGKEYUNINSTALL}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "${REGKEYUNINSTALL}" "NoModify" 1
  WriteRegDWORD HKLM "${REGKEYUNINSTALL}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Optional section (can be disabled by the user)

Section /o "Vervang gebruikersinstellingen (.ini bestanden)"

  DetailPrint "Bezig met vervangen gebruikersinstellingen..."

  Sleep 1000

  SetOutPath "$INSTDIR\src\${MODULENAME}"
  SetOverwrite on
  File /nonfatal /r /x ".git" /x ".svn" /x "_svn" /x "*.pyc" /x "*.pyo" /x "testdata*" "..\src\${MODULENAME}\*.ini"

SectionEnd

;--------------------------------
; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "${REGKEYUNINSTALL}"
  DeleteRegKey HKLM "${REGKEY}"

  ; Remove the installed files and the uninstaller
  Delete "$INSTDIR\logo.bmp"
  Delete "$INSTDIR\uninstall.exe"

  ; RMDir directories are only removed when they are completely empty

  ; src module
  Delete "$INSTDIR\src\${MODULENAME}\*.pyc"
  Delete "$INSTDIR\src\${MODULENAME}\*.pyo"
  Delete "$INSTDIR\src\${MODULENAME}\*.py"
  Delete "$INSTDIR\src\${MODULENAME}\*.tbx"
  Delete "$INSTDIR\src\${MODULENAME}\*.prj"
  Delete "$INSTDIR\src\${MODULENAME}\*.txt"
  Delete "$INSTDIR\src\${MODULENAME}\*.dll"
  Delete "$INSTDIR\src\${MODULENAME}\*.exe"
  Delete "$INSTDIR\src\${MODULENAME}\*.svg"
  Delete "$INSTDIR\src\${MODULENAME}\*.gif"
  Delete "$INSTDIR\src\${MODULENAME}\*.xsl"
  RMDir "$INSTDIR\src\${MODULENAME}"

  ; src turtlebase/nens
  RMDir /r "$INSTDIR\src\nens"
  RMDir /r "$INSTDIR\src\turtlebase"

  RMDir "$INSTDIR\src"

  ; libs
  RMDir /r "$INSTDIR\${LIBDIRNAME}"

  RMDir "$INSTDIR"

SectionEnd
