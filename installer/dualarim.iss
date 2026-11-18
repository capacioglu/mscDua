; Dualarım — Windows kurulum dosyası (Inno Setup 6)
;
; Önce:   cd apps\mobile && flutter build windows --release
; Derle:  "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" /DAppVersion=1.0.0 installer\dualarim.iss
; Çıktı:  installer\Output\dualarim-setup.exe  (trendbt.com/indir'e AppDist ile: dualarim-setup/dualarim-setup.exe)
;
; Sürüm apps/mobile/pubspec.yaml'daki "version:" değerinin "+" öncesidir; /DAppVersion ile verilir.
; Yönetici yetkisi gerekmez: kullanıcının kendi klasörüne (%LOCALAPPDATA%\Programs\Dualarim) kurulur.

#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif
#define AppName "Dualarım"
#define AppExe "dualarim_mobile.exe"
#define BuildDir "..\apps\mobile\build\windows\x64\runner\Release"

[Setup]
AppId={{5B7C2E41-8D3A-4F6B-9E21-D0A1C3B7F9E4}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=Trend BT
AppPublisherURL=https://trendbt.com/indir/dualarim.php
AppSupportURL=https://trendbt.com/indir/dualarim.php
VersionInfoVersion={#AppVersion}.0
VersionInfoProductVersion={#AppVersion}
VersionInfoProductName={#AppName}
VersionInfoDescription={#AppName} kurulumu
VersionInfoCompany=Trend BT
DefaultDirName={localappdata}\Programs\Dualarim
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
OutputDir=Output
OutputBaseFilename=dualarim-setup
SetupIconFile=..\apps\mobile\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes

[Languages]
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
