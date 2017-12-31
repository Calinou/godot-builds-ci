#define MyAppName "Godot Engine"
#define MyAppVersion "3.0-alpha"
#define MyAppPublisher "Godot Engine contributors"
#define MyAppURL "https://godot.hugo.pro/"
#define MyAppExeName "godot.exe"

[Setup]
AppId={{757DA64B-400E-40F5-B073-A796C34D9D78}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
; Don't add "version {version}" to the installed app name in the Add/Remove Programs menu
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL=https://godotengine.org/
AppUpdatesURL={#MyAppURL}
AppComments=Unofficial Godot Engine editor build
DefaultDirName={localappdata}\Godot
DefaultGroupName=Godot Engine
AllowNoIcons=yes
UninstallDisplayIcon={app}\godot.exe
#ifdef App32Bit
  OutputBaseFilename=Godot-Windows-Installer-x86
#else
  OutputBaseFilename=Godot-Windows-Installer-x86_64
#endif
Compression=lzma
SolidCompression=yes
#ifdef App32Bit
  ArchitecturesAllowed=x64
  ArchitecturesInstallIn64BitMode=x64
#endif
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "godot.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
