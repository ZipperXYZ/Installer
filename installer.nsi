Unicode true

####################################################################
# Includes

!include MUI2.nsh
!include FileFunc.nsh
!include LogicLib.nsh

!insertmacro Locate
Var /GLOBAL switch_overwrite
!include MoveFileFolder.nsh

####################################################################
# File Info

!define PRODUCT_NAME "ZipperXYZ's ReShade-Preset"
!define PRODUCT_DESCRIPTION "ReShade presets made by ZipperXYZ."
!define COPYRIGHT "Copyright © 2022 sitiom, ZipperXYZ, Extravi"
!define VERSION "1.0.0"
VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileDescription" "${PRODUCT_DESCRIPTION}"
VIAddVersionKey "LegalCopyright" "${COPYRIGHT}"
VIAddVersionKey "FileVersion" "${VERSION}.0"

####################################################################
# Installer Attributes

ManifestDPIAware true

Name "${PRODUCT_NAME}"
Outfile "Setup - ${PRODUCT_NAME}.exe"
Caption "Setup - ${PRODUCT_NAME}"
BrandingText "${PRODUCT_NAME}"

RequestExecutionLevel user
 
InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"

####################################################################
# Interface Settings

InstType "Full";1

####################################################################
# Pages

!define MUI_ICON "FORSHADER.ico"
!define MUI_UNICON "FORSHADER.ico"
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "realimageshader.bmp"
!define MUI_WELCOMEPAGE_TEXT "This will install ${PRODUCT_NAME} on your computer.$\r$\n\
$\r$\n\
Before continuing, ensure that Roblox is closed.$\r$\n\
$\r$\n\
There may be issues with the setup. If that's the case, it's recommended that you ask your questions on ZipperXYZ's Discord server.$\r$\n\
$\r$\n\
Click Next to continue."
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_TEXT_LARGE
!define MUI_FINISHPAGE_TEXT "Setup has finished installing ${PRODUCT_NAME} on your computer. The effects will be applied the next time you launch Roblox.$\r$\n\
$\r$\n\
Click Finish to exit Setup."
!define MUI_FINISHPAGE_SHOWREADME "https://reshade.me/"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Visit reshade.me"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Discord Server etc"
!define MUI_FINISHPAGE_RUN_CHECKED
!define MUI_FINISHPAGE_RUN_FUNCTION "OpenLink"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "ZipperXYZ preset's\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_SHOW "StartTaskbarProgress"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

####################################################################
# Language

!insertmacro MUI_LANGUAGE "English"

####################################################################
# Sections

Var robloxPath

Section "ReShade (required)"
  SectionIn 1 RO
  
  SetOutPath $INSTDIR

  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; Uninstall Regkeys
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "DisplayIcon" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets" "Publisher" "ZipperXYZ"

  NSCurl::http GET "https://github.com/crosire/reshade-shaders/archive/refs/heads/master.zip" "reshade-shaders-master.zip" /END
  nsisunz::Unzip "reshade-shaders-master.zip" "$INSTDIR"
  Delete "reshade-shaders-master.zip"

  NSCurl::http GET "https://github.com/prod80/prod80-ReShade-Repository/archive/refs/heads/master.zip" "prod80-ReShade-Repository-master.zip" /END
  nsisunz::Unzip "prod80-ReShade-Repository-master.zip" "$INSTDIR"
  Delete "prod80-ReShade-Repository-master.zip"
  
  NSCurl::http GET "https://github.com/martymcmodding/qUINT/archive/refs/heads/master.zip" "qUINT-master.zip" /END
  nsisunz::Unzip "qUINT-master.zip" "$INSTDIR"
  Delete "qUINT-master.zip"

  StrCpy $switch_overwrite 1

  !insertmacro MoveFolder "reshade-shaders-master\Shaders" "$robloxPath\reshade-shaders\Shaders" "*"
  !insertmacro MoveFolder "reshade-shaders-master\Textures" "$robloxPath\reshade-shaders\Textures" "*"
  RMDir /r "$INSTDIR\reshade-shaders-master"

  !insertmacro MoveFolder "prod80-ReShade-Repository-master\Shaders" "$robloxPath\reshade-shaders\Shaders" "*"
  !insertmacro MoveFolder "prod80-ReShade-Repository-master\Textures" "$robloxPath\reshade-shaders\Textures" "*"
  RMDir /r "$INSTDIR\prod80-ReShade-Repository-master"

  !insertmacro MoveFolder "qUINT-master\Shaders" "$robloxPath\reshade-shaders\Shaders" "*"
  RMDir /r "$INSTDIR\qUINT-master"

  SetOutPath $robloxPath

  File "ZipperXYZ preset's\dxgi.dll"
  File "ZipperXYZ preset's\ReShade.log"
  File "ZipperXYZ preset's\ReShade.ini"
  File "ZipperXYZ preset's\NunitoSans-Regular.ttf"
  File "ZipperXYZ preset's\ClientSettings.zip"
  nsisunz::Unzip "$robloxPath\ClientSettings.zip" "$robloxPath"
  Delete "$robloxPath\ClientSettings.zip"
