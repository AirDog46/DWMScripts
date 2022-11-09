@echo off

echo So you want DWM back eh?
echo Well this file is for you.

echo THIS WILL KILL YOUR SESSION SO SAVE ALL YOUR STUFF!
pause

cls
echo Setting windows shell to explorer.exe
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /d explorer.exe /f

echo Moving files back
move %USERPROFILE%\Documents\backup\dlls\* %WINDIR%\System32
move %USERPROFILE%\Documents\backup\exes\* %WINDIR%\System32

echo Restoring ownership
icacls %WINDIR%\System32\dwmcore.dll /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\dwmapi.dll /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\dwmredir.dll /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\dwmscene.dll /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\dwmghost.dll /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\dwminit.dll /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\Windows.UI.Logon.dll /setowner "NT SERVICE\TrustedInstaller"

icacls %WINDIR%\System32\sihost.exe /setowner "NT SERVICE\TrustedInstaller"
icacls %WINDIR%\System32\dwm.exe /setowner "NT SERVICE\TrustedInstaller"

echo Restoring ACLs
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwmcore.dll.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwmapi.dll.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwmredir.dll.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwmscene.dll.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwmghost.dll.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwminit.dll.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\Windows.UI.Logon.dll.acl

icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\dwm.exe.acl
icacls %WINDIR%\System32 /restore %USERPROFILE%\Documents\backup\acls\sihost.exe.acl

echo Removing backup folder
rmdir %USERPROFILE%\Documents\backup /s /q

echo Killing winlogon
%USERPROFILE%\Downloads\PSTools\pskill64.exe /accepteula winlogon.exe