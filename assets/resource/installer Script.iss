; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Buste Paga 2.0"
#define MyAppVersion "2.5.0"
#define MyAppPublisher "3EM"
#define MyAppURL "https://3em.it/"
#define MyAppExeName "buste_paga_sender.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{712DD98C-27DC-4111-9D02-8A1CB5E23936}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\ddant\StudioProjects\BP-Sender-2.0\assets\resource
OutputBaseFilename=Buste Paga Installer 2.0
SetupIconFile=C:\Users\ddant\StudioProjects\BP-Sender-2.0\assets\resource\logo.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\pdfium.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\printing_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\syncfusion_pdfviewer_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\windows_taskbar_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\ddant\StudioProjects\BP-Sender-2.0\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