SectionEnd

SectionGroup /e "Presets"
  Section "ZipperXYZ preset's"
    SectionIn 1
    File "ZipperXYZ preset's\Zipper colorful shader (Low2).ini"
    File "ZipperXYZ preset's\Zipper colorful shader (bloomy).ini"
    File "ZipperXYZ preset's\Zipper colorful shader.ini"
  SectionEnd
SectionGroupEnd

Section "uninstall"
  ${Locate} "$LOCALAPPDATA\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "un.SetRobloxPath"

  Delete "$INSTDIR\uninstall.exe"
  RMDir /r $INSTDIR

  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\extravi-reshade-presets"

  Delete "$robloxPath\Zipper colorful shader (Low).ini"
  Delete "$robloxPath\Zipper colorful shader (medium).ini"
  Delete "$robloxPath\Zipper colorful shader.ini"
  Delete "$robloxPath\ReShade.ini"
  Delete "$robloxPath\ReShadePreset.ini"
  RMDir /r "$robloxPath\reshade-shaders"
  RMDir /r "$robloxPath\ClientSettings"
  Delete "$robloxPath\dxgi.dll"
  Delete "$robloxPath\ReShade.log"
  Delete "$robloxPath\NunitoSans-Regular.ttf"
SectionEnd

####################################################################
# Functions

Function .onInit
  ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "Troubleshoot"

  StrCpy $robloxPath ""
  ${Locate} "$LOCALAPPDATA\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "SetRobloxPath"  
  
  ${If} $robloxPath == ""
    MessageBox MB_ICONEXCLAMATION "Roblox installation not found. Install Roblox on https://www.roblox.com/download/client and try again."
    ExecShell open "https://www.roblox.com/download/client"
    Abort
  ${EndIf}
FunctionEnd

Function "Troubleshoot"
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "It seems like Roblox is installed system-wide in the Program Files directory. Would you like to attempt to install again under your own user? Make sure you follow all on-screen instructions, and ensure that Roblox is closed before proceeding." IDYES yes
    Abort
    yes:
    MessageBox MB_ICONQUESTION `A User Account Control pop-up will appear, make sure to click "YES".`
    ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=RobloxPlayerBeta.exe" "SetRobloxPath"
    ExecWait '"$robloxPath\RobloxPlayerLauncher.exe"" -uninstall'
    MessageBox MB_ICONQUESTION `Removed Roblox from C:\Program Files (x86). A User Account Control pop-up will appear, make sure to click "NO".`
    ExecWait "$robloxPath\RobloxPlayerLauncher.exe"
    MessageBox MB_ICONQUESTION "Roblox has been reinstalled, if that does not seem to be the case, please check your User Account Control settings."
  Abort
FunctionEnd

Function "SetRobloxPath"
  SetOutPath $R8
  StrCpy $robloxPath $R8
  StrCpy $0 StopLocate
  Push $0
FunctionEnd
Function "un.SetRobloxPath"
  SetOutPath $R8
  StrCpy $robloxPath $R8
  StrCpy $0 StopLocate
  Push $0
FunctionEnd

Function "StartTaskbarProgress"
  w7tbp::Start
FunctionEnd

Function "OpenLink"
  ExecShell "open" "https://discord.gg/q8GHemdrKQ"
FunctionEnd
